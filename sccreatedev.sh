#!/sbin/runscript
# SPDX-License-Identifier: LGPL-2.1-or-later
# Copyright © 2010-2018 ANSSI. All Rights Reserved.
# USB smartcard reader devices creation startup script for CLIP
# Copyright 2010 SGDSN
# Author: Benjamin Morin <clipos@ssi.gouv.fr>
#
# Distributed under the terms of the GNU Lesser General Public License v2.1

ADDDEV=/sbin/scarddev.ADD.sh
DELDEV=/sbin/scarddev.DEL.sh

DEVICES="/sys/bus/usb/devices/[0-9]-[0-9]/"
DEVDIR="/dev/bus/usb/"

# 076b = Omnikey
# 08e6 = Gemalto
# 096e = Feitian
# 0a5c = Broadcom
# 413c = Claviers Dell
VENDORS="076b 08e6 096e 0a5c"

SCARDDEVICES=""

function enum_devices() {
	for iv in $(find ${DEVICES} -name "idVendor") ; do
		vendorid=$(head -n 1 -c 4 ${iv})
		for viv in ${VENDORS} ; do
			if [ ${viv} == ${vendorid} ] ; then
				SCARDDEVICES="${SCARDDEVICES} ${iv%/*}/" 
			fi
		done	
	done
}

function add_devices() {
	enum_devices
	
	for devpath in ${SCARDDEVICES} ; do
		if [ ! -d ${DEVDIR} ] ; then
			mkdir -p ${DEVDIR}
		fi
		dev=$(cat "${devpath}/dev")
		MINOR=${dev#*:}
		MAJOR=${dev%:*}
		BUSNUM=$(cat ${devpath}/busnum)
		DEVNUM=$(cat ${devpath}/devnum)
		BUSNUM=$(printf "%03d" ${BUSNUM})
		DEVNUM=$(printf "%03d" ${DEVNUM})
		BUSNUM=${BUSNUM} DEVNUM=${DEVNUM} MAJOR=${MAJOR} MINOR=${MINOR} ${ADDDEV} 	
	done
}

function del_devices() {
	enum_devices
	
	for devpath in ${SCARDDEVICES} ; do
		dev=$(cat "${devpath}/dev")
		MAJOR=${dev%:*}
		BUSNUM=$(cat ${devpath}/busnum)
		DEVNUM=$(cat ${devpath}/devnum)
		BUSNUM=$(printf "%03d" ${BUSNUM})
		DEVNUM=$(printf "%03d" ${DEVNUM})
		BUSNUM=${BUSNUM} DEVNUM=${DEVNUM} MAJOR=${MAJOR} ${DELDEV}
	done
}

depend() {
    before pcscd
}

start() {
	add_devices
	return 0
}

stop() {
	del_devices
	return 0
}

