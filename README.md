<!--
Copyright 2019 Keith Maxwell <keith.maxwell@gmail.com>

SPDX-License-Identifier: CC-BY-SA-4.0

README.md
-->

# Distributio

[![](https://reuse.software/badge/reuse-compliant.svg)](https://reuse.software/)

Boot certain Linux distributions from ISOs in ten steps:

1. Debian Live 10 amd64 gnome non-free
2. Debian Live 10 amd64 standard non-free
3. Fedora Silverblue x86_64 31 installation image
4. Lubuntu 18.04 desktop i386

The Debian distributions selected above include non-free firmware, for devices
including WiFi adapters. Distribution 1 does not include a desktop environment.

_For simplicity these instructions don't check any GnuPG signatures on
checksums; checking signatures on checksums is a good practice and should be
considered._

Alpine Linux does not appear to support booting ISO images directly; there is an
[open issue] on the bug tracker.

[open issue]: https://redmine.alpinelinux.org/issues/5384

## Overview

The process below will:

- check a device for errors
- format the disk with a single "FAT32" partition in a GPT partition table
- download distribution 1 above
- install grub including settings to boot distribution 1

## Steps

_These steps have been tested from distribution 1 above._

1. Clear the kernel ring buffer with `dmesg -c`, insert the USB device, and
   clear the ring buffer again is order to identify the device. In the example
   below the device is `/dev/sdb`.
   ```
   $ sudo dmesg -c
   ✂
   [   XX.XXXXXX] sd X:0:0:0: [sdb] Attached SCSI removable disk
   ```
2. Check the device for errors:
   ```sh
   sudo badblocks -v -w /dev/sdb
   ```
   This is a slow process as the entire device will be written several times.
3. Partition the disk: GPT partition table (`g`), single new partition with
   default number, start and end (`n`), type of Microsoft Basic Data (`t`, `11`,
   `w`):
   ```sh
   sudo fdisk /dev/sdb
   ```
4. Connect to the internet.
5. Install `grub` and `mkfs.vfat`:
   ```sh
   sudo apt update &&
   sudo apt install --yes curl dosfstools grub-efi-amd64-bin
   ```
6. Format and mount the disk:
   ```sh
   sudo mkfs.vfat -v -n distributio /dev/sdb1 &&
   sudo mount /dev/sdb1 /mnt &&
   cd /mnt
   ```
7. Install grub onto the device:
   ```sh
   sudo grub-install -v --target=x86_64-efi --efi-directory=. --boot-directory=.
   --removable --no-uefi-secure-boot
   ```
8. Download these files:
   ```sh
   curl -L https://github.com/maxwell-k/distributio/archive/master.tar.gz |
   sudo tar xz --strip-components=1
   ```
9. Download and check an ISO then generate grub configuration:
   ```sh
   sudo sh bin/prepare.sh debian-live-10.1.0-amd64-gnome+nonfree.sh
   ```
10. Reboot.

## References

- <https://docs.pagure.org/docs-fedora/bootloading-with-grub2.html>
- <https://wiki.archlinux.org/index.php/Multiboot_USB_drive>
- <https://wiki.debian.org/Firmware>
- <https://www.gnu.org/software/grub/manual/grub/grub.html>
- <https://manpages.debian.org/buster/grub2-common/grub-install.8.en.html>
- <http://man7.org/linux/man-pages/man7/dracut.cmdline.7.html>
- <https://github.com/aguslr/multibootusb>
