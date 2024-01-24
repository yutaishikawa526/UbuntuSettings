#!/bin/bash -e

# ディスクのパーティション分けとフォーマット

sudo apt update -y

_DIR=$(cd $(dirname $0) ; pwd)
source "$_DIR/conf/conf.sh"
source "$_DIR/conf/conf_mnt.sh"
source "$_DIR/conf/conf_part.sh"
source "$_DIR/com/com.sh"

# パーティション分け実行
set_partion "$_DISK_BASE" "$_EFI_SIZE" "$_BOOT_SIZE" "$_ROOT_SIZE" "$_SWAP_SIZE"

# フォーマット
set_format "$_DISK_BASE"

# 設定ファイルの書き換え
efi_partid=`name_to_partid "$_DISK_BASE" 'efi'`
boot_partid=`name_to_partid "$_DISK_BASE" 'boot'`
root_partid=`name_to_partid "$_DISK_BASE" 'root'`

modify_conf '_PAT_EFI' "$_DIR/conf/conf_mnt.sh" "/dev/disk/by-partuuid/$efi_partid"
modify_conf '_PAT_BOOT' "$_DIR/conf/conf_mnt.sh" "/dev/disk/by-partuuid/$boot_partid"
modify_conf '_PAT_ROOT' "$_DIR/conf/conf_mnt.sh" "/dev/disk/by-partuuid/$root_partid"
