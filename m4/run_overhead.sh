#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/run.sh

MAX_INST=1231677
OUT_DIR=${OVERHEAD_DIR}/out-klee-m4 run_klee_2
OUT_DIR=${OVERHEAD_DIR}/out-mm-m4 run_memory_model "-search=dfs"
