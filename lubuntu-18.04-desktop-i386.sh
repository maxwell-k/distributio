#!/bin/sh
# "lubuntu 18.04 i386":
dir=http://cdimage.ubuntu.com/lubuntu/releases/18.04/release/
get_checksum() { wget -O- ${dir}SHA256SUMS | grep "$1"; }
grub_cfg() {
	printf 'menuentry %s {\n' "$1"
	# shellcheck disable=SC2016
	printf 'loopback l1 /%s\n' "$1"
	printf 'linux (l1)/casper/vmlinuz boot=casper '
	printf 'iso-scan/filename=/%s noprompt noeject\n' "$1"
	printf 'initrd (l1)/casper/initrd.lz\n'
	printf '}\n'
}
