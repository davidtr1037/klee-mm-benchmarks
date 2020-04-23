#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/run.sh

PREFIX_DIR=${MODELS_DIR}/sqlite run_merge_fmm
