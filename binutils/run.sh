#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ${CURRENT_DIR}/../config.sh

FLAGS=""
FLAGS+="-max-memory=8000 "
FLAGS+="-libc=uclibc "
FLAGS+="-posix-runtime "
FLAGS+="-search=dfs "
FLAGS+="-use-forked-solver=0 "
FLAGS+="-only-output-states-covering-new "
FLAGS+="-switch-type=internal "
FLAGS+="-simplify-sym-indices "
FLAGS+="-allocate-determ "
FLAGS+="-allocate-determ-start-address=0x0 "
FLAGS+="-allocate-determ-size=4000 "

PARTITION=128

BC_FILE=${CURRENT_DIR}/build/gas/as-new.bc
#ARGS="-sym-stdin ${CURRENT_DIR}/gas.input"
ARGS="A --sym-files 1 100"

function run_klee {
    ${VANILLA_KLEE} ${FLAGS} \
        ${BC_FILE} ${ARGS}
}

function run_split {
    ${KLEE} ${FLAGS} \
        -use-sym-addr \
        -split-objects \
        -split-threshold=300 \
        -partition-size=${PARTITION} \
        ${BC_FILE} ${ARGS}
}

function run_split_all {
    sizes=(16 32 64 128 256 512)
    for size in ${sizes[@]}; do
        PARTITION=${size} run_split
    done
}

ulimit -s unlimited
export KLEE_TEMPLATE=$(realpath ${CURRENT_DIR}/gas.input) KLEE_TEMPLATE_RANGE_START=f KLEE_TEMPLATE_RANGE_END=g

#run_split_all
#run_klee
