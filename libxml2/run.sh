#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/../config.sh
source ${CURRENT_DIR}/../common.sh

BC_FILE=${CURRENT_DIR}/test_driver.bc
MAX_MEMORY=8000
SPLIT_THRESHOLD=300
PARTITION=128
SIZE=4

FLAGS=""
FLAGS+="-max-memory=${MAX_MEMORY} "
FLAGS+="-max-time=${MAX_TIME} "
FLAGS+="-libc=uclibc "
FLAGS+="-search=dfs "
FLAGS+="-use-forked-solver=0 "
FLAGS+="-only-output-states-covering-new "
FLAGS+="-simplify-sym-indices "
FLAGS+="-allocate-determ "
FLAGS+="-allocate-determ-start-address=0x0 "
FLAGS+="-allocate-determ-size=4000 "

function run_klee {
    ${VANILLA_KLEE} ${FLAGS} \
        ${BC_FILE} ${SIZE}
}

function run_with_rebase {
    ${KLEE} ${FLAGS} \
        -use-sym-addr \
        -use-rebase \
        ${BC_FILE} ${SIZE}
}

function run_split {
    ${KLEE} ${FLAGS} \
        -use-sym-addr \
        -split-objects \
        -split-threshold=${SPLIT_THRESHOLD} \
        -partition-size=${PARTITION} \
        ${BC_FILE} ${SIZE}
}

function run_split_all {
    sizes=(32 64 128 256 512)
    for size in ${sizes[@]}; do
        PARTITION=${size} run_split
    done
}

ulimit -s unlimited
