#!/bin/bash

MAX_TIME=86400
MAX_MEMORY=8000
MAX_INST=0
N=1

function run_merge_fmm {
    for ((n=0;n<${N};n++)); do
        OUT_DIR=${PREFIX_DIR}/out-fmm-dfs run_klee "-search=dfs"
        OUT_DIR=${PREFIX_DIR}/out-fmm-bfs run_klee "-search=bfs"
        OUT_DIR=${PREFIX_DIR}/out-fmm-default run_klee ""
    done
}

function run_merge_smm {
    for ((n=0;n<${N};n++)); do
        OUT_DIR=${PREFIX_DIR}/out-smm-dfs run_klee_smm "-search=dfs"
        OUT_DIR=${PREFIX_DIR}/out-smm-bfs run_klee_smm "-search=bfs"
        OUT_DIR=${PREFIX_DIR}/out-smm-default run_klee_smm ""
    done
}

function run_merge_dsmm {
    for ((n=0;n<${N};n++)); do
        OUT_DIR=${PREFIX_DIR}/out-dsmm-dfs CONTEXT_RESOLVE=1 K_CONTEXT=4 REUSE=1 run_with_rebase "-search=dfs"
        OUT_DIR=${PREFIX_DIR}/out-dsmm-bfs CONTEXT_RESOLVE=1 K_CONTEXT=4 REUSE=1 run_with_rebase "-search=bfs"
        OUT_DIR=${PREFIX_DIR}/out-dsmm-default CONTEXT_RESOLVE=1 K_CONTEXT=4 REUSE=1 run_with_rebase ""
    done
}

function run_context_test {
    OUT_DIR=${PREFIX_DIR}/out-default CONTEXT_RESOLVE=0 K_CONTEXT=0 REUSE=0 run_with_rebase "-search=dfs"
    for k in {0..4}; do
        OUT_DIR=${PREFIX_DIR}/out-k${k} CONTEXT_RESOLVE=1 K_CONTEXT=${k} REUSE=0 run_with_rebase "-search=dfs"
    done
}

function run_no_opt {
    for ((n=0;n<${N};n++)); do
        OUT_DIR=${PREFIX_DIR}/out-no-opt CONTEXT_RESOLVE=0 K_CONTEXT=0 REUSE=0 run_with_rebase "-search=dfs"
    done
}

function run_reuse_opt {
    for ((n=0;n<${N};n++)); do
        OUT_DIR=${PREFIX_DIR}/out-opt-reuse CONTEXT_RESOLVE=0 K_CONTEXT=0 REUSE=1 run_with_rebase "-search=dfs"
    done
}

function run_context_resolve_opt {
    for ((n=0;n<${N};n++)); do
        OUT_DIR=${PREFIX_DIR}/out-opt-context CONTEXT_RESOLVE=1 K_CONTEXT=4 REUSE=0 run_with_rebase "-search=dfs"
    done
}

function run_opt_test {
    run_no_opt
    run_context_resolve_opt
    run_reuse_opt
}
