#!/bin/bash -ex

BUILD_DATE=`date +%Y%m%d-%H%M%S`

#
if [ ${EUID:-${UID}} = 0 ]; then
    echo "Do everything as normal user, don't use root user or sudo!"
    exit 255
fi


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
rm -f ./package/feeds/packages/node
rm -f ./package/feeds/packages/node-*

#INSTALL CUSTOM NODE PACKAGES
./scripts/feeds install -a -p node

#DELETE OPENWRT MRAA PACKAGES
rm -f ./package/feeds/packages/swig
rm -f ./package/feeds/packages/libmraa
rm -f ./package/feeds/packages/libupm

#INSTALL CUSTOM MRAA PACKAGES
./scripts/feeds install -a -p inteliot

# PATCH PACKAGES
#cp ./patches/0001-Added-linuxspi-programmer-type-using-spidev.patch ./feeds/packages/utils/avrdude/patches/

# BACKUP FEEDS CONFIG
if [ -e '.config' ]; then
    mv .config ./backups/feeds-config.${BUILD_DATE}-$$
fi

# PATCH KERNEL CONFIG & COPY CONFIG FILE
if [ -n "`fgrep 'LEDE Configuration' Config.in`" ]; then
  if [ -z "`git status|fgrep ar71xx/config-4.4`" ]; then
      patch -p1 < ./patches/LEDE-17.01-MIPS24Kc+PCI+FPU_EMU.patch
  fi
  #cp lede-17.01-yun-lininoos.config .config
  cp lede-17.01-yun-lininoos.diffconfig .config
fi

#make oldconfig
make defconfig
make
