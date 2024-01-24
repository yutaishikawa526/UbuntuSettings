#!/bin/bash -e

# イメージディスクの作成とループバックへ登録
# 引数としてディスクのサイズ(GB)を受け付ける
# [total_gsize=12]という形式を受け付ける

sudo apt install kpartx util-linux

_DIR=$(cd $(dirname $0) ; pwd)
source "$_DIR/conf/conf.sh"
source "$_DIR/conf/conf_mnt.sh"
source "$_DIR/com/com.sh"

total_gsize=12
efi_size='200M'
boot_size='2G'
root_size='10G'
swap_size='no'

for input in $@
    if [[ "$input" =~ ^efi_size=.*$ ]]; then
        efi_size=`echo "$input" | sed -r 's#^efi_size=(.*)$#\1#g'`
    elif [[ "$input" =~ ^boot_size=.*$ ]]; then
        boot_size=`echo "$input" | sed -r 's#^boot_size=(.*)$#\1#g'`
    elif [[ "$input" =~ ^root_size=.*$ ]]; then
        root_size=`echo "$input" | sed -r 's#^root_size=(.*)$#\1#g'`
    elif [[ "$input" =~ ^swap_size=.*$ ]]; then
        swap_size=`echo "$input" | sed -r 's#^swap_size=(.*)$#\1#g'`
    elif [[ "$input" =~ ^total_gsize=.*$ ]]; then
        total_gsize=`echo "$input" | sed -r 's#^total_gsize=(.*)$#\1#g'`
    fi
done

# ディスク作成
dd if=/dev/zero of="$_DISK_IMG_PATH" bs=1G count="$total_gsize"

# ループバックに書き込み
loopback_path=`set_device "$_DISK_IMG_PATH"`

# パーティション分け実行
set_partion "$loopback_path" "$efi_size" "$boot_size" "$root_size" "$swap_size"

# ループバック再書き込み
loopback_path=`set_device "$_DISK_IMG_PATH"`

# フォーマット
set_format "$_DISK_BASE"

# 設定ファイルの書き換え
efi_partid=`name_to_partid "$disk" 'efi'`
boot_partid=`name_to_partid "$disk" 'boot'`
root_partid=`name_to_partid "$disk" 'root'`

modify_conf '_PAT_EFI' "$_DIR/conf/conf_mnt.sh" "/dev/disk/by-partuuid/$efi_partid"
modify_conf '_PAT_BOOT' "$_DIR/conf/conf_mnt.sh" "/dev/disk/by-partuuid/$boot_partid"
modify_conf '_PAT_ROOT' "$_DIR/conf/conf_mnt.sh" "/dev/disk/by-partuuid/$root_partid"
modify_conf '_DISK_BASE' "$_DIR/conf/conf.sh" "$loopback_path"
