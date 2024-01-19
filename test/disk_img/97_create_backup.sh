#!/bin/bash -e

# バックアップを作成
# 「現在日時_backup」という形式にディレクトリに作成される

_DIR=$(cd $(dirname $0) ; pwd)
source "$_DIR/conf/conf.sh"

backup_dir="$_DISK_DIR/"`date +%Y%m%d_%H-%M-%S`'_backup/'
if [ -d "$backup_dir" ]; then
    echo 'すでにバックアップディレクトリが存在します。'
    exit 1
fi

sudo mkdir "$backup_dir"

# umount
bash "$_COM_DIR/unset.sh"

sudo cp "$_DISK_EFI" "$backup_dir"
sudo cp "$_DISK_ROOT" "$backup_dir"
