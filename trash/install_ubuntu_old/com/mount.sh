#!/bin/bash -e

# ディスクのマウント

_DIR=$(cd $(dirname $0) ; cd ../ ; pwd)
source "$_DIR/conf/conf.sh"

if [ ! -d "$_MNT_DIR" ] ;then
    echo "$_MNT_DIR""は存在しません。"
    exit 1
fi
if [ ! -e "$_DISK_EFI" ] ;then
    echo "$_DISK_EFI""は存在しません。"
    exit 1
fi
if [ ! -e "$_DISK_ROOT" ] ;then
    echo "$_DISK_ROOT""は存在しません。"
    exit 1
fi

# umount
bash "$_COM_DIR/unset.sh"

sudo mount "$_DISK_ROOT" "$_MNT_DIR"
sudo mkdir -p "$_MNT_DIR/boot/efi"
sudo mount "$_DISK_EFI" "$_MNT_DIR/boot/efi"
