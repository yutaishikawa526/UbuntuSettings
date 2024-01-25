#!/bin/bash -e

# ディスクのパーティション分けとフォーマット

sudo apt update -y

_DIR=$(cd $(dirname $0) ; pwd)
source "$_DIR/conf/conf.sh"
source "$_DIR/conf/conf_mnt.sh"
source "$_DIR/conf/conf_part.sh"
source "$_DIR/com/com.sh"

check_func 'findfs' 'util-linux'

# パーティション分け実行
set_partion "$_DISK_BASE" "$_EFI_SIZE" "$_BOOT_SIZE" "$_ROOT_SIZE" "$_SWAP_SIZE"

# フォーマット
set_format "$_DISK_BASE"

# 設定ファイルの書き換え
set_conf_by_device "$_DISK_BASE"
