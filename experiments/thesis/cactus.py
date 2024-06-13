# -*- coding: utf-8 -*-

from collections import defaultdict
import os

from lab import tools

from downward.reports import PlanningReport


class CactusPlotReport(PlanningReport):
    def write(self):
        data = defaultdict(list)
        for algo in self.algorithms:
            runtimes = []
            for run in self.runs.values():
                if run["algorithm"] != algo:
                    continue
                if run["ground"]:
                    runtimes.append(int(run["total_time"]))
            runtimes.sort()
            coverage = len(runtimes)
            coords = []
            last_runtime = None
            for runtime in reversed(runtimes):
                if last_runtime is None or runtime < last_runtime:
                    x = runtime
                    y = coverage
                    coords.append((x, y))
                coverage -= 1
                last_runtime = runtime
            coords = reversed(coords)
            for x, y in coords:
                print ("({y}, {x})".format(**locals()))
            print()
            print()
