#
# References:
#  https://hub.docker.com/r/yhnw/openwrt-sdk/dockerfile
#  https://hub.docker.com/r/fasheng/openwrt-buildsdk/dockerfile
#

FROM ubuntu:18.04

MAINTAINER Hirokazu MORIKAWA <morikw2@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y build-essential libncurses5-dev gawk git subversion \
                       libssl-dev gettext zlib1g-dev swig unzip time
RUN apt-get install -y sudo wget python file

RUN useradd -m openwrt
RUN echo 'openwrt ALL=NOPASSWD: ALL' > /etc/sudoers.d/openwrt

WORKDIR /home/openwrt
RUN sudo -iu openwrt git clone https://github.com/openwrt/openwrt.git
RUN sudo -iu openwrt git clone --depth=1 --branch master --single-branch https://github.com/nxhack/openwrt-yun-build-extra.git
RUN sudo -iu openwrt ln -s /home/openwrt/openwrt-yun-build-extra/* /home/openwrt/openwrt/

#WORKDIR /home/openwrt/openwrt
#RUN sudo -iu openwrt ./build.sh

RUN echo 'Build OpenWrt-Yun: cd openwrt; ./build.sh'

CMD sudo -iu openwrt bash
