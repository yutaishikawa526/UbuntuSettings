#!/bin/bash -e

# ディスクのマウント

_DIR=$(cd $(dirname $0) ; cd ../ ; pwd)
source "$_DIR/conf/conf.sh"
source "$_DIR/conf/conf_mnt.sh"
source "$_DIR/com/com.sh"

is_dir "$_MNT_POINT"
is_file "$_PAT_EFI" "$_PAT_BOOT" "$_PAT_ROOT"

# umount
bash "$_COM_DIR/unset.sh"

sudo mount "$_PAT_ROOT" "$_MNT_POINT"
sudo mkdir -p "$_MNT_POINT/boot"
sudo mount "$_PAT_BOOT" "$_MNT_POINT/boot"
sudo mkdir -p "$_MNT_POINT/boot/efi"
sudo mount "$_PAT_EFI" "$_MNT_POINT/boot/efi"
