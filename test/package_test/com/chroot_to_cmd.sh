#!/bin/bash -e

_DIR=$(cd $(dirname $0);cd ../ ;pwd)
_LIST_DIR="$_DIR/result/list"
_BACKUP_DIR="$_DIR/result/backup"
_COM_DIR="$_DIR/com"

if [ ! -d "$_LIST_DIR" ] ;then
    echo 'debootが行われていません。'
    exit 1
fi

cmd=$1
if [[ "$cmd" =~ ^$ ]]; then
    echo 'コマンドの指定がありません。'
    exit 1
fi

bash "$_COM_DIR/mount.sh"


while read dir ; do
    sudo chroot "$dir" << EOF
        $cmd
        exit
EOF
done << END
`find "$_LIST_DIR" -mindepth 1 -maxdepth 1 -type d`
END


bash "$_COM_DIR/umount.sh"
