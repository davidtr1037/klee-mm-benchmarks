#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/run.sh

PREFIX_DIR=${OPTIMIZATIONS_DIR}/sqlite run_opt_test
