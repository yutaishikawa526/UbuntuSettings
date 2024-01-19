#!/bin/bash -e

_DIR=$(cd $(dirname $0);cd ../ ;pwd)
_LIST_DIR="$_DIR/result/list"
_BACKUP_DIR="$_DIR/result/backup"
_COM_DIR="$_DIR/com"

if [ ! -d "$_LIST_DIR" ] ;then
    echo "$_LIST_DIR""は存在しません。"
    exit 1
fi

while read mpoint ; do
    sudo mount --bind /sys "$mpoint/sys"
    sudo mount --bind /dev "$mpoint/dev"
    sudo mount --bind /proc "$mpoint/proc"
done << END
`find "$_LIST_DIR" -mindepth 1 -maxdepth 1 -type d`
END
