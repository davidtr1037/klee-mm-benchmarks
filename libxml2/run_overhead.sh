#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/run.sh

MAX_INST=343011381
OUT_DIR=${OVERHEAD_DIR}/out-klee-libxml2 run_klee
OUT_DIR=${OVERHEAD_DIR}/out-mm-libxml2 run_memory_model
