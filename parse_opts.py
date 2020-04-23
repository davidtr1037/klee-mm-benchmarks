import sys
import os
from klee_out_parser import KLEEOut

PROGRAMS = [
    "m4",
    "make",
    "sqlite",
    "apr",
]

DIRS = [
    "out-no-opt",
    "out-opt-context",
    "out-opt-reuse",
]

def dump_queries(program_dir):
    for d in DIRS:
        try:
            klee_out = KLEEOut(os.path.join(program_dir, d), open_stats=False)
            print "  {}: {}".format(d, klee_out.elapsed)
        except Exception as e:
            print e
            print "failed {}".format(d)

def main():
    if len(sys.argv) != 2:
        print "Usage: <results_dir>"
        return

    results_dir = sys.argv[1]
    overhead = []
    for p in PROGRAMS:
        print "program: {}".format(p)
        dump_queries(os.path.join(results_dir, p))

if __name__ == "__main__":
    main()
