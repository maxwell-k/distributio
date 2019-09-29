#!/bin/sh
# "Debian 10 amd64 standard nonfree"
dir=http://cdimage.debian.org/cdimage/unofficial/non-free
dir=$dir/cd-including-firmware/10.1.0-live+nonfree/amd64/iso-hybrid/
get_checksum() { wget -O- ${dir}SHA256SUMS | grep "$1"; }
grub_cfg() {
	printf 'menuentry %s {\n' "$1"
	# shellcheck disable=SC2016
	printf 'loopback l1 /%s\n' "$1"
	printf 'linux (l1)/live/vmlinuz-4.19.0-6-amd64 boot=live '
	printf 'components splash quiet findiso=/%s toram\n' "$1"
	printf 'initrd (l1)/live/initrd.img-4.19.0-6-amd64\n'
	printf '}\n'
}
