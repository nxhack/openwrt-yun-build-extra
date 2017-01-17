#OpenWrt/LEDE for Arduino Yún

##Description

OpenWrt/LEDE for Arduino Yún : lede-17.01

Extra files and scripts for building OpenWrt-Yun.

## License

See:
- [OpenWrt license](http://wiki.openwrt.org/about/license)
- [LEDE Project license](https://git.lede-project.org/?p=source.git;a=blob_plain;f=LICENSE;hb=HEAD)
- [OpenWrt Yún license](https://github.com/arduino/openwrt-yun/blob/master/LICENSE)
- [OpenWrt Yún license](https://github.com/RedSnake64/openwrt-yun/blob/15.05/LICENSE)

## Reference
- [Arduino LLC OpenWrt Yún](https://github.com/arduino/openwrt-yun)
- [RedSnake64 OpenWrt for Arduino Yún](https://github.com/RedSnake64/openwrt-yun/tree/15.05)

## Build
```bash
mkdir Build_Path_Some_Where
cd Build_Path_Some_Where
git clone https://git.lede-project.org/source.git;lede-17.01
git clone --depth=1 --branch master --single-branch https://github.com/nxhack/openwrt-yun-build-extra.git;lede-17.01
cd source
ln -s ../openwrt-yun-build-extra/* .
./build.sh
```
Please modify ./files/etc/opkg/distfeeds.conf

**Enjoy!**

## Behind the scenes
- [OpenWrt for Arduino Yún cheat sheet](http://www.egrep.jp/wiki/index.php/OpenWrt_for_Arduino_Yun_cheat_sheet)
