#!/bin/bash -e

_DIR=$(cd $(dirname $0) ; pwd)
_LIST_DIR="$_DIR/result/list"
_BACKUP_DIR="$_DIR/result/backup"
_COM_DIR="$_DIR/com"


source "$_DIR/00_conf.sh"

curl 'http://ubuntu-master.mirror.tudos.de/ubuntu/dists/jammy-security/InRelease' -o "$_DIR/result/apt-key1.gpg"
curl 'http://ubuntu-master.mirror.tudos.de/ubuntu/dists/jammy-updates/InRelease' -o "$_DIR/result/apt-key2.gpg"
while read dir ; do
    sudo cp "$_DIR/result/apt-key1.gpg" "$dir/etc/apt/trusted.gpg.d"
    sudo cp "$_DIR/result/apt-key2.gpg" "$dir/etc/apt/trusted.gpg.d"
done << END
`find "$_LIST_DIR" -mindepth 1 -maxdepth 1 -type d`
END


# インストールコマンド作成
cmd=''
cmd="$cmd"$'\n'"apt update"
cmd="$cmd"$'\n'"$_INSTALL_KERNEL_CMD"

bash "$_COM_DIR/chroot_to_cmd.sh" "$cmd"

