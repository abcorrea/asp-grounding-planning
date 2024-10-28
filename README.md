# CounterAction

Estimate the size of propositional planning tasks from a PDDL
representation, without fully grounding them.

You can run counter action to get the *exact* number of actions or to quickly
compute a lower bound.

## Installation

We recommend using a Python virtual environment. You need to use Python >= 3.7 to execute the scripts.  Once inside the virtual
environment, you can run

```bash
$ pip install -r requirements.txt
```

while in the root directory of the repository. You also need to have the
grounder you want to use in your PATH (see below).

## Basic Usage

The main script is `counter-action.py`. It firsts encodes the PDDL task as a
Datalog program and then grounds it using off-the-shelf tools (`lpopt` and
`gringo`). This encoding, however, does not represent actions. Then, it counts
the *actions* of the task given a set of relaxed-reachable atoms (computed at
the first phase).

To run `counter-action.py`, execute

```bash
$ ./counter-action.py -i /path/to/instance.pddl [-m MODEL-OUTPUT] [-t THEORY-OUTPUT]
```

where `/path/to/instance.pddl` is the path to a *PDDL instance*. It is necessary
that there is a PDDL domain file in the same directory as `instance.pddl`,
though. The script will infer the domain file automatically or you can pass it
with parameter `-d`.

This setting provides an *exact* counting of the number of actions. However, in
some domains, this might be slow. To get quick lower bound on the number of
actions, see extra options below.

## Extra Options

There are some extra options one can use:


- `--domain`: PDDL domain file to be used (otherwise, domain file is inferred)
- `--theory-with-actions-output`: one of the intermediate files produced is a Datalog
  program containing the aciton predicates. This parameter indicates the name of
  this intermediate file.
- `--remove-files`: remove all intermediate files at the end of the execution
- `--inequality-rules`: exploit inequality rules
- `--choices`: enables the generation of choice rules during the counting (recommended)
- `--bound`: bound used for the number of count actions *per action
  schema*. (Bound of 0 enumerates all actions.)
- `--fast`: quickly estimates the number of ground actions. (Ignores the bound
  and is not exact.)
