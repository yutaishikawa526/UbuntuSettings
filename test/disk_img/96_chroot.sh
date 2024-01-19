#!/bin/bash -e

# chrootする

_DIR=$(cd $(dirname $0) ; pwd)
source "$_DIR/conf/conf.sh"

# マウント
bash "$_COM_DIR/mount.sh"
bash "$_COM_DIR/sys_setup.sh"

sudo chroot "$_MNT_DIR"