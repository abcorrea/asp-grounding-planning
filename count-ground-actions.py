#!/usr/bin/env python

import re
import os
import io
import subprocess
import utils
import argparse
import multiprocessing
import signal

class ActionsCounter:
    #model_file:  the model of the planning task without grounding actions
    #theory_file: the theory of the plannign task INCLUDING actions
    def __init__(self, model_file, theory_file, gen_choices, output_actions, extended_output):
        self._gen_choices = gen_choices
        self._model = model_file.readlines()
        self._theory = theory_file.readlines()
        self._output = output_actions
        self._extoutput = extended_output
        #self._vars = {}
        #self._pos = {}
        #self._preds = {}
        #self.parseActions(theory_file.readlines())

    def generateRegEx(self, name):
        return re.compile("(?P<total>(?P<name>{}\w+)\s*(!=(?P<param>\s*\w+\s*)|\((?P<params>(\s*\w+\s*,?)+)\)?))".format(name))

    def getPred(self, match):
        if match is None:
            #print("nomatch")
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

    #def parseActionsStream(self):
    #    return self.parseActions(self._theory.readlines())

    def parseActions(self):
        lines = self._theory
        r = self.generateRegEx("^action_")
        rl = self.generateRegEx("")
        cnt = 0
        #prog = io.StringIO()
        #rule = io.StringIO()
        for l in lines:
            prog = io.StringIO()
            rule = io.StringIO()
            #typelist = io.StringIO()
            #print(l)
            head = self.getPred(r.match(l))
            if not head is None:
                #print(head)
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
                        #print(body[2:])
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
                if not self._extoutput:
                    #prog.write("{0} }} 1.\n".format(typelist.getvalue()))
                #else:
                    prog.write(":- not {}.\n".format(head[1]))
                    if not self._output:
                        prog.write("#show {}/0.\n".format(head[1]))
                    rule.write(".\n")
                #else:
                #    prog.write("#show {}/{}.\n".format(head[1], len(head[2:])))
                #    prog.write("{}({}) :- \n".format(head[1], ",".join(head[2:])))
                #    for p in rl.finditer(l, len(head[0])):
                    p, l = self.decomposeAction(rule.getvalue())
                    prog.write(p)
                #print(_vars, self._preds, _pos)
                #print(prog.getvalue())
                #print(len(body[2:]) + 2)
                yield prog.getvalue(), l + 1 + ln * (len(body[2:]) + 2), head[1]
        #return prog.getvalue()



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
            print("% # of actions (intermediate result): {}{}".format(cnt, "+" if lowerb else ""))
        return "{}{}".format(cnt, "+" if lowerb else "")

    def countAction(self, prog, nbrules, pred):
        lpcnt = args.counter_path
        assert(lpcnt is not None)
        if lpcnt == 'lpcnt_bound':
            command = ["src/scripts/"+lpcnt, args.bound]
        else:
            command = ["src/scripts/"+lpcnt]

        inpt = io.StringIO()
        inpt.writelines(self._model)
        inpt.write(prog)
        #debug output
        #f=open(pred, "w")
        #f.write(inpt.getvalue())
        #f.close()
        with (subprocess.Popen(command, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)) as proc:
            print("% counting {} on {} facts (model) and {} rules (theory + encoding for counting)".format(pred, len(self._model), nbrules))

            proc.stdin.write(inpt.getvalue().encode()) #rule)

            proc.stdin.flush()
            proc.stdin.close()

            res = None
            #print(proc.stdout.read())
            r = None
            if self._extoutput:
                r = self.generateRegEx("^g_")
            else:
                r = self.generateRegEx("^p_")
            for line in proc.stdout:
                #print(line)
                line = line.decode()
                #if not line:
                #    break
                #line = lne.decode().split("\n") #any whitespace
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
                        #print(line,self._preds)
                        for l in line.split(" "):
                            atom = self.getPred(r.match(l))
                            if not atom is None:
                                ip = 0
                                for px in atom[2:]:
                                    k = (atom[1],ip)
                                    #print(self._preds,k,px)
                                    if k in self._preds.keys():
                                        ps[self._preds[k]] = px
                                    ip = ip + 1
                    elif line.startswith("g_"):
                        ps = [None] * len(self._vars)
                        #print(line)
                        for l in line.split(" "):
                            atom = self.getPred(r.match(l))
                            #print(self._preds,self._vars)
                            if not atom is None and atom[1][2:] in self._vars: # only arity one
                                #print(self._vars[atom[1][2:]])
                                ps[self._vars[atom[1][2:]]] = atom[2]
                    #print(ps)
                    print("{}({})".format(pred, ",".join(ps))) #[i for i in ps if i is not None])))
            proc.stdout.close()
        return res


    def decomposeAction(self, rules):
        prog = io.StringIO()
        lpopt = os.environ.get('LPOPT_BIN_PATH')
        assert(lpopt is not None)
        with (subprocess.Popen([lpopt], stdin=subprocess.PIPE, stdout=subprocess.PIPE)) as proc:
            prog.writelines(proc.communicate(rules.encode())[0].decode())
            #proc.stdin.write(rule)
            #proc.stdin.flush()
            #proc.stdin.close()
            #prog.writelines(proc.stdout.readlines())
        #print("DECOMPOSE {} {}".format(rules, prog.getvalue()))
        return prog.getvalue(), len(prog.getvalue().split("\n"))

def sigterm(sig,frame):
    for child in multiprocessing.active_children():
        child.terminate()
    exit(0)


# for quick testing (use case: direct translator)
# todo exception handling for io, signal handling, ...
if __name__ == "__main__":

    parser = argparse.ArgumentParser(description='Count the # of actions that would be contained in a full grounding. Requires to set env variable LPCNT_AUX_PATH containing auxiliary binaries used in lpcnt AND executing source $LPCNT_AUX_PATH/set_env_vars.sh first (or setting those environment variables right)')
    parser.add_argument('-m', '--model', required=True, help="The (compact) model of the theory without grounding actions.")
    parser.add_argument('-t', '--theory', required=True, help="The (full) theory containing actions.")
    parser.add_argument('-c', '--choices', required=False, action="store_const", const=True, default=False, help="Enables the generation of choice rules.")
    parser.add_argument('-o', '--output', required=False, action="store_const", const=True, default=False, help="Enables the output of actions.")
    parser.add_argument('-b', '--bound', required=False, default='0', help="Bound for number of count actions per action schema. (Bound of 0 enumerates all actions.)")
    parser.add_argument('-e', '--extendedOutput', required=False, action="store_const", const=True, default=False, help="Enables the extended output of actions.")
    parser.add_argument('--counter-path', required=False, default="LPCNT_BIN_PATH", help="Environment value used for lpcnt. Allows to test different lpcnt versions.")
    args = parser.parse_args()

    assert(os.environ.get('LPOPT_BIN_PATH') is not None)

    #a = ActionsCounter(open("output.cnt"), open("output.theory-full"))
    #print("\n".join(a.parseActions()))


    signal.signal(signal.SIGTERM, sigterm)
    signal.signal(signal.SIGINT, sigterm)

    a = ActionsCounter(open(args.model), open(args.theory), args.choices, args.output, args.extendedOutput)
    print("% # of actions: {}".format(a.countActions(a.parseActions())))
    if a._bound:
        exit(10)
