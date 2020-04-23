import sys
import os
import re
import subprocess


class KLEEOut(object):

    def __init__(self, dir_path, open_stats=True):
        self.dir_path = dir_path
        self.time = None
        self.instructions = None
        self.elapsed = None
        self.paths = None

        if not os.path.exists(dir_path):
            raise Exception("missing directory: {}".format(dir_path))
    
        self.parse_info()
        if open_stats:
            self.parse_stats()
        self.parse_messages()

    def parse_info(self):
        with open(os.path.join(self.dir_path, "info")) as f:
            lines = f.readlines()
            self.elapsed = self.get_elapsed(lines)
            self.paths = self.get_completed_paths(lines)

    def get_elapsed(self, lines):
        for line in lines:
            m = re.search("Elapsed: (.*)", line)
            if m is not None:
                return m.groups()[0]
     
        return None
  
    def get_completed_paths(self, lines):
        for line in lines:
            m = re.search("KLEE: done: completed paths = (\w*)", line)
            if m is not None:
                return int(m.groups()[0])
    
        return None
    
    def parse_stats(self):
        p = subprocess.Popen(["klee-stats", self.dir_path], stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=False)
        out, err = p.communicate()
        lines = out.split("\n")
        values = [v.strip() for v in lines[3].split('|')]
        self.instructions = int(values[2])
        self.time = int(float((values[3])))

    def parse_messages(self):
        with open(os.path.join(self.dir_path, "messages.txt")) as f:
            for line in f.readlines():
                m = re.search("KLEE: Resolve queries: (\w*)", line)
                if m is not None:
                    self.resolve_queries = int(m.groups()[0])

    def dump(self):
        print "Time: {}".format(self.time)
        print "Elapsed: {}".format(self.elapsed)
        print "Instructions: {}".format(self.instructions)
        print "Paths: {}".format(self.paths)

def main():
    klee_dir = sys.argv[1]
    ko = KLEEOut(klee_dir)
    ko.dump()

if __name__ == '__main__':
    main()
