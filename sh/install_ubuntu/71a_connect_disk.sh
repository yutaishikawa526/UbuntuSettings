#!/bin/bash -e

# ディスクイメージに接続する

_DIR=$(cd $(dirname $0) ; pwd)
source "$_DIR/conf/conf.sh"
source "$_DIR/conf/conf_mnt.sh"
source "$_DIR/com/com.sh"

# umount
bash "$_DIR/com/unset.sh"

# 再接続
loopback_path=`set_device "$_DISK_IMG_PATH"`

# 設定ファイルの書き換え
set_device_from_disk_img "$_DISK_IMG_PATH" "$_DIR/conf"
