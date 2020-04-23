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
    ("vanilla", "out-split-vanilla"),
    ("p512", "out-split-p512"),
    ("p256", "out-split-p256"),
    ("p128", "out-split-p128"),
    ("p64", "out-split-p64"),
    ("p32", "out-split-p32"),
]

def dump(program_dir):
    for mode, d in DIRS:
        try:
            ko_path = os.path.join(program_dir, d)
            klee_out = KLEEOut(ko_path)
            print "  mode {}:".format(mode)
            print "    Elapsed: {}".format(klee_out.elapsed)
            print "    Paths: {}".format(klee_out.paths)
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
        dump(os.path.join(results_dir, p))

if __name__ == "__main__":
    main()
