#!/bin/bash

CURRENT_DIR=$(dirname ${BASH_SOURCE[0]})
source ../config.sh

UTILS_FILE=${CURRENT_DIR}/utils.txt
LOG_FILE=${CURRENT_DIR}/status.log
INST_FILE=${CURRENT_DIR}/inst.txt
SANDBOX_DIR=/tmp/env
SANDBOX=${SANDBOX_DIR}/sandbox

ARGS="--sym-args 0 1 10 --sym-args 0 2 2 --sym-files 1 8 --sym-stdin 8 --sym-stdout"
MAX_TIME=3600
MAX_TIME_INCREASED=5400
MAX_MEMORY=4000

FLAGS+="--max-memory=${MAX_MEMORY} "
FLAGS+="--allocate-determ "
FLAGS+="--allocate-determ-start-address=0x0 "
FLAGS+="--allocate-determ-size=4000 "
FLAGS+="--search=dfs "
FLAGS+="--use-forked-solver=1 "
FLAGS+="--disable-inlining "
FLAGS+="--libc=uclibc "
FLAGS+="--posix-runtime "
FLAGS+="--external-calls=all "
FLAGS+="--only-output-states-covering-new "
FLAGS+="--env-file=test.env "
FLAGS+="--run-in-dir=${SANDBOX} "
FLAGS+="--watchdog "
FLAGS+="--switch-type=internal "
FLAGS+="--simplify-sym-indices "

function reset {
    rm -rf ${SANDBOX_DIR}
    mkdir -p ${SANDBOX_DIR}
    tar xf ${CURRENT_DIR}/sandbox.tgz -C ${SANDBOX_DIR}
}

function run_klee {
    bc_file=$1
    name=$2
    max_time=$3
    max_inst=$4
    reset
    ${VANILLA_KLEE} ${FLAGS} \
        -output-dir=${CURRENT_DIR}/build/src/out-klee-${name} \
        -max-time=${max_time} \
        -max-instructions=${max_inst} \
        ${bc_file} ${ARGS} &> /dev/null
}

function run_symaddr {
    bc_file=$1
    name=$2
    max_time=$3
    max_inst=$4
    ${KLEE} ${FLAGS} \
        -output-dir=${CURRENT_DIR}/build/src/out-mm-${name} \
        -max-time=${max_time} \
        -max-instructions=${max_inst} \
        -use-sym-addr \
        -use-rebase=0 \
        -use-global-id=1 \
        -use-recursive-rebase=1 \
        ${bc_file} ${ARGS} &> /dev/null
}

function run_klee_all {
    log_file=${LOG_FILE}
    rm -rf ${log_file}
    for name in $(cat ${UTILS_FILE}); do
        bc_file=${CURRENT_DIR}/build/src/${name}.bc
        run_klee ${bc_file} ${name} ${MAX_TIME} 0
        echo "${name}: status = $?" >> ${log_file}
    done
}

function run_symaddr_all {
    log_file=${LOG_FILE}
    rm -rf ${log_file}
    for name in $(cat ${UTILS_FILE}); do
        bc_file=${CURRENT_DIR}/build/src/${name}.bc
        run_symaddr ${bc_file} ${name} ${MAX_TIME} 0
        echo "${name}: status = $?" >> ${log_file}
    done
}

function run_with_limit {
    log_file=${LOG_FILE}
    rm -rf ${log_file}
    while IFS= read -r line; do
        name=$(echo ${line} | awk '{ print $1 }')
        max_inst=$(echo ${line} | awk '{ print $2 }')
        bc_file=${CURRENT_DIR}/build/src/${name}.bc
        run_klee ${bc_file} ${name} ${MAX_TIME_INCREASED} ${max_inst}
        echo "${name}: klee status = $?" >> ${log_file}
        run_symaddr ${bc_file} ${name} ${MAX_TIME_INCREASED} ${max_inst}
        echo "${name}: mm status = $?" >> ${log_file}
    done < ${INST_FILE}
}

ulimit -s unlimited
