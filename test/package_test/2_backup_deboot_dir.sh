#!/bin/bash -e

_DIR=$(cd $(dirname $0) ; pwd)
_LIST_DIR="$_DIR/result/list"
_BACKUP_DIR="$_DIR/result/backup"
_COM_DIR="$_DIR/com"

bash "$_COM_DIR/result/backup.sh" "deboot_backup"