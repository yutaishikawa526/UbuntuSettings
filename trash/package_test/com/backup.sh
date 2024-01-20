#!/bin/bash -e

_DIR=$(cd $(dirname $0);cd ../ ;pwd)
_LIST_DIR="$_DIR/result/list"
_BACKUP_DIR="$_DIR/result/backup"
_COM_DIR="$_DIR/com"

name="$1"
if [[ "$name" =~ ^$ ]]; then
    echo '名前の指定がありません。'
    exit 1
fi

if [ ! -d "$_LIST_DIR" ] ;then
    echo "$_LIST_DIR""は存在しません。"
    exit 1
fi

b_dest="$_BACKUP_DIR/$name"
bash "$_COM_DIR/umount.sh"
[ ! -d "$b_dest" ] || sudo rm -R "$b_dest"
mkdir -p "$b_dest"

while read bkup ; do
    sudo cp -R "$bkup" "$b_dest"
done << END
`find "$_LIST_DIR" -mindepth 1 -maxdepth 1 -type d`
END
