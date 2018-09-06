# OpenWrt/LEDE for Arduino Yún (+LininoOS)

## Description

OpenWrt/LEDE for Arduino Yún : trunk (Bleeding Edge / Reboot)

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
[**READ FIRST**](https://openwrt.org/docs/guide-developer/build-system/use-buildsystem)

**Do everything as normal user, don't use root user or sudo!**

**Do not build in a directory that has spaces(and non ASCII characters) in its full path**

```bash
mkdir Build_Path_Some_Where
cd Build_Path_Some_Where
git clone https://github.com/openwrt/openwrt.git
git clone --depth=1 --branch master --single-branch https://github.com/nxhack/openwrt-yun-build-extra.git
cd openwrt
ln -s ../openwrt-yun-build-extra/* .
./build.sh
```
Please modify ./files/etc/opkg/distfeeds.conf

**Enjoy!**

## Breaking changes
- [ar71xx: move Arduino Yun to generic building code ](https://github.com/lede-project/source/commit/bb46b635df48d5c2368f98646c16e3333cbc11fb)

To use the new partitioning, you need to update your U-Boot env in advance:
```
setenv mtdparts "spi0.0:256k(u-boot)ro,64k(u-boot-env),15936k(firmware),64k(nvram),64k(art)ro"
setenv bootcmd "run addboard; run addtty; run addparts; run addrootfs; bootm 0x9f050000 || bootm 0x9fea0000"
saveenv
```

## Luci and Arduino WebPanel
The latest version of luci does not work with arduino-webpanel.
Unfortunately unable to fix, downgrade to lede-17.01 branch.

After setting Yun, upgrade the luci package to the latest version.

## Behind the scenes
- [OpenWrt for Arduino Yún cheat sheet](http://www.egrep.jp/wiki/index.php/OpenWrt_for_Arduino_Yun_cheat_sheet)
