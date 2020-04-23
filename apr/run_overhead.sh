#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/run.sh

MAX_INST=166700
OUT_DIR=${OVERHEAD_DIR}/out-klee-apr run_klee "-search=dfs"
OUT_DIR=${OVERHEAD_DIR}/out-mm-apr run_memory_model "-search=dfs"
