#!/bin/bash -e

# sys等のマウントを実行
# debootstrap後に実行する

_DIR=$(cd $(dirname $0) ; cd ../ ; pwd)
source "$_DIR/conf/conf.sh"
source "$_DIR/conf/conf_mnt.sh"
source "$_DIR/com/com.sh"

is_dir "$_MNT_POINT/sys" "$_MNT_POINT/dev" "$_MNT_POINT/proc" "$_MNT_POINT/etc"

sudo mount --bind /sys "$_MNT_POINT/sys"
sudo mount --bind /dev "$_MNT_POINT/dev"
sudo mount --bind /proc "$_MNT_POINT/proc"

sudo cp /etc/resolv.conf "$_MNT_DIR/etc/resolv.conf"
