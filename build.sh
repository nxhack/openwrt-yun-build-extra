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
  cp openwrt-yun-lininoos.config .config
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
rm  ./package/feeds/packages/node-*

#INSTALL CUSTOM NODE PACKAGES
./scripts/feeds install -a -p node

# PATCH PACKAGES
#cp ./patches/0001-Added-linuxspi-programmer-type-using-spidev.patch ./feeds/packages/utils/avrdude/patches/

# BACKUP FEEDS CONFIG
if [ -e '.config' ]; then
    mv .config ./backups/feeds-config.${BUILD_DATE}-$$
fi

# PATCH KERNEL CONFIG & COPY CONFIG FILE
if [ -n "`fgrep 'OpenWrt Configuration' Config.in`" ]; then
  if [ -z "`git status|fgrep ar71xx/config-`" ]; then
      patch -p1 < ./patches/OpenWrt-MIPS24Kc+PCI+FPU_EMU.patch
  fi
  cp openwrt-yun-lininoos.config .config
fi

make oldconfig
make
