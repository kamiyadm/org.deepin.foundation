#!/bin/bash

# Copyright (c) 2022. Uniontech Software Ltd. All rights reserved.
#
# Author:     Iceyer <me@iceyer.net>
#
# Maintainer: Iceyer <me@iceyer.net>
#
# SPDX-License-Identifier: GPL-3.0-or-later

set -e

ARCH=$1

case $ARCH in
    amd64);;
    arm64);;
    "") echo "enter an architecture, like ./checkout_base.sh amd64" && exit;;
    *) echo "unknow arch \"$ARCH\", supported arch: amd64, arm64" && exit;;
esac


BASE_REF=org.deepin.foundation

# shellcheck source=/dev/null
#source ./package_list.sh

dpkg -l | grep qemu-user-static > /dev/null || sudo apt-get install -y qemu-user-static
dpkg -l | grep mmdebstrap > /dev/null || sudo apt-get install -y mmdebstrap

sudo rm -rf ${BASE_REF}

sudo mmdebstrap \
        --customize-hook="./remove_default_package.sh" \
        --components="main,contrib,non-free" \
        --variant=minbase \
        --architectures="$ARCH" \
        --include=ca-certificates \
        eagle \
        ${BASE_REF} \
        http://pools.uniontech.com/desktop-professional

sudo find ${BASE_REF} -printf "/runtime/%P\n" > org.deepin.foundation.install

sudo rm -rf ${BASE_REF}

sudo mmdebstrap \
        --customize-hook="./remove_default_package.sh" \
        --components="main,contrib,non-free" \
        --variant=minbase \
        --architectures="$ARCH" \
        --include=elfutils,file,ca-certificates,apt,gcc,g++,cmake,xz-utils,libicu-dev \
        eagle \
        ${BASE_REF} \
        http://pools.uniontech.com/desktop-professional

sudo chown -R "${USER}": ${BASE_REF}
