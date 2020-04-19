#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/../config.sh
source ${CURRENT_DIR}/../common.sh

FLAGS=""
FLAGS+="-use-forked-solver=0 "
FLAGS+="-libc=uclibc "
FLAGS+="-max-memory=${MAX_MEMORY} "
FLAGS+="-max-time=${MAX_TIME} "
FLAGS+="-allocate-determ "
FLAGS+="-allocate-determ-start-address=0x0 "
FLAGS+="-only-output-states-covering-new "

SIZE=15
BC_FILE=${CURRENT_DIR}/test_driver.bc

DEPTH=0
CONTEXT_RESOLVE=1
K_CONTEXT=4
REUSE=1
SPLIT_THRESHOLD=300
PARTITION=128

function run_klee {
    search=$1
    ${VANILLA_KLEE} \
        ${search} \
        ${FLAGS} \
        ${BC_FILE} ${SIZE}
}

function run_memory_model {
    search=$1
    ${KLEE} ${FLAGS} \
        ${search} \
        -use-sym-addr \
        ${BC_FILE} ${SIZE}
}

function run_klee_smm {
    search=$1
    ${KLEE_SMM} \
        ${search} \
        ${FLAGS} \
        -pts \
        -flat-memory \
        ${BC_FILE} ${SIZE}
}

function run_with_rebase {
    search=$1
    ${KLEE} ${FLAGS} \
        ${search} \
        -use-sym-addr \
        -use-rebase \
        -use-global-id=1 \
        -use-recursive-rebase=1 \
        -reuse-segments=${REUSE} \
        -use-context-resolve=${CONTEXT_RESOLVE} \
        -use-kcontext=${K_CONTEXT} \
        ${BC_FILE} ${SIZE}
}

function run_context_test {
    for i in {0..4}; do
        K_CONTEXT=${i}
        run_with_rebase
    done
}

function run_split {
    ${KLEE} ${FLAGS} \
        -search=dfs \
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
