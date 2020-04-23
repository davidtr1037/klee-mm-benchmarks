#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/run.sh

MAX_INST=295451965
OUT_DIR=${OVERHEAD_DIR}/out-klee-make run_klee "-search=dfs"
OUT_DIR=${OVERHEAD_DIR}/out-mm-make run_memory_model "-search=dfs"
