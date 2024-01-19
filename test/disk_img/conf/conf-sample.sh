#!/bin/bash -e

# 設定ファイル

_DISK_DIR="$_DIR"/disk
_EFI_FNAME='efi.img'
_ROOT_FNAME='root.img'
_DISK_EFI="$_DISK_DIR/$_EFI_FNAME"
_DISK_ROOT="$_DISK_DIR/$_ROOT_FNAME"
_MNT_DIR="/mnt"
_COM_DIR="$_DIR/com"
_DEB_NAME=jammy
_DEB_OPTION='--arch amd64 --variant minbase'
_KERNEL_VER='5.15.0-91'
_KERNEL_OTHER_INSTALL=''
_NW_INTERFACE=enp0s25
_GRUB_TARGET=x86_64-efi
_DEBOOT_TARGET=amd64
_GRUB_EFI_PACKAGE=grub-efi-amd64