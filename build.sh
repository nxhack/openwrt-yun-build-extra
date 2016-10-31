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
  if [ -n "`fgrep 'LEDE Configuration' Config.in`" ]; then
    cp lede-yun-minimum.config .config
  else
    cp openwrt-yun-minimum.config .config
  fi
else
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

#UNINSTALL BROKEN PACKAGES
#./scripts/feeds uninstall aria2 freecwmp libfreecwmp libmicroxml crtmpserver dansguardian

#DELETE PACKAGES
#rm -rf ./package/feeds/packages/node
#rm -rf ./package/feeds/packages/node-arduino-firmata
#rm -rf ./package/feeds/packages/node-cylon
#rm -rf ./package/feeds/packages/node-hid
#rm -rf ./package/feeds/packages/node-serialport

#rm -rf ./package/feeds/arduino/node-bleno
#rm -rf ./package/feeds/arduino/node-bluetooth-hci-socket
#rm -rf ./package/feeds/arduino/node-noble
#rm -rf ./package/feeds/arduino/node-socket.io
#rm -rf ./package/feeds/arduino/node-socket.io-client
#rm -rf ./package/feeds/arduino/node-socket.io-client-legacy
#rm -rf ./package/feeds/arduino/node-socket.io-legacy
#rm -rf ./package/feeds/arduino/node-sqlite3
#rm -rf ./package/feeds/arduino/node-ws

#LINK CUSTOM PACKAGES
#ln -s ../../../feeds/arduino/node ./package/feeds/arduino/
#ln -s ../../../feeds/arduino/node-arduino-firmata ./package/feeds/arduino/
#ln -s ../../../feeds/arduino/node-cylon ./package/feeds/arduino/
#ln -s ../../../feeds/arduino/node-hid ./package/feeds/arduino/
#ln -s ../../../feeds/arduino/node-serialport ./package/feeds/arduino/

#ln -s ../../../feeds/node/node ./package/feeds/node/
#ln -s ../../../feeds/node/node-arduino-firmata ./package/feeds/node/
#ln -s ../../../feeds/node/node-cylon ./package/feeds/node/
#ln -s ../../../feeds/node/node-cylon-firmata ./package/feeds/node/
#ln -s ../../../feeds/node/node-cylon-gpio ./package/feeds/node/
#ln -s ../../../feeds/node/node-cylon-i2c ./package/feeds/node/
#ln -s ../../../feeds/node/node-hid ./package/feeds/node/
#ln -s ../../../feeds/node/node-serialport ./package/feeds/node/
#ln -s ../../../feeds/node/node-bleno ./package/feeds/node/
#ln -s ../../../feeds/node/node-bluetooth-hci-socket ./package/feeds/node/
#ln -s ../../../feeds/node/node-noble ./package/feeds/node/
#ln -s ../../../feeds/node/node-socket.io ./package/feeds/node/
#ln -s ../../../feeds/node/node-socket.io-client ./package/feeds/node/
#ln -s ../../../feeds/node/node-socket.io-client-legacy ./package/feeds/node/
#ln -s ../../../feeds/node/node-socket.io-legacy ./package/feeds/node/
#ln -s ../../../feeds/node/node-sqlite3 ./package/feeds/node/
#ln -s ../../../feeds/node/node-ws ./package/feeds/node/

# PATCH PACKAGES
sed -i -e s/^START=98/START=48/ ./feeds/packages/utils/rng-tools/files/rngd.init
#sed -i -e s/^RNGD_AMOUNT=4000/RNGD_AMOUNT=4096/ ./feeds/packages/utils/rng-tools/files/rngd.init

# BACKUP FEEDS CONFIG
if [ -e '.config' ]; then
    mv .config ./backups/feeds-config.${BUILD_DATE}-$$
fi

# PATCH KERNEL CONFIG & COPY CONFIG FILE
if [ -n "`fgrep 'LEDE Configuration' Config.in`" ]; then
  if [ -z "`git status|fgrep ar71xx/config-4.4`" ]; then
      patch -p1 < ./patches/LEDE-MIPS24Kc+PCI+FPU_EMU.patch
  fi
  cp lede-yun-minimum.config .config
else
  if [ -z "`git status|fgrep ar71xx/Makefile`" ]; then
      patch -p1 < ./patches/OpenWrt-MIPS24Kc+PCI+FPU_EMU.patch
  fi
  cp openwrt-yun-minimum.config .config
fi

make oldconfig
make
