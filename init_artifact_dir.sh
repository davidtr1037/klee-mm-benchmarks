#!/bin/bash


ROOT=$1

mkdir -p ${ROOT}
mkdir -p ${ROOT}/overhead
mkdir -p ${ROOT}/merge
mkdir -p ${ROOT}/split

mkdir -p ${ROOT}/split/m4
mkdir -p ${ROOT}/split/make
mkdir -p ${ROOT}/split/sqlite
mkdir -p ${ROOT}/split/apr
mkdir -p ${ROOT}/split/gas
mkdir -p ${ROOT}/split/libxml2

mkdir -p ${ROOT}/merge/models
mkdir -p ${ROOT}/merge/optimizations
mkdir -p ${ROOT}/merge/resolve-queries

mkdir -p ${ROOT}/merge/models/m4
mkdir -p ${ROOT}/merge/models/make
mkdir -p ${ROOT}/merge/models/sqlite
mkdir -p ${ROOT}/merge/models/apr

mkdir -p ${ROOT}/merge/optimizations/m4
mkdir -p ${ROOT}/merge/optimizations/make
mkdir -p ${ROOT}/merge/optimizations/sqlite
mkdir -p ${ROOT}/merge/optimizations/apr

mkdir -p ${ROOT}/merge/resolve-queries/m4
mkdir -p ${ROOT}/merge/resolve-queries/make
mkdir -p ${ROOT}/merge/resolve-queries/sqlite
mkdir -p ${ROOT}/merge/resolve-queries/apr
