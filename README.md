#OpenWrt for Arduino Yún

##Description

OpenWrt for Arduino Yún : trunk (Bleeding Edge)

Extra files and scripts for building OpenWrt-Yun.

## License

See:
- [OpenWrt license](http://wiki.openwrt.org/about/license)
- [OpenWrt Yún license](https://github.com/arduino/openwrt-yun/blob/master/LICENSE)
- [OpenWrt Yún license](https://github.com/RedSnake64/openwrt-yun/blob/15.05/LICENSE)

## Reference
- [Arduino LLC OpenWrt Yún](https://github.com/arduino/openwrt-yun)
- [RedSnake64 OpenWrt for Arduino Yún](https://github.com/RedSnake64/openwrt-yun/tree/15.05)

## Building
```bash
mkdir Build_Path_Some_Where
cd Build_Path_Some_Where
# git clone --depth=1 --branch master --single-branch https://github.com/openwrt/openwrt.git
git clone --depth=1 https://git.openwrt.org/openwrt.git
git clone --depth=1 --branch master --single-branch https://github.com/nxhack/openwrt-yun-build-extra.git
cd openwrt
mv feeds.conf.default feeds.conf.default.orig
mv ../openwrt-yun-build-extra/* .
./build.sh
```
Please modify ./files/etc/opkg/distfeeds.conf

**Enjoy!**
