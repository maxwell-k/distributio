#!/bin/sh
# Copyright 2019 Keith Maxwell <keith.maxwell@gmail.com>
#
# SPDX-License-Identifier: Apache-2.0
#
# Fedora-Silverblue-ostree-x86_64-31-1.9.sh
dir=https://download.fedoraproject.org/pub/fedora/linux/releases/31/Silverblue/
dir=${dir}x86_64/iso
get_checksum() {
	curl -L $dir/Fedora-Silverblue-31-1.9-x86_64-CHECKSUM | \
	sed -n 's/SHA256 (\(.*\)) = \(.*\)/\2  \1/p'
}
grub_cfg() {
	printf 'menuentry %s {\n' "$1"
	# shellcheck disable=SC2016
	printf 'loopback l1 /%s\n' "$1"
	printf 'linux (l1)/isolinux/vmlinuz iso-scan/filename=/%s ' "$1"
	# The label is displayed by grub2 after the following commands:
	# > insmod regexp
	# > loopback l1 /Fedora*.iso
	# > ls (l1)
	printf 'inst.stage2=hd:LABEL=Fedora-SB-ostree-x86_64-31\n'
	printf 'initrd (l1)/isolinux/initrd.img\n'
	printf '}\n'
}
