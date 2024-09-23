#! /usr/bin/env python

import os
import platform

from lab.environments import LocalEnvironment, BaselSlurmEnvironment
from lab.experiment import Experiment

from downward import suites
from downward.reports.absolute import AbsoluteReport
from downward.reports.scatter import ScatterPlotReport

from common_setup import Configuration


from pathlib import Path

# Create custom report class with suitable info and error attributes.
class BaseReport(AbsoluteReport):
    INFO_ATTRIBUTES = []
    ERROR_ATTRIBUTES = [
        'domain', 'problem', 'algorithm', 'unexplained_errors', 'error', 'node']

NODE = platform.node()
REMOTE = NODE.endswith(".scicore.unibas.ch") or NODE.endswith(".cluster.bc2.ch")
BENCHMARKS_DIR = os.environ["HTG_BENCHMARKS_FLATTENED"]
RUN_SCRIPT_DIR = str(Path(os.getcwd()).parent.parent)

if REMOTE:
    SUITE = ['blocksworld-large-simple',
             'childsnack-contents-parsize1-cham3',
             'childsnack-contents-parsize1-cham5',
             'childsnack-contents-parsize1-cham7',
             'childsnack-contents-parsize2-cham3',
             'childsnack-contents-parsize2-cham5',
             'childsnack-contents-parsize2-cham7',
             'childsnack-contents-parsize3-cham3',
             'childsnack-contents-parsize3-cham5',
             'childsnack-contents-parsize3-cham7',
             'childsnack-contents-parsize4-cham3',
             'childsnack-contents-parsize4-cham5',
             'childsnack-contents-parsize4-cham7',
             'genome-edit-distance',
             'genome-edit-distance-split',
             'logistics-large-simple',
             'organic-synthesis-alkene',
             'organic-synthesis-MIT',
             'organic-synthesis-original',
             'pipesworld-tankage-nosplit',
             'rovers-large-simple',
             'visitall-multidimensional-3-dim-visitall-CLOSE-g1',
             'visitall-multidimensional-3-dim-visitall-CLOSE-g2',
             'visitall-multidimensional-3-dim-visitall-CLOSE-g3',
             'visitall-multidimensional-3-dim-visitall-FAR-g1',
             'visitall-multidimensional-3-dim-visitall-FAR-g2',
             'visitall-multidimensional-3-dim-visitall-FAR-g3',
             'visitall-multidimensional-4-dim-visitall-CLOSE-g1',
             'visitall-multidimensional-4-dim-visitall-CLOSE-g2',
             'visitall-multidimensional-4-dim-visitall-CLOSE-g3',
             'visitall-multidimensional-4-dim-visitall-FAR-g1',
             'visitall-multidimensional-4-dim-visitall-FAR-g2',
             'visitall-multidimensional-4-dim-visitall-FAR-g3',
             'visitall-multidimensional-5-dim-visitall-CLOSE-g1',
             'visitall-multidimensional-5-dim-visitall-CLOSE-g2',
             'visitall-multidimensional-5-dim-visitall-CLOSE-g3',
             'visitall-multidimensional-5-dim-visitall-FAR-g1',
             'visitall-multidimensional-5-dim-visitall-FAR-g2',
             'visitall-multidimensional-5-dim-visitall-FAR-g3']
    ENV = BaselSlurmEnvironment(
        partition='infai_1',
        setup="%s\n%s" % (
            BaselSlurmEnvironment.DEFAULT_SETUP,
            "source /infai/blaas/virtualenvs/newground/bin/activate\n"),
        export=["PATH", "DOWNWARD_BENCHMARKS", "POWER_LIFTED_DIR"])
else:
    BENCHMARKS_DIR = os.environ["DOWNWARD_BENCHMARKS"]
    SUITE = ['gripper:prob01.pddl',
             'miconic:s1-0.pddl']
    ENV = LocalEnvironment(processes=4)

TIME_LIMIT = 1800
MEMORY_LIMIT = 3872

