#!/bin/bash -e

# 初期化

_DIR=$(cd $(dirname $0) ; cd ../ ; pwd)
source "$_DIR/conf/conf.sh"

# umount
bash "$_COM_DIR/unset.sh"

# 削除
[ ! -e "$_DISK_EFI" ] || sudo rm "$_DISK_EFI"
[ ! -e "$_DISK_ROOT" ] || sudo rm "$_DISK_ROOT"
