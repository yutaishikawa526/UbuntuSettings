#!/bin/bash -e

_DIR=$(cd $(dirname $0);cd ../ ;pwd)
_LIST_DIR="$_DIR/result/list"
_BACKUP_DIR="$_DIR/result/backup"
_COM_DIR="$_DIR/com"

if [ ! -d "$_LIST_DIR" ] ;then
    exit
fi

while read mpoint ; do
    ! mountpoint -q "$mpoint/sys" || sudo umount "$mpoint/sys"
    ! mountpoint -q "$mpoint/dev" || sudo umount "$mpoint/dev"
    ! mountpoint -q "$mpoint/proc" || sudo umount "$mpoint/proc"
done << END
`find "$_LIST_DIR" -mindepth 1 -maxdepth 1 -type d`
END