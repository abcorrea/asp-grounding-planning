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
IPC_BENCHMARKS = os.environ["DOWNWARD_BENCHMARKS"]
HTG_BENCHMARKS = os.environ["HTG_BENCHMARKS_FLATTENED"]
RUN_SCRIPT_DIR = str(Path(os.getcwd()).parent.parent)

if REMOTE:
    IPC_SUITE = ['airport', 'barman-sat14-strips', 'blocks',
             'childsnack-sat14-strips', 'depot', 'driverlog', 'freecell', 'grid',
             'gripper', 'logistics00', 'logistics98', 'miconic', 'movie',
             'mystery', 'nomystery-sat11-strips', 'openstacks-strips',
             'parking-sat11-strips', 'parking-sat14-strips',
             'pipesworld-notankage', 'pipesworld-tankage', 'psr-small', 'rovers',
             'satellite', 'thoughtful-sat14-strips', 'tpp', 'trucks-strips',
             'visitall-sat11-strips', 'visitall-sat14-strips', 'zenotravel']
    HTG_SUITE = ['blocksworld-large-simple',
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
            "source /infai/blaas/virtualenvs/newground/bin/activate\n"),
        export=["PATH", "DOWNWARD_BENCHMARKS", "POWER_LIFTED_DIR"])
else:
    IPC_SUITE = ['gripper:prob01.pddl',
             'miconic:s1-0.pddl']
    HTG_SUITE = []
    ENV = LocalEnvironment(processes=4)

TIME_LIMIT = 1800
MEMORY_LIMIT = 16384

ATTRIBUTES=['ground',
            'total_time',
            'model_size',
            'atoms',
            'run_dir']

# Create a new experiment.
exp = Experiment(environment=ENV)

# Add custom parser for Power Lifted.
exp.add_parser('parser.py')

CONFIGS = []

for grounder in ['clingo']:
    CONFIGS = CONFIGS + [Configuration(f'{grounder}-ground-actions', ['--ground-actions', '--grounder', grounder, '--suppress-output']),
                         Configuration(f'{grounder}-ground-actions+lpopt', ['--ground-actions', '--lpopt-preprocessor', '--grounder', grounder, '--suppress-output']),
                         Configuration(f'{grounder}-ground-actions+fd', ['--ground-actions', '--fd-split', '--grounder', grounder, '--suppress-output']),
                         Configuration(f'{grounder}-no-actions', ['--grounder', grounder, '--suppress-output']),
                         Configuration(f'{grounder}-no-actions+lpopt', ['--lpopt-preprocessor', '--grounder', grounder, '--suppress-output']),
                         Configuration(f'{grounder}-no-actions+fd', ['--fd-split', '--grounder', grounder, '--suppress-output'])]

# Create one run for each instance and each configuration
for config in CONFIGS:
    for task in suites.build_suite(IPC_BENCHMARKS, IPC_SUITE) + suites.build_suite(HTG_BENCHMARKS, HTG_SUITE):
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


def found_model(run):
    atoms = run.get('atoms')
    if atoms is not None:
        if atoms > 0:
            run['has_model'] = 1
        else:
            run['has_model'] = 0
    else:
        run['has_model'] = 0
    return run

IPC_DOMAINS = ['airport', 'barman-sat14-strips', 'blocks',
             'childsnack-sat14-strips', 'depot', 'driverlog', 'freecell', 'grid',
             'gripper', 'logistics00', 'logistics98', 'miconic', 'movie',
             'mystery', 'nomystery-sat11-strips', 'openstacks-strips',
             'parking-sat11-strips', 'parking-sat14-strips',
             'pipesworld-notankage', 'pipesworld-tankage', 'psr-small', 'rovers',
             'satellite', 'thoughtful-sat14-strips', 'tpp', 'trucks-strips',
             'visitall-sat11-strips', 'visitall-sat14-strips', 'zenotravel']
def is_htg(run):
    return not (run['domain'] in IPC_DOMAINS)

def is_ipc(run):
    return run['domain'] in IPC_DOMAINS

# Make a report.
exp.add_report(
    BaseReport(attributes=ATTRIBUTES + ['has_model'],
               filter=[combine_larger_domains,found_model]),
    outfile='report.html')

exp.add_report(
    BaseReport(attributes=ATTRIBUTES + ['has_model'],
               filter=[combine_larger_domains,found_model, is_htg]),
    outfile='htg.html')

exp.add_report(ScatterPlotReport(attributes=['total_time'],
                                 filter_algorithm=['clingo-no-actions', 'clingo-no-actions+lpopt'],
                                 filter=[combine_larger_domains, is_htg],
                                 get_category=domain_as_category,
                                 scale='symlog',
                                 format='tex'),
               outfile='total-time-no-actions')

exp.add_report(ScatterPlotReport(attributes=['total_time'],
                                 filter_algorithm=['clingo-ground-actions', 'clingo-ground-actions+lpopt'],
                                 filter=[combine_larger_domains],
                                 get_category=domain_as_category,
                                 scale='symlog',
                                 format='tex'),
               outfile='total-time-ground-actions.tex')


# Parse the commandline and run the specified steps.
exp.run_steps()
