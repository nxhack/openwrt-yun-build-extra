#!/bin/bash -ex

git pull
./scripts/feeds update -a
#./scripts/feeds install -a
make oldconfig
make
