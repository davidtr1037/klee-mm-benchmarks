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
    "out-fmm-dfs",
    "out-fmm-bfs",
    "out-fmm-default",
    "out-smm-dfs",
    "out-smm-bfs",
    "out-smm-default",
    "out-dsmm-dfs",
    "out-dsmm-bfs",
    "out-dsmm-default",
]

def dump(program_dir):
    for d in DIRS:
        try:
            klee_out = KLEEOut(os.path.join(program_dir, d), open_stats=False)
            print "  {}: {}".format(d, klee_out.elapsed)
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
        dump(os.path.join(results_dir, p))

if __name__ == "__main__":
    main()
