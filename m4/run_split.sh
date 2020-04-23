#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/run.sh

OUT_DIR=${SPLIT_DIR}/m4/out-split-vanilla run_klee_2
PREFIX_DIR=${SPLIT_DIR}/m4 run_split_all
