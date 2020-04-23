#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/run.sh

PREFIX_DIR=${MODELS_DIR}/apr run_merge_smm
