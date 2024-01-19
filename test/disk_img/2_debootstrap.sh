#!/bin/bash -e

# debootstrapの実行

sudo apt update
sudo apt install -y debootstrap

_DIR=$(cd $(dirname $0) ; pwd)
source "$_DIR/conf/conf.sh"

# マウント
bash "$_COM_DIR/mount.sh"

sudo debootstrap $_DEB_OPTION "$_DEB_NAME" "$_MNT_DIR" http://de.archive.ubuntu.com/ubuntu

# fstabの設定
sudo genfstab -U "$_MNT_DIR" | sudo sh -c "cat >> $_MNT_DIR/etc/fstab"

# aptのミラーサイト設定
{
    echo 'deb http://de.archive.ubuntu.com/ubuntu jammy           main restricted universe'
    echo 'deb http://de.archive.ubuntu.com/ubuntu jammy-security  main restricted universe'
    echo 'deb http://de.archive.ubuntu.com/ubuntu jammy-updates   main restricted universe'
} | sudo sh -c "cat > $_MNT_DIR/etc/apt/sources.list"

# umount
bash "$_COM_DIR/unset.sh"
