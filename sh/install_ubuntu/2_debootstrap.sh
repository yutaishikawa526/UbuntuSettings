#!/bin/bash -e

# debootstrapの実行

_DIR=$(cd $(dirname $0) ; pwd)
source "$_DIR/conf/conf.sh"
source "$_DIR/conf/conf_mnt.sh"
source "$_DIR/com/com.sh"

check_func 'debootstrap' 'debootstrap'
check_func 'genfstab' 'arch-install-scripts'

# マウント
bash "$_DIR/com/mount.sh"

sudo debootstrap $_DEB_OPTION "$_DEB_NAME" "$_MNT_POINT" http://de.archive.ubuntu.com/ubuntu

# fstabの設定
sudo genfstab -U "$_MNT_POINT" | sudo sh -c "cat >> $_MNT_POINT/etc/fstab"

# aptのミラーサイト設定
{
    echo 'deb http://de.archive.ubuntu.com/ubuntu jammy           main restricted universe'
    echo 'deb http://de.archive.ubuntu.com/ubuntu jammy-security  main restricted universe'
    echo 'deb http://de.archive.ubuntu.com/ubuntu jammy-updates   main restricted universe'
} | sudo sh -c "cat > $_MNT_POINT/etc/apt/sources.list"

# umount
bash "$_DIR/com/unset.sh"
