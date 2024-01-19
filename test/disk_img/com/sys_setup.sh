#!/bin/bash -e

# sys等のマウントを実行
# debootstrap後に実行する

_DIR=$(cd $(dirname $0) ; cd ../ ; pwd)
source "$_DIR/conf/conf.sh"

if [ ! -d "$_MNT_DIR/sys" ] || [ ! -d "$_MNT_DIR/dev" ] || [ ! -d "$_MNT_DIR/proc" ] || [ ! -d "$_MNT_DIR/etc" ]; then
    echo 'debootstrapのあとに実行します。'
    exit 1
fi

sudo mount --bind /sys "$_MNT_DIR/sys"
sudo mount --bind /dev "$_MNT_DIR/dev"
sudo mount --bind /proc "$_MNT_DIR/proc"

sudo cp /etc/resolv.conf "$_MNT_DIR/etc/resolv.conf"
