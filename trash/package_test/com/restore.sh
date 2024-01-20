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

b_dir="$_BACKUP_DIR/$name"
if [ ! -d "$b_dir" ];then
    echo "[$b_dir]が存在しません。"
    return 1
fi
bash "$_COM_DIR/umount.sh"

[ ! -d "$_LIST_DIR" ] || sudo rm -R "$_LIST_DIR"
mkdir -p "$_LIST_DIR"

while read bkup ; do
    sudo cp -R "$bkup" "$_LIST_DIR"
done << END
`find "$b_dir" -mindepth 1 -maxdepth 1 -type d`
END