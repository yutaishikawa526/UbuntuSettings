#!/bin/bash -e

# その他のインストール

_DIR=$(cd $(dirname $0) ; pwd)
_LIST_DIR="$_DIR/result/list"
_BACKUP_DIR="$_DIR/result/backup"
_COM_DIR="$_DIR/com"


source "$_DIR/00_conf.sh"

# インストールコマンド作成
cmd="$_INSTALL_OTHER_CMD"

bash "$_COM_DIR/chroot_to_cmd.sh" "$cmd"

