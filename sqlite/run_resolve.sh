#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/run.sh

PREFIX_DIR=${RESOLVE_QUERIES_DIR}/sqlite run_context_test
