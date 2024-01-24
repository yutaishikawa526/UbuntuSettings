#!/bin/bash -e

# イメージディスクの作成とループバックへ登録
# またパーティションの作成とフォーマットまで行う

sudo apt update -y

_DIR=$(cd $(dirname $0) ; pwd)
source "$_DIR/conf/conf.sh"
source "$_DIR/conf/conf_mnt.sh"
source "$_DIR/conf/conf_part.sh"
source "$_DIR/com/com.sh"

# ディスク切断
unset_device "$_DISK_IMG_PATH"

# ディスク作成
dd if=/dev/zero of="$_DISK_IMG_PATH" bs=1G count="$_TOTAL_GSIZE"

# ループバックに書き込み
loopback_path=`set_device "$_DISK_IMG_PATH"`

# パーティション分け実行
set_partion "$loopback_path" "$_EFI_SIZE" "$_BOOT_SIZE" "$_ROOT_SIZE" "$_SWAP_SIZE"

# ループバック再書き込み
loopback_path=`set_device "$_DISK_IMG_PATH"`

# フォーマット
set_format "$loopback_path"

# 設定ファイルの書き換え
set_device_from_disk_img "$_DISK_IMG_PATH" "$_DIR/conf"
