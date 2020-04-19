#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/run.sh

MAX_INST=0
run_klee "-search=dfs"
run_memory_model "-search=dfs"
