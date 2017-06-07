# OpenWrt/LEDE for Arduino Yún (+LininoOS)

## Description

OpenWrt/LEDE for Arduino Yún : lede-17.01

Extra files and scripts for building OpenWrt-Yun (+LininoOS).

```
BusyBox v1.25.1 () built-in shell (ash)

     _________
    /        /\      _    ___ ___  ___
   /  LE    /  \    | |  | __|   \| __|
  /    DE  /    \   | |__| _|| |) | _|
 /________/  LE  \  |____|___|___/|___|                      lede-project.org
 \        \   DE /
  \    LE  \    /  -----------------------------------------------------------
   \  DE    \  /    Reboot (17.01-SNAPSHOT, r3401-e02b12c)
    \________\/    -----------------------------------------------------------

root@Arduino:~# cat /proc/cpuinfo
system type             : Atheros AR9330 rev 1
machine                 : Arduino Yun
processor               : 0
cpu model               : MIPS 24Kc V7.4
BogoMIPS                : 265.42
wait instruction        : yes
microsecond timers      : yes
tlb_entries             : 16
extra interrupt vector  : yes
hardware watchpoint     : yes, count: 4, address/irw mask: [0x0ffc, 0x0ffc, 0x0ffb, 0x0ffb]
isa                     : mips1 mips2 mips32r1 mips32r2
ASEs implemented        : mips16
shadow register sets    : 1
kscratch registers      : 0
package                 : 0
core                    : 0
VCED exceptions         : not available
VCEI exceptions         : not available
```

## License

See:
- [OpenWrt license](http://wiki.openwrt.org/about/license)
- [LEDE Project license](https://git.lede-project.org/?p=source.git;a=blob_plain;f=LICENSE;hb=HEAD)
- [OpenWrt Yún license](https://github.com/arduino/openwrt-yun/blob/master/LICENSE)
- [OpenWrt Yún license](https://github.com/RedSnake64/openwrt-yun/blob/15.05/LICENSE)
- [Linino license](https://github.com/linino/linino_distro/blob/master/LICENSE)

## Reference
- [Arduino LLC OpenWrt Yún](https://github.com/arduino/openwrt-yun)
- [RedSnake64 OpenWrt for Arduino Yún](https://github.com/RedSnake64/openwrt-yun/tree/15.05)
- [Linino distribution](https://github.com/linino/linino_distro)

## Build
```bash
mkdir Build_Path_Some_Where
cd Build_Path_Some_Where
git clone --branch lede-17.01 https://git.lede-project.org/source.git
git clone --depth=1 --branch lede-17.01 --single-branch https://github.com/nxhack/openwrt-yun-build-extra.git
cd source
ln -s ../openwrt-yun-build-extra/* .
./build.sh
```
Please modify ./files/etc/opkg/distfeeds.conf

**Enjoy!**

## Behind the scenes
- [OpenWrt for Arduino Yún cheat sheet](http://www.egrep.jp/wiki/index.php/OpenWrt_for_Arduino_Yun_cheat_sheet)
