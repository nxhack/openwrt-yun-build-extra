#
# References:
#  https://hub.docker.com/r/yhnw/openwrt-sdk/dockerfile
#  https://hub.docker.com/r/fasheng/openwrt-buildsdk/dockerfile
#

FROM ubuntu:18.04

MAINTAINER Hirokazu MORIKAWA <morikw2@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y apt-utils && apt-get -y upgrade && \
apt-get install -y sudo wget python file curl \
       build-essential libncurses5-dev gawk git subversion \
       libssl-dev gettext zlib1g-dev swig unzip time && \
apt-get -y autoremove && apt-get clean && \
useradd -c "OpenWrt Builder" -m -d /home/openwrt -s /bin/bash openwrt && \
echo 'openwrt ALL=NOPASSWD: ALL' > /etc/sudoers.d/openwrt

USER openwrt
ENV HOME /home/openwrt
WORKDIR /home/openwrt

RUN git clone https://github.com/openwrt/openwrt.git && \
git clone --depth=1 --branch master --single-branch https://github.com/nxhack/openwrt-yun-build-extra.git && \
ln -s /home/openwrt/openwrt-yun-build-extra/* /home/openwrt/openwrt/

#
# For the first time build:
#   'cd openwrt; ./build.sh'
#
# From the next time build:
#   'cd openwrt; ./rebuild.sh
#

CMD ["/bin/bash"]
