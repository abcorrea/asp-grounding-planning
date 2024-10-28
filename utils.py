import argparse
import os
import shutil
import sys
import tempfile
import time

def find_domain_filename(task_filename):
    """
    Find domain filename for the given task using automatic naming rules.
    """
    dirname, basename = os.path.split(task_filename)

    domain_basenames = [
        "domain.pddl",
        basename[:3] + "-domain.pddl",
        "domain_" + basename,
        "domain-" + basename,
    ]

    for domain_basename in domain_basenames:
        domain_filename = os.path.join(dirname, domain_basename)
        if os.path.exists(domain_filename):
            return domain_filename

def parse_arguments():
    parser = argparse.ArgumentParser(description='Count the # of actions that would be contained in a full grounding, but without executing this grounding.')
    parser.add_argument('-i', '--instance', required=True, help="The path to the problem instance file.")
    parser.add_argument('--domain', default=None, help="(Optional) The path to the problem domain file. If none is "
                                                       "provided, the system will try to automatically deduce "
                                                       "it from the instance filename.")

    parser.add_argument('-m', '--model-output', default='output.model', help="Model output file.")
    parser.add_argument('-t', '--theory-output', default='output.theory', help="Theory output file.")
    parser.add_argument('--theory-with-actions-output', default='output-with-actions.theory', help="Theory containing action predicates output file.")
    parser.add_argument('-r', '--remove-files', action='store_true', help="Remove model and theory files.")
    parser.add_argument("--inequality-rules", dest="inequality_rules", action="store_true", help="add inequalities to rules")
    parser.add_argument('-c', '--choices', required=False, action="store_const", const=True, default=False, help="Enables the generation of choice rules.")
    parser.add_argument('-o', '--output', required=False, action="store_const", const=True, default=False, help="Enables the output of actions.")
    parser.add_argument('-b', '--bound', required=False, type=int, default=0, help="Bound for number of count actions per action schema. (Bound of 0 enumerates all actions.)")
    parser.add_argument('--fast', required=False, action="store_const", const=True, default=False, help="Quickly estimate the number of ground actions. (Ignore the bound and not exact.)")

    args = parser.parse_args()
    if args.domain is None:
        args.domain = find_domain_filename(args.instance)
        if args.domain is None:
            raise RuntimeError(f'Could not find domain filename that matches instance file "{args.domain}"')

    return args


def compute_time(start):
    return (time.time() - start)


def find_lpopt():
    if os.environ.get('LPOPT_BIN_PATH') is not None:
        return os.environ.get('LPOPT_BIN_PATH')
    else:
        print("You need to set an environment variable $LPOPT_BIN_PATH as the path to the binary file of lpopt.")
        sys.exit(-1)


def file_length(filename):
    with open(filename) as f:
        i = 0
        for _, _ in enumerate(f):
            i = i + 1
    return i

def get_number_of_atoms(filename, fd_split, htd_split):
    with open(filename) as f:
        counter = 0
        for line in f.readlines():
            if "__x" not in line and not 'equals(' in line:
                # Ignore temporary and built-in predicates
                counter = counter+1
    return counter

def sanitize(rules):
    new_rules = []
    for r in rules:
        for replacement in ((", ", ","), ("1 = 1,", ""), ("()", "")):
            r = r.replace(*replacement)
        if "_solvable_" in r:
            r = r.replace("_solvable_", "goal_reachable")
        new_rules.append(r)
    return new_rules

def remove_lp_files():
    current_directory = os.getcwd()

    for file_name in os.listdir(current_directory):
        file_path = os.path.join(current_directory, file_name)
        if os.path.isfile(file_path) and (file_name.endswith(".theory") or file_name.endswith(".model")):
            try:
                os.remove(file_path)
            except Exception as e:
                logger.error(f"Error removing {file_path}: {e}")
