#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/run.sh

OUT_DIR=${SPLIT_DIR}/apr/out-split-vanilla run_klee "-search=dfs"
PREFIX_DIR=${SPLIT_DIR}/apr run_split_all
