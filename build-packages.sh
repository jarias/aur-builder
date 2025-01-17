#!/bin/bash

set -e

docker_image=$1
echo "----------------------> Using docker image ${docker_image} <----------"

echo "----------------------> Creating empty repo... <----------------------"
mkdir repo
cd repo
tar --zstd -cf jarias.db.tar.zst --files-from /dev/null
tar --zstd -cf jarias.files.tar.zst --files-from /dev/null
ln -s jarias.db.tar.zst jarias.db
ln -s jarias.files.tar.zst jarias.files
cd ..
echo "----------------------> Done creating empty repo <--------------------"

echo "----------------------> Bulding packages... <-------------------------"
while IFS= read -r pkg; do
  docker run --privileged \
    --rm \
    -v "$(pwd)/repo:/repo" \
    $docker_image $pkg
done <packages
echo "----------------------> Done bulding packages <-----------------------"
