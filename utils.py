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
    parser = argparse.ArgumentParser(description='Generate models.')
    parser.add_argument('-i', '--instance', required=True, help="The path to the problem instance file.")
    parser.add_argument('--domain', default=None, help="(Optional) The path to the problem domain file. If none is "
                                                       "provided, the system will try to automatically deduce "
                                                       "it from the instance filename.")

    parser.add_argument('-m', '--model-output', default='output.model', help="Model output file.")
    parser.add_argument('-t', '--theory-output', default='output.theory', help="Theory output file.")
    parser.add_argument('--ground-actions', action='store_true', help="Ground actions or not.")
    parser.add_argument('-r', '--remove-files', action='store_true', help="Remove model and theory files.")
    parser.add_argument('--grounder', default='gringo', help="Select grounder.", choices=['gringo', 'newground', 'clingo', 'idlv'])
    parser.add_argument('--suppress-output', action='store_true', help="Suppress grounder output.")
    parser.add_argument('--lpopt-preprocessor', action='store_true', help="Use lpopt to preprocess rules.")
    parser.add_argument('--fd-split', action='store_true', help="Use Fast Downward rule splitting.")
    parser.add_argument('--htd-split', action='store_true', help="Use HTD rule splitting.")
    parser.add_argument("--inequality-rules", dest="inequality_rules", action="store_true", help="add inequalities to rules")
    parser.add_argument("--no-duplicate-arguments", dest="no_duplicate_arguments", action="store_true",
                        help="enforce that all arguments (i.e., variables) in rule heads have different names by adding "
                        "new variables and equality conditions.")

    args = parser.parse_args()
    if args.domain is None:
        args.domain = find_domain_filename(args.instance)
        if args.domain is None:
            raise RuntimeError(f'Could not find domain filename that matches instance file "{args.domain}"')

    return args


def select_grounder(grounder_name):
    grounder = shutil.which(grounder_name)
    if grounder is None:
        print("Grounder %s not found in PATH." % grounder_name)
        raise FileNotFoundError(grounder_name)
    return grounder


def compute_time(start, use_clingo, model):
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
