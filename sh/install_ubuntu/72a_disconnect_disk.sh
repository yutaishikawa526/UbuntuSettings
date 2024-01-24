#!/bin/bash -e

# ディスクイメージとの接続を解除する

_DIR=$(cd $(dirname $0) ; pwd)
source "$_DIR/conf/conf.sh"
source "$_DIR/conf/conf_mnt.sh"
source "$_DIR/com/com.sh"

# umount
bash "$_DIR/com/unset.sh"

# 切断
unset_device "$_DISK_IMG_PATH"
