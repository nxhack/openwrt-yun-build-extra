#!/bin/bash -ex

BUILD_DATE=`date +%Y%m%d-%H%M%S`

#CREATE BACKUP DIRECTORY
if [ ! -e 'backups' ]; then
    mkdir backups
fi

#BACKUP LOCAL BUILD KEY
if [ -e 'key-build' ]; then
    cp -n key-build ./backups/
    cp key-build ./backups/key-build.${BUILD_DATE}-$$
fi
if [ -e 'key-build.pub' ]; then
    cp -n key-build.pub ./backups/
    cp key-build.pub ./backups/key-build.pub.${BUILD_DATE}-$$
fi

#INIT KERNEL CONFIG
if [ ! -e '.config' ]; then
  cp lede-17.01-yun-lininoos.config .config
  cp .config ./backups/config.${BUILD_DATE}-$$
fi

#BACKUP DL FOLDER
if [ -e 'dl' ]; then
    mv dl dl.orig
fi

#CLEAN
make clean
make dirclean
make distclean

#RESTORE DL FOLDER
if [ -e 'dl.orig' ]; then
    mv dl.orig dl
fi

#RESTORE LOCAL BUILD KEY
if [ -e 'backups/key-build' ]; then
    cp ./backups/key-build .
fi
if [ -e 'backups/key-build.pub' ]; then
    cp ./backups/key-build.pub .
fi

#FEEDS
./scripts/feeds uninstall -a
rm -rf feeds
./scripts/feeds update -a
./scripts/feeds install -a

#DELETE OPENWRT NODE PACKAGES
rm  ./package/feeds/packages/node
rm  ./package/feeds/packages/node-arduino-firmata
rm  ./package/feeds/packages/node-cylon
rm  ./package/feeds/packages/node-hid
rm  ./package/feeds/packages/node-serialport

#INSTALL CUSTOM NODE PACKAGES
./scripts/feeds install -a -p node

# PATCH PACKAGES
#sed -i -e s/^START=98/START=48/ ./feeds/packages/utils/rng-tools/files/rngd.init

# BACKUP FEEDS CONFIG
if [ -e '.config' ]; then
    mv .config ./backups/feeds-config.${BUILD_DATE}-$$
fi

# PATCH KERNEL CONFIG & COPY CONFIG FILE
if [ -n "`fgrep 'LEDE Configuration' Config.in`" ]; then
  if [ -z "`git status|fgrep ar71xx/config-4.4`" ]; then
      patch -p1 < ./patches/LEDE-17.01-MIPS24Kc+PCI+FPU_EMU.patch
  fi
  cp lede-17.01-yun-lininoos.config .config
fi

make oldconfig
make
