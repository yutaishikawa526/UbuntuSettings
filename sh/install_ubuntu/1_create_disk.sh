#!/bin/bash -e

# イメージディスクの作成
# それぞれefi用とroot用を作成する

_DIR=$(cd $(dirname $0) ; pwd)
source "$_DIR/conf/conf.sh"

[ ! -e "$_DISK_EFI" ] || sudo rm "$_DISK_EFI"
[ ! -e "$_DISK_ROOT" ] || sudo rm "$_DISK_ROOT"

# efi用は512MB
dd if=/dev/zero of="$_DISK_EFI" bs=512M count=1
# root用は12GB
dd if=/dev/zero of="$_DISK_ROOT" bs=1G count=12

# フォーマット
sudo mkfs.vfat "$_DISK_EFI"
sudo mkfs.ext4 "$_DISK_ROOT"
