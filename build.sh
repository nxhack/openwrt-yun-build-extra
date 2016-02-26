#!/bin/bash -ex

BUILD_DATE=`date +%Y%m%d-%H%M%S`

#CREATE BACKUP DIRECTORY
if [ ! -e 'backups' ]; then
    mkdir backups
fi

#BACKUP AND RESTORE LOCAL BUILD KEY
if [ -e 'key-build' ]; then
    cp -n key-build ./backups/
    cp key-build ./backups/key-build.${BUILD_DATE}-$$
else
    if [ -e 'backups/key-build' ]; then
        cp ./backups/key-build .
    fi
fi
if [ -e 'key-build.pub' ]; then
    cp -n key-build.pub ./backups/
    cp key-build.pub ./backups/key-build.pub.${BUILD_DATE}-$$
else
    if [ -e 'backups/key-build.pub' ]; then
        cp ./backups/key-build.pub .
    fi
fi

#INIT KERNEL CONFIG
if [ ! -e '.config' ]; then
    cp openwrt-yun-minimum.config .config
fi

#CLEAN
make clean

#FEEDS
./scripts/feeds uninstall -a
rm -rf feeds
./scripts/feeds update -a
./scripts/feeds install -a

#UNINSTALL BROKEN PACKAGES
#./scripts/feeds uninstall aria2 freecwmp libfreecwmp libmicroxml crtmpserver dansguardian

#DELETE PACKAGES
rm -rf ./package/feeds/packages/node-serialport
rm -rf ./package/feeds/packages/node-arduino-firmata

#LINK CUSTOM PACKAGES
ln -s ../../../feeds/arduino/node-serialport ./package/feeds/arduino/
ln -s ../../../feeds/arduino/node-arduino-firmata ./package/feeds/arduino/

# PATCH PACKAGES
sed -i -e s/^START=98/START=48/ ./feeds/packages/utils/rng-tools/files/rngd.init
if [ -z "`git status|fgrep mach-arduino-yun.c`" ]; then
    patch -p1 < ./patches/00-arduino-yun-gpio_keys_polled.patch
fi

#COPY CONFIG FILE
mv .config ./backups/config.${BUILD_DATE}-$$
cp openwrt-yun-minimum.config .config

make oldconfig
make
