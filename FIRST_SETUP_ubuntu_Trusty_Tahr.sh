#!/bin/bash

#
# Copyright (c) 2014-2016 Arduino LLC. All right reserved.
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

sudo apt-get update

sudo apt-get install -y git subversion build-essential asciidoc \
	fastjar flex gawk libgtk2.0-dev intltool zlib1g-dev \
	genisoimage libncurses5-dev libssl-dev ruby sdcc unzip \
	bison libboost-dev libxml-parser-perl libusb-dev bin86 \
	bcc sharutils default-jdk mercurial cvs bzr \
	curl g++-multilib squashfs-tools ccache

echo "ALL DONE! YEAH!!"
