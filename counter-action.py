#!/usr/bin/env python

import argparse
import os
import io
import logging
import multiprocessing
import re
import signal
import subprocess
import sys
import uuid

from subprocess import Popen, PIPE

from tarski.reachability import create_reachability_lp, run_clingo
from tarski.utils.command import silentremove, execute

from utils import *

logging.basicConfig(
    stream=sys.stdout,
    level=logging.INFO,
    format="[%(asctime)s.%(msecs)03d] %(levelname)s ::: %(message)s",
    datefmt='%H:%M:%S'
)
logger = logging.getLogger(__name__)


class ActionsCounter:
    # model_file:  the model of the planning task without grounding actions
    # theory_file: the theory of the plannign task INCLUDING actions
    def __init__(self, model_file, theory_file, gen_choices, output_actions, counter):
        self._gen_choices = gen_choices
        self._model = model_file.readlines()
        self._theory = theory_file.readlines()
        self._output = output_actions
        self._extoutput = True
        self._counter = counter

    def generateRegEx(self, name):
        return re.compile("(?P<total>(?P<name>{}\w+)\s*(!=(?P<param>\s*\w+\s*)|\((?P<params>(\s*\w+\s*,?)+)\)?))".format(name))

    def getPred(self, match):
        if match is None:
            return None
        else:
            if match.group("params") is not None:
                return [match.group("total"),match.group("name"),] + list(map(lambda x: x.strip(), match.group("params").split(",")))
            else:
                return [match.group("total"), "!=", match.group("name"), match.group("param")]

    def get_atoms_from_body(self, rule):
        body = rule.split(":-")[1].strip()[:-1]
        pattern = r'[a-zA-Z_]+\([^\)]+\)'
        atoms = re.findall(pattern, body)
        return atoms

    def parseActions(self):
        lines = self._theory
        r = self.generateRegEx("^action_")
        rl = self.generateRegEx("")
        cnt = 0
        for l in lines:
            prog = io.StringIO()
            rule = io.StringIO()
            head = self.getPred(r.match(l))
            if not head is None:
                ip = 0
                self._preds = {}
                self._vars = {}
                _types = {}
                _pos = set()
                #done = set()
                for pb in head[2:]:
                    self._vars[pb] = ip
                    ip = ip + 1
                rule.write(head[1] + " :- ")
                ln = 0
                written = False
                #typelist.write("1 {{ {0} : ".format(head[0]))
                body_atoms = self.get_atoms_from_body(l)
                for p in rl.finditer(l, len(head[0])):
                    if written: #not skip and ln > 0:
                        rule.write(",")
                    written = False
                    body = self.getPred(p)
                    #for pb in body[2:]:
                    #    if not pb in self._vars.keys():
                    #        self._vars[pb] = ip
                    #        ip = ip + 1
                    assert(body is not None)
                    if body[1].startswith("pddl_type"):
                        #if ln > 0:
                        #    typelist.write(",")
                        #typelist.write(body[0])
                        if self._extoutput:
                            for t in body[2]:
                                _types[t] = body[0]
                            cond = []
                            for body_atom in body_atoms:
                                if body[2] in body_atom:
                                    cond.append(body_atom)
                            prog.write("1 {{ g_{0}({0}) : {1} }} 1.\n".format(body[2], ",".join(cond)))
                            #prog.write("1 {{ g_{0}({0}) : {1} }} 1.\n".format(body[2], body[0]))
                            #if self._output:
                            prog.write("#show g_{0}/1.\n".format(body[2]))
                        rule.write(body[0])
                        written = True
                    else: #get predicate and predicate with copy vars
                        cnt = cnt + 1
                        pnam = "p_{}{}".format(cnt,body[1])
                        #rule.write(pcopy)
                        pred = body[0] # "{}({})".format(body[1], ",".join(body[2:]))
                        #if "!=" in body[0]:
                        #    pred = "{}!=({})".format(body[1], ",".join(body[2:]))
                        ip = 0
                        if body[1] != "!=":
                            written = True
                            rule.write("p_{0}{1}".format(cnt, pred))
                        #if body[1] not in done:
                        if self._output and body[1] != "!=":
                            for pb in body[2:]: #exclude body-only vars
                                if pb in self._vars and self._vars[pb] not in _pos: #has_key(self._vars[p]):
                                    _pos.add(self._vars[pb]) # (pnam, ip)
                                    #ps = self._preds[pnam] if ip > 0 {} else
                                    #self._preds[pnam] = ps
                                    self._preds[(pnam,ip)] = self._vars[pb]
                                ip = ip + 1
                        cpred = "{}({}_c)".format(body[1], "_c,".join(body[2:]))
                        if self._extoutput:
                            if body[1] == "!=":
                                prog.write(":- {0}".format(pred.replace("!", "")))
                            else:
                                prog.write(":- not {0}".format(pred))
                            for pb in body[2:]:
                                prog.write(", g_{0}({0})".format(pb))
                            prog.write(".\n")
                        elif self._gen_choices and body[1] != "!=":
                            prog.write("1 {{ p_{1}{0} : {0} }} 1.\n".format(pred, cnt))
                        elif body[1] != "!=":
                            prog.write("p_{1}{0} :- not n_{1}{0}, {0}. n_{1}{0} :- not p_{1}{0}, {0}.\n".format(pred, cnt))
                            for par in body[2:]:
                                prog.write(":- p_{3}{0}, p_{3}{1}, {2} > {2}_c.\n".format(pred, cpred, par, cnt))
                        if not self._extoutput and self._output and body[1] != "!=":
                            prog.write("#show p_{1}{0}/{2}.\n".format(body[1], cnt, len(body[2:])))
                    ln = ln + 1
                l = 0
                yield prog.getvalue(), l + 1 + ln * (len(body[2:]) + 2), head[1]



    def countActions(self, stream):
        cnt = 0
        self._bound = False
        lowerb = False
        for cnts, nbrules, predicate in stream:
            res = self.countAction(cnts, nbrules, predicate)
            if not res is None:
                cnt += res
            else:
                self._bound = True
            if self._bound:
                lowerb = True
            logging.info("# of actions (intermediate result): {}{}".format(cnt, "+" if lowerb else ""))
        return "{}{}".format(cnt, "+" if lowerb else "")

    def countAction(self, prog, nbrules, pred):
        lpcnt = self._counter
        assert(lpcnt is not None)
        if lpcnt == 'lpcnt':
            command = ["src/scripts/"+lpcnt, str(args.bound)]
        else:
            command = ["src/scripts/"+lpcnt]

        inpt = io.StringIO()
        inpt.writelines(self._model)
        inpt.write(prog)

        with (Popen(command, stdin=PIPE, stdout=PIPE, stderr=PIPE)) as proc:
            logging.info("Counting {} on {} facts and {} rules".format(pred, len(self._model), nbrules))

            proc.stdin.write(inpt.getvalue().encode()) #rule)

            proc.stdin.flush()
            proc.stdin.close()

            res = None

            r = None
            if self._extoutput:
                r = self.generateRegEx("^g_")
            else:
                r = self.generateRegEx("^p_")
            for line in proc.stdout:
                line = line.decode()

                if line.startswith("s "):
                    res = int(line[2:])
                elif line.startswith("Models       : "):
                    pos = -1 if line.find("+") > -1 else len(line)
                    res = int(line[15:pos].replace('+',''))
                    if pos == -1:
                        self._bound = True
                elif self._output and line.startswith("p_") or line.startswith("g_"):
                    ps = None
                    if line.startswith("p_"): # or line.startswith("g_"):
                        ps = [None] * len(self._preds)
                        for l in line.split(" "):
                            atom = self.getPred(r.match(l))
                            if not atom is None:
                                ip = 0
                                for px in atom[2:]:
                                    k = (atom[1],ip)
                                    if k in self._preds.keys():
                                        ps[self._preds[k]] = px
                                    ip = ip + 1
                    elif line.startswith("g_"):
                        ps = [None] * len(self._vars)
                        for l in line.split(" "):
                            atom = self.getPred(r.match(l))
                            if not atom is None and atom[1][2:] in self._vars: # only arity one
                                ps[self._vars[atom[1][2:]]] = atom[2]

                    logging.info("{}({})".format(pred, ",".join(ps))) #[i for i in ps if i is not None])))
            proc.stdout.close()
        return res

