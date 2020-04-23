#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/run.sh

MAX_INST=1231677
run_klee_2
run_memory_model "-search=dfs"
