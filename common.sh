#!/bin/bash

MAX_TIME=86400
MAX_MEMORY=8000
N=1

function run_merge_fmm {
    for ((n=0;n<${N};n++)); do
        run_klee "-search=dfs"
        run_klee "-search=bfs"
        run_klee ""
    done
}

function run_merge_smm {
    for ((n=0;n<${N};n++)); do
        run_klee_smm "-search=dfs"
        run_klee_smm "-search=bfs"
        run_klee_smm ""
    done
}

function run_merge_dsmm {
    for ((n=0;n<${N};n++)); do
        CONTEXT_RESOLVE=1 K_CONTEXT=4 REUSE=1 run_with_rebase "-search=dfs"
        CONTEXT_RESOLVE=1 K_CONTEXT=4 REUSE=1 run_with_rebase "-search=bfs"
        CONTEXT_RESOLVE=1 K_CONTEXT=4 REUSE=1 run_with_rebase ""
    done
}

function run_context_test {
    for k in {0..4}; do
        CONTEXT_RESOLVE=1 K_CONTEXT=${k} REUSE=0 run_with_rebase "-search=dfs"
    done
}

function run_no_opt {
    for ((n=0;n<${N};n++)); do
        CONTEXT_RESOLVE=0 K_CONTEXT=0 REUSE=0 run_with_rebase "-search=dfs"
    done
}

function run_reuse_opt {
    for ((n=0;n<${N};n++)); do
        CONTEXT_RESOLVE=0 K_CONTEXT=0 REUSE=1 run_with_rebase "-search=dfs"
    done
}

function run_context_resolve_opt {
    for ((n=0;n<${N};n++)); do
        CONTEXT_RESOLVE=1 K_CONTEXT=4 REUSE=0 run_with_rebase "-search=dfs"
    done
}

function run_opt_test {
    run_no_opt
    run_context_resolve_opt
    run_reuse_opt
}
