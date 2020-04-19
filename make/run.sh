#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/../config.sh
source ${CURRENT_DIR}/../common.sh

ALLOCATE_DETERM=1

FLAGS=""
FLAGS+="-libc=uclibc "
FLAGS+="-posix-runtime "
FLAGS+="-use-forked-solver=0 "
FLAGS+="-only-output-states-covering-new "
FLAGS+="-max-memory=${MAX_MEMORY} "
FLAGS+="-max-time=${MAX_TIME} "
FLAGS+="-allocate-determ-start-address=0x0 "
FLAGS+="-allocate-determ-size=4000 "
FLAGS+="-switch-type=internal "
#FLAGS+="-allow-external-sym-calls "
#FLAGS+="-all-external-warnings "

DEPTH=0
CONTEXT_RESOLVE=1
K_CONTEXT=4
REUSE=1
PARTITION=128
SPLIT_THRESHOLD=300

BC_FILE=${CURRENT_DIR}/build/make.bc
ARGS="--sym-files 1 1 -sym-stdin ${CURRENT_DIR}/make.input -r -n -R -f A"

function run_klee {
    search=$1
    ${VANILLA_KLEE} ${FLAGS} \
        ${search} \
        -allocate-determ=1 \
        ${BC_FILE} ${ARGS}
}

function run_klee_smm {
    search=$1
    ${KLEE_SMM} ${FLAGS} \
        -allocate-determ=1 \
        ${search} \
        -pts \
        -flat-memory \
        ${BC_FILE} ${ARGS}
}

function run_with_rebase {
    search=$1
    ${KLEE} ${FLAGS} \
        ${search} \
        -allocate-determ=1 \
        -use-sym-addr \
        -use-rebase \
        -use-kcontext=${K_CONTEXT} \
        -use-global-id=1 \
        -use-recursive-rebase=1 \
        -reuse-arrays=0 \
        -reuse-segments=${REUSE} \
        -use-context-resolve=${CONTEXT_RESOLVE} \
        -rebase-reachable=0 \
        -reachability-depth=${DEPTH} \
        -use-batch-rebase=0 \
        -use-ahead-rebase=0 \
        ${BC_FILE} ${ARGS}
}

function run_split {
    ${KLEE} ${FLAGS} \
        -allocate-determ=${ALLOCATE_DETERM} \
        -search=dfs \
        -use-sym-addr \
        -split-objects \
        -split-threshold=${SPLIT_THRESHOLD} \
        -partition-size=${PARTITION} \
        ${BC_FILE} ${ARGS}
}

function run_split_all {
    sizes=(64 128 256 512)
    for size in ${sizes[@]}; do
        ALLOCATE_DETERM=1 PARTITION=${size} run_split
    done
    ALLOCATE_DETERM=0 PARTITION=32 run_split
}

ulimit -s unlimited
export KLEE_TEMPLATE=$(realpath ${CURRENT_DIR}/make.input)
