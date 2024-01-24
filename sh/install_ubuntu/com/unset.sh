#!/bin/bash -e

# ディスクのunmount

_DIR=$(cd $(dirname $0) ; cd ../ ; pwd)
source "$_DIR/conf/conf.sh"
source "$_DIR/conf/conf_mnt.sh"
source "$_DIR/com/com.sh"

sudo umount "$_MNT_POINT/sys" || true
sudo umount "$_MNT_POINT/dev/pts" || true
sudo umount "$_MNT_POINT/dev" || true
sudo umount "$_MNT_POINT/proc" || true
sudo umount "$_MNT_POINT/boot/efi" || true
sudo umount "$_MNT_POINT/boot" || true
sudo umount "$_MNT_POINT" || true
