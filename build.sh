#!/bin/bash -ex

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
mv .config .config.$$
cp openwrt-yun-minimum.config .config

make oldconfig
make