def sigterm(sig,frame):
    for child in multiprocessing.active_children():
        child.terminate()
    exit(0)


# for quick testing (use case: direct translator)
# todo exception handling for io, signal handling, ...
if __name__ == "__main__":
    args = parse_arguments()

    domain_file = args.domain
    instance_file = args.instance
    if not os.path.isfile(domain_file):
        sys.stderr.write("Error: Domain file does not exist.\n")
        sys.exit()
    if not os.path.isfile(instance_file):
        sys.stderr.write("Error: Instance file does not exist.\n")
        sys.exit()

    theory_output = args.theory_output
    theory_output_with_actions = args.theory_with_actions_output
    logging.info("Saving extra copy of theory with actions to %s" % theory_output_with_actions)

    dir_path = os.path.dirname(os.path.realpath(__file__))
    command=[dir_path+'/src/translate/pddl_to_prolog.py', domain_file,
             instance_file, '--only-output-direct-program',
             '--remove-action-predicates']
    execute(command, stdout=theory_output)
    logging.info("ASP model being copied to %s" % theory_output)

    # Produces extra theory file with actions
    command=[dir_path+'/src/translate/pddl_to_prolog.py', domain_file,
                 instance_file, '--only-output-direct-program']
    if args.inequality_rules:
        command.extend(['--inequality-rules'])
    execute(command, stdout=theory_output_with_actions)
    logging.info("ASP model *with actions* being copied to %s" % theory_output_with_actions)

    lpopt = "./bin/lpopt"
    temporary_filename = str(uuid.uuid4())
    command = [lpopt, "-f", theory_output]
    temp_file = open(temporary_filename, "w+t")
    execute(command, stdout=temporary_filename)
    os.rename(temporary_filename, theory_output)


    grounder = "./bin/gringo"

    model_output = args.model_output
    with open(model_output, 'w+t') as output:
        start_time = time.time()
        command = [grounder, theory_output, '--output', 'text']
        process = Popen(command, stdout=PIPE, stdin=PIPE, stderr=PIPE, text=True)
        grounder_output = process.communicate()[0]
        print(grounder_output, file=output)
        if process.returncode == 0:
            # For some reason, clingo returns 30 for correct exit
            logging.info("Gringo finished correctly: 1")
            logging.info("Total time (in seconds): %0.5fs" % compute_time(start_time))
            logging.info("Number of atoms (not actions): %s" % str(len(grounder_output.split('\n')) - 1))
        else:
            logging.error(f"Something went wrong with gringo! Gringo's exit code: {process.returncode}.")
            logging.info("Gringo finished correctly: 0")


    counter = "lpcnt"
    if args.fast:
        if args.bound != 0:
            logging.error("Flag '--fast' only works with bound 0 (i.e., no bound).")
            sys.exit(-1)
        counter = "lpcnt_nopp"


    signal.signal(signal.SIGTERM, sigterm)
    signal.signal(signal.SIGINT, sigterm)

    a = ActionsCounter(open(args.model_output), open(args.theory_with_actions_output), args.choices, args.output, counter)
    logging.info("# of actions: {}".format(a.countActions(a.parseActions())))
    if a._bound:
        sys.exit(10)

    if args.remove_files:
        logging.info("Removing intermediate files.")
        silentremove(args.model_output)
        silentremove(theory_output)
        silentremove(args.theory_with_actions_output)
    logging.info("Done!")
