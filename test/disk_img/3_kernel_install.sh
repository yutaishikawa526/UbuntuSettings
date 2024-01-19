#!/bin/bash -e

# カーネルのインストール

sudo apt update

_DIR=$(cd $(dirname $0) ; pwd)
source "$_DIR/conf/conf.sh"

# マウント
bash "$_COM_DIR/mount.sh"
bash "$_COM_DIR/sys_setup.sh"

# カーネルインストール
sudo chroot "$_MNT_DIR" << EOF
    apt update
    apt install -y --no-install-recommends linux-image-$_KERNEL_VER-generic \
        $_KERNEL_OTHER_INSTALL
    exit
EOF

# umount
bash "$_COM_DIR/unset.sh"