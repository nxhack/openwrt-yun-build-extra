#!/bin/bash -ex

git pull
./scripts/feeds update -a
./scripts/feeds install -a

#DELETE OPENWRT NODE PACKAGES
rm  ./package/feeds/packages/node
rm  ./package/feeds/packages/node-*

#INSTALL CUSTOM NODE PACKAGES
./scripts/feeds install -a -p node

#DELETE OPENWRT MRAA PACKAGES
rm ./package/feeds/packages/libmraa
rm ./package/feeds/packages/libupm

#INSTALL CUSTOM MRAA PACKAGES
./scripts/feeds install -a -p inteliot

cp openwrt-yun-lininoos.diffconfig .config

make defconfig
make
