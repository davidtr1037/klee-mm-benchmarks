#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/../config.sh
source ${CURRENT_DIR}/../common.sh

FLAGS=""
FLAGS+="-max-memory=${MAX_MEMORY} "
FLAGS+="-max-time=${MAX_TIME} "
FLAGS+="-libc=uclibc "
FLAGS+="-posix-runtime "
FLAGS+="-use-forked-solver=0 "
FLAGS+="-only-output-states-covering-new "
FLAGS+="-switch-type=internal "
FLAGS+="-simplify-sym-indices "
FLAGS+="-allocate-determ "
FLAGS+="-allocate-determ-start-address=0x0 "
FLAGS+="-allocate-determ-size=4000 "

PARTITION=128

BC_FILE=${CURRENT_DIR}/build/gas/as-new.bc
ARGS="A --sym-files 1 100"

function run_klee {
    search=$1
    ${VANILLA_KLEE} ${FLAGS} \
        ${search} \
        ${BC_FILE} ${ARGS}
}

function run_memory_model {
    search=$1
    ${KLEE} ${FLAGS} \
        ${search} \
        -use-sym-addr \
        ${BC_FILE} ${ARGS}
}

function run_with_rebase {
    ${KLEE} ${FLAGS} \
        -use-sym-addr \
        -use-rebase \
        ${BC_FILE} ${ARGS}
}

function run_split {
    ${KLEE} ${FLAGS} \
        -search=dfs \
        -use-sym-addr \
        -split-objects \
        -split-threshold=300 \
        -partition-size=${PARTITION} \
        ${BC_FILE} ${ARGS}
}

function run_split_all {
    sizes=(32 64 128 256 512)
    for size in ${sizes[@]}; do
        PARTITION=${size} run_split
    done
}

ulimit -s unlimited
export KLEE_TEMPLATE=$(realpath ${CURRENT_DIR}/gas.input) KLEE_TEMPLATE_RANGE_START=f KLEE_TEMPLATE_RANGE_END=g
