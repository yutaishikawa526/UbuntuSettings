#!/bin/bash -e

_LINUX_KERNEL_VER='5.15.0-91'

_INSTALL_KERNEL_CMD="apt install -y --no-install-recommends \
    linux-{image,headers}-$_LINUX_KERNEL_VER-generic \
    linux-firmware initramfs-tools efibootmgr"

_INSTALL_OTHER_CMD="apt install -y vim curl git ; "$'\n'" apt install -y grub-efi-amd64 ; "


