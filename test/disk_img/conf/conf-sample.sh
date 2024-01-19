#!/bin/bash -e

# 設定ファイル

_DISK_EFI="$_DIR"/result/efi.img
_DISK_ROOT="$_DIR"/result/root.img
_MNT_DIR="/mnt"
_COM_DIR="$_DIR"/com
_DEB_NAME=jammy
_DEB_OPTION='--arch amd64 --variant minbase'
_KERNEL_VER='5.15.0-91'
_KERNEL_OTHER_INSTALL=''
_NW_INTERFACE=enp0s25
_GRUB_TARGET=x86_64-efi
_DEBOOT_TARGET=amd64