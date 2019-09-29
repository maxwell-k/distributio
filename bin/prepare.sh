#!/bin/sh
checksum=true
if [ "--no-checksum" = "$1" ] ; then
	checksum=false
	shift
fi
test -f "$1" || {
	echo "File not found: $1"
	exit 1
}
# shellcheck source=../debian-live-10.1.0-amd64-standard+nonfree.sh
. "$(realpath "$1")"
# shellcheck disable=SC2154
file="${1%.sh}.iso" &&
if [ ! -f "$file.sha256" ]; then get_checksum "$file" > "$file.sha256"; fi &&
if [ ! -f "$file" ]; then wget "$dir$file"; fi &&
if [ "$checksum" = true ]; then sha256sum -c "$file.sha256"; fi &&
grub_cfg "$file" > "${file%.iso}.cfg" &&
printf '%s written OK\n' "${file%.iso}.cfg"
