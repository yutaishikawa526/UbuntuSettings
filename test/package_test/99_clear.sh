#!/bin/bash -e

_DIR=$(cd $(dirname $0) ; pwd)
_LIST_DIR="$_DIR/result/list"
_BACKUP_DIR="$_DIR/result/backup"
_COM_DIR="$_DIR/com"

bash "$_COM_DIR/umount.sh"

sudo rm -R "$_LIST_DIR"
sudo rm -R "$_BACKUP_DIR"

mkdir -p "$_LIST_DIR"
mkdir -p "$_BACKUP_DIR"
