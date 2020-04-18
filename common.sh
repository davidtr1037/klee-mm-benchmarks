#!/bin/bash

N=1

function run_all {
    for ((n=0;n<${N};n++)); do
        echo "iteration ${n}"
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
        echo "iteration ${n}"
        CONTEXT_RESOLVE=0 REUSE=0 run_with_rebase "-search=dfs"
    done
}

function run_reuse_opt {
    for ((n=0;n<${N};n++)); do
        echo "iteration ${n}"
        CONTEXT_RESOLVE=0 REUSE=1 run_with_rebase "-search=dfs"
    done
}

function run_context_resolve_opt {
    for ((n=0;n<${N};n++)); do
        echo "iteration ${n}"
        CONTEXT_RESOLVE=1 K_CONTEXT=4 REUSE=0 run_with_rebase "-search=dfs"
    done
}
