#! /usr/bin/env python

import re
import sys

from lab.parser import Parser

PATTERNS = [
    ('counter_actions', r'\# of actions: (\d+)', int),
]

class CounterParser(Parser):
    def __init__(self):
        Parser.__init__(self)

        for name, pattern, typ in PATTERNS:
            self.add_pattern(name, pattern, type=typ)


def main():
    parser = CounterParser()
    parser.parse()

main()
