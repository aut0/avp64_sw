#!/bin/bash

BENCHMARK=$1

BUILD_DIR=/app/build/$BENCHMARK
TMP_DIR=$BUILD_DIR/tmp
BENCH_DIR=$TMP_DIR/$BENCHMARK

echo "Posprocessing benchmark '$1'"

rm -rf $TMP_DIR
mkdir -p $BENCH_DIR

# create/copy files
cp $BUILD_DIR/$BENCHMARK.{bin,elf} $BENCH_DIR/
sed -e "s/%BENCHMARK%/${BENCHMARK}/g" /app/config/benchmark.cfg > ${TMP_DIR}/${BENCHMARK}.cfg

# create tarball
pushd ${TMP_DIR} > /dev/null
tar -czf /app/images/${BENCHMARK}.tar.gz ./*
popd > /dev/null
