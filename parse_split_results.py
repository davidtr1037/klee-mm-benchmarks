import sys
import os
from klee_out_parser import KLEEOut

DIRS = [
    "out-split-vanilla",
    "out-split-p512",
    "out-split-p256",
    "out-split-p128",
    "out-split-p64",
    "out-split-p32",
]

def main():
    if len(sys.argv) != 2:
        print "Usage: <benchmark_dir>"
        return

    benchmark_dir = sys.argv[1]
    for d in DIRS:
        try:
            ko_path = os.path.join(benchmark_dir, d)
            ko = KLEEOut(ko_path)
            print "kle-out directory: {}".format(ko_path)
            print "  Elapsed: {}".format(ko.elapsed)
            print "  Paths: {}".format(ko.paths)
        except:
            print "failed {}".format(ko_path)

if __name__ == "__main__":
    main()
