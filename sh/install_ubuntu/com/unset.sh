#!/bin/bash -e

# ディスクのunmount

_DIR=$(cd $(dirname $0) ; cd ../ ; pwd)
source "$_DIR/conf/conf.sh"

[ ! -d "$_MNT_DIR/sys" ] || ! mountpoint -q "$_MNT_DIR/sys" || sudo umount "$_MNT_DIR/sys"
[ ! -d "$_MNT_DIR/dev" ] || ! mountpoint -q "$_MNT_DIR/dev" || sudo umount "$_MNT_DIR/dev"
[ ! -d "$_MNT_DIR/proc" ] || ! mountpoint -q "$_MNT_DIR/proc" || sudo umount "$_MNT_DIR/proc"
[ ! -d "$_MNT_DIR/boot/efi" ] || ! mountpoint -q "$_MNT_DIR/boot/efi" || sudo umount "$_MNT_DIR/boot/efi"
# これが最後でないといけない
[ ! -d "$_MNT_DIR" ] || ! mountpoint -q "$_MNT_DIR" || sudo umount "$_MNT_DIR"
