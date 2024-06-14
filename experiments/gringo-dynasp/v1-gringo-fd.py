#! /usr/bin/env python

import os
import platform

from lab.environments import LocalEnvironment, BaselSlurmEnvironment
from lab.experiment import Experiment

from downward import suites
from downward.reports.absolute import AbsoluteReport
from downward.reports.scatter import ScatterPlotReport

from common_setup import Configuration

from cactus import CactusPlotReport


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
        partition='infai_2',
        memory_per_cpu="6G",
        extra_options='#SBATCH --cpus-per-task=3',
        setup="%s\n%s" % (
            BaselSlurmEnvironment.DEFAULT_SETUP,
            "source /infai/blaas/virtualenvs/asp-grounding-planning/bin/activate\n"),
        export=["PATH", "DOWNWARD_BENCHMARKS", "POWER_LIFTED_DIR"])
else:
    BENCHMARKS_DIR = os.environ["DOWNWARD_BENCHMARKS"]
    SUITE = ['gripper:prob01.pddl',
             'miconic:s1-0.pddl']
    ENV = LocalEnvironment(processes=4)

TIME_LIMIT = 1800
MEMORY_LIMIT = 16384

ATTRIBUTES=['ground',
            'total_time']

# Create a new experiment.
exp = Experiment(environment=ENV)

# Add custom parser for Power Lifted.
exp.add_parser('parser.py')

CONFIGS = [Configuration('gringo-ground-actions', ['--ground-actions', '--clingo']),
           Configuration('gringo-ground-actions+lpopt', ['--ground-actions', '--lpopt-preprocessor', '--clingo']),
           Configuration('gringo-ground-actions+fd', ['--ground-actions', '--fd-split', '--clingo']),
           Configuration('gringo-ground-actions+fd-htd', ['--ground-actions', '--htd-split', '--clingo']),
           Configuration('gringo-no-actions', ['--clingo']),
           Configuration('gringo-no-actions+lpopt', ['--lpopt-preprocessor', '--clingo']),
           Configuration('gringo-no-actions+fd', ['--fd-split', '--clingo']),
           Configuration('gringo-no-actions+fd-htd', ['--htd-split', '--clingo'])]

# Create one run for each instance and each configuration
for config in CONFIGS:
    for task in suites.build_suite(BENCHMARKS_DIR, SUITE):
        run = exp.add_run()
        run.add_resource('domain', task.domain_file, symlink=True)
        run.add_resource('problem', task.problem_file, symlink=True)
        run.add_command('run-search',
                        [RUN_SCRIPT_DIR+'/generate-asp-model.py', '-i', task.problem_file,
                         '-m', '{}-{}-{}.model'.format(config.name, task.domain, task.problem),
                         '-t', '{}-{}-{}.theory'.format(config.name, task.domain, task.problem)] + config.arguments,
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


def domain_as_category(run1, run2):
    # run2['domain'] has the same value, because we always
    # compare two runs of the same problem.
    return run1["domain"]

# Make a report.
exp.add_report(
    BaseReport(attributes=ATTRIBUTES,
               filter=[combine_larger_domains]),
    outfile='report.html')


exp.add_report(ScatterPlotReport(attributes=['total_time'],
                                 filter_algorithm=['gringo-no-actions', 'gringo-no-actions+lpopt'],
                                 filter=[combine_larger_domains],
                                 get_category=domain_as_category,
                                 scale='symlog',
                                 format='tex'),
               outfile='total-time-no-actions.tex')


exp.add_report(ScatterPlotReport(attributes=['total_time'],
                                 filter_algorithm=['gringo-ground-actions', 'gringo-ground-actions+lpopt'],
                                 filter=[combine_larger_domains],
                                 get_category=domain_as_category,
                                 scale='symlog',
                                 format='tex'),
               outfile='total-time-ground-actions.tex')

exp.add_report(CactusPlotReport(filter_algorithm=['gringo-ground-actions',
                                                  'gringo-ground-actions+fd',
                                                  'gringo-ground-actions+fd-htd',
                                                  'gringo-ground-actions+lpopt'],
                                filter=[]),
               name="cactus")

exp.add_report(CactusPlotReport(filter_algorithm=['gringo-no-actions',
                                                  'gringo-no-actions+fd',
                                                  'gringo-no-actions+fd-htd',
                                                  'gringo-no-actions+lpopt'],
                                filter=[]),
               name="cactus-no-actions")


# Parse the commandline and run the specified steps.
exp.run_steps()
