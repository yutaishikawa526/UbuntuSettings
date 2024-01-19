#!/bin/bash -e

# grubのインストール

_DIR=$(cd $(dirname $0) ; pwd)
source "$_DIR/conf/conf.sh"

# マウント
bash "$_COM_DIR/mount.sh"
bash "$_COM_DIR/sys_setup.sh"

sudo chroot "$_MNT_DIR" << EOF
    apt install -y $_GRUB_EFI_PACKAGE
    grub-install $_DISK_EFI --target=$_GRUB_TARGET
    update-grub
    exit
EOF

# umount
bash "$_COM_DIR/unset.sh"