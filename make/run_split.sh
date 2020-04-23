#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/run.sh

OUT_DIR=${SPLIT_DIR}/make/out-split-vanilla run_klee "-search=dfs"
PREFIX_DIR=${SPLIT_DIR}/make run_split_all
