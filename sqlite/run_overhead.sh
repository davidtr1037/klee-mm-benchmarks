#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/run.sh

MAX_INST=0
OUT_DIR=${OVERHEAD_DIR}/out-klee-sqlite run_klee "-search=dfs"
OUT_DIR=${OVERHEAD_DIR}/out-mm-sqlite run_memory_model "-search=dfs"
