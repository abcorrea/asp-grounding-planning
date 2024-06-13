#! /usr/bin/env python

import re
import sys

from lab.parser import Parser

PATTERNS = [
    ('ground', r'Gringo finished correctly: (\d+)', int),
    ('total_time', r'Total time \(in seconds\): (.+)s', float),
    ('model_size', r'Size of the model: (\d+)', int),
    ('atoms', r'Number of atoms \(not actions\): (\d+)', int)
]

class OurParser(Parser):
    def __init__(self):
        Parser.__init__(self)

        for name, pattern, typ in PATTERNS:
            self.add_pattern(name, pattern, type=typ)


def main():
    parser = OurParser()
    parser.parse()

main()
