#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/run.sh

MAX_INST=43430065
OUT_DIR=${OVERHEAD_DIR}/out-klee-gas run_klee "-search=dfs"
OUT_DIR=${OVERHEAD_DIR}/out-mm-gas run_memory_model "-search=dfs"
