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
    ("no-context", "out-default"),
    ("k = 0", "out-k0"),
    ("k = 1", "out-k1"),
    ("k = 2", "out-k2"),
    ("k = 3", "out-k3"),
    ("k = 4", "out-k4"),
]

def dump_queries(program_dir):
    for mode, d in DIRS:
        try:
            klee_out = KLEEOut(os.path.join(program_dir, d))
            print "  mode: {}: {}".format(mode, klee_out.resolve_queries)
        except:
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
