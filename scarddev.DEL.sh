#!/bin/bash
# SPDX-License-Identifier: LGPL-2.1-or-later
# Copyright © 2010-2018 ANSSI. All Rights Reserved.
# USB smartcard reader devices creation script for CLIP
# Copyright 2009 SGDN
# Author: Benjamin Morin <clipos@ssi.gouv.fr>
#
# Distributed under the terms of the GNU Lesser General Public License v2.1

[[ ${MAJOR} == "189" ]] || exit 0
[[ -n ${BUSNUM} ]] || exit 0
[[ -n ${DEVNUM} ]] || exit 0

rm -f /dev/bus/usb/${BUSNUM}/${DEVNUM}

