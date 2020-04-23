#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/../config.sh
source ${CURRENT_DIR}/../common.sh

FLAGS=""
FLAGS+="-libc=uclibc "
FLAGS+="-posix-runtime "
FLAGS+="-max-memory=${MAX_MEMORY} "
FLAGS+="-max-time=${MAX_TIME} "
FLAGS+="-use-forked-solver=0 "
FLAGS+="-only-output-states-covering-new "
FLAGS+="-switch-type=internal "
FLAGS+="-simplify-sym-indices "
FLAGS+="-allocate-determ "
FLAGS+="-allocate-determ-start-address=0x0 "
FLAGS+="-allocate-determ-size=4000 "

DEPTH=0
CONTEXT_RESOLVE=1
K_CONTEXT=4
REUSE=1
SPLIT_THRESHOLD=300
PARTITION=128

BC_FILE=${CURRENT_DIR}/build/src/m4.bc
ARGS="-sym-files 1 1 -sym-stdin ${CURRENT_DIR}/m4.input -H37 -G"
ARGS_SPLIT="-sym-files 1 1 -sym-stdin ${CURRENT_DIR}/m4_2.input -G"

# merge

function run_klee {
    search=$1
    ${VANILLA_KLEE} ${FLAGS} \
        -output-dir=${OUT_DIR} \
        ${search} \
        ${BC_FILE} ${ARGS}
}

function run_klee_smm {
    search=$1
    ${KLEE_SMM} ${FLAGS} \
        -output-dir=${OUT_DIR} \
        ${search} \
        -pts \
        -flat-memory \
        ${BC_FILE} ${ARGS}
}

function run_with_rebase {
    search=$1
    ${KLEE} ${FLAGS} \
        -output-dir=${OUT_DIR} \
        ${search} \
        -use-sym-addr \
        -use-rebase \
        -use-global-id=1 \
        -use-recursive-rebase=1 \
        -reuse-segments=${REUSE} \
        -use-kcontext=${K_CONTEXT} \
        -use-context-resolve=${CONTEXT_RESOLVE} \
        ${BC_FILE} ${ARGS}
}

# split

function run_klee_2 {
    ${VANILLA_KLEE} ${FLAGS} \
        -output-dir=${OUT_DIR} \
        -search=dfs \
        -max-instructions=${MAX_INST} \
        ${BC_FILE} ${ARGS_SPLIT}
}

function run_memory_model {
    search=$1
    ${KLEE} ${FLAGS} \
        -output-dir=${OUT_DIR} \
        ${search} \
        -max-instructions=${MAX_INST} \
        -use-sym-addr \
        ${BC_FILE} ${ARGS_SPLIT}
}

function run_split {
    ${KLEE} ${FLAGS} \
        -output-dir=${OUT_DIR} \
        -search=dfs \
        -use-sym-addr \
        -split-objects \
        -split-threshold=${SPLIT_THRESHOLD} \
        -partition-size=${PARTITION} \
        ${BC_FILE} ${ARGS_SPLIT}
}

function run_split_all {
    sizes=(32 64 128 256 512)
    for size in ${sizes[@]}; do
        OUT_DIR=${PREFIX_DIR}/out-split-p${size} PARTITION=${size} run_split
    done
}

ulimit -s unlimited
