import sys
import os
from klee_out_parser import KLEEOut

PROGRAMS = [
    "m4",
    "make",
    "sqlite",
    "apr",
    "gas",
    "libxml2",
    "cat",
    "expr",
    "factor",
    "hostid",
    "nice",
    "nl",
    "numfmt",
    "printf",
    "sort",
    "stdbuf",
    "timeout",
    "tr",
    "truncate",
    "base32",
    "stty",
]

def main():
    if len(sys.argv) != 2:
        print "Usage: <results_dir>"
        return

    results_dir = sys.argv[1]
    overhead = []
    for p in PROGRAMS:
        try:
            klee_out = KLEEOut(os.path.join(results_dir, "out-klee-{}".format(p)))
            mm_out = KLEEOut(os.path.join(results_dir, "out-mm-{}".format(p)))
            print "program: {}".format(p)
            assert(klee_out.paths == mm_out.paths)
            o = ((float(mm_out.time) - klee_out.time) / mm_out.time) * 100
            print "  time: {} {}".format(klee_out.time, mm_out.time)
            print "  overhead: {}".format(o)
            overhead.append(o)
        except:
            print "failed {}".format(p)

    print "average ovehead: %.2f" % (sum(overhead) / len(overhead))
    print "max ovehead: %.2f" % (max(overhead))

if __name__ == "__main__":
    main()