ATTRIBUTES=['counter_actions', 'gringo_time', 'newground_time', 'run_dir']

# Create a new experiment.
exp = Experiment(environment=ENV)

# Add custom parser for Power Lifted.
exp.add_parser('parser.py')
exp.add_parser('counter-parser.py')

CONFIGS = [Configuration('baseline', ['--grounder', 'gringo', '--lpopt-preprocessor']),
           Configuration('with-inequalities', ['--grounder', 'gringo', '--lpopt-preprocessor', '--inequality-rules'])]

# Create one run for each instance and each configuration
for config in CONFIGS:
    for task in suites.build_suite(BENCHMARKS_DIR, SUITE):
        run = exp.add_run()
        model_name = '{}-{}-{}.model'.format(config.name, task.domain, task.problem)
        theory_name = '{}-{}-{}.theory'.format(config.name, task.domain, task.problem)
        theory_with_actions = '{}-{}-{}-with-actions.theory'.format(config.name, task.domain, task.problem)
        run.add_resource('domain', task.domain_file, symlink=True)
        run.add_resource('problem', task.problem_file, symlink=True)
        run.add_command('run-grounder',
                        [RUN_SCRIPT_DIR+'/generate-asp-model.py', '-i', task.problem_file,
                         '-m', model_name,
                         '-t', theory_name] + config.arguments,
                        time_limit=TIME_LIMIT,
                        memory_limit=MEMORY_LIMIT)
        run.add_command('run-counter',
                        [RUN_SCRIPT_DIR+'/count-ground-actions.py',
                         '-m', model_name,
                         '-t', theory_with_actions,
                         '-e'],
                        time_limit=TIME_LIMIT,
                        memory_limit=MEMORY_LIMIT)
        run.set_property('domain', task.domain)
        run.set_property('problem', task.problem)
        run.set_property('algorithm', config.name)
        run.set_property('id', [config.name, task.domain, task.problem])

        # Add step that writes experiment files to disk.
exp.add_step('build', exp.build)

# Add step that executes all runs.
exp.add_step('start', exp.start_runs)

# Add step that collects properties from run directories and
# writes them to *-eval/properties.
exp.add_fetcher(name='fetch')

def combine_larger_domains(run):
    if 'childsnack-contents-parsize' in run['domain']:
        run['problem'] = '{}-{}'.format(run['domain'], run['problem'])
        run['domain'] = 'childsnacks-large'
        return run
    if 'visitall-multidimensional' in run['domain']:
        run['problem'] = '{}-{}'.format(run['domain'], run['problem'])
        run['domain'] = 'visitall-multidimensional'
        return run
    if 'genome-edit-distance' in run['domain']:
        run['problem'] = '{}-{}'.format(run['domain'], run['problem'])
        run['domain'] = 'genome-edit-distance'
        return run
    if 'organic-synthesis-' in run['domain']:
        run['problem'] = '{}-{}'.format(run['domain'], run['problem'])
        run['domain'] = 'organic-synthesis'
        return run
    return run

def model_computation_finished(run):
    atoms = run.get('counter_actions')
    if atoms is not None:
        run['has_model'] = 1
    else:
        run['has_model'] = 0
    return run

def pipeline_time(run):
    gringo = run.get('gringo_time')
    newground = run.get('newground_time')
    solved = run.get('has_model')
    if solved == 1 and gringo is not None and newground is not None:
        run['added_time'] = gringo + newground
    else:
        run['added_time'] = None
    return run

def domain_as_category(run1, run2):
    # run2['domain'] has the same value, because we always
    # compare two runs of the same problem.
    return run1["domain"]

# Make a report.
exp.add_report(
    BaseReport(attributes=ATTRIBUTES + ['has_model', 'added_time'],
               filter=[combine_larger_domains, model_computation_finished, pipeline_time]),
    outfile='report.html')

exp.add_report(
    BaseReport(attributes=ATTRIBUTES),
    outfile='count-org-synthesis.html')

# Parse the commandline and run the specified steps.
exp.run_steps()
