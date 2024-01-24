#!/bin/bash -e

# ディスクのパーティション分けとフォーマット
# 引数として、efiパーティションのサイズ、bootパーティションのサイズ、
# ルートパーティションのサイズ、スワップパーティションのサイズ
# を指定できる
# それぞれ[efi_size=200M][boot_size=2G][root_size=10G][swap_size=4G]
# という形式で指定する
# スワップパーティションのみ未指定だと生成されない

sudo apt install gdisk util-linux kpartx

_DIR=$(cd $(dirname $0) ; pwd)
source "$_DIR/conf/conf.sh"
source "$_DIR/conf/conf_mnt.sh"
source "$_DIR/com/com.sh"

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
    fi
done

# パーティション分け実行
set_partion "$_DISK_BASE" "$efi_size" "$boot_size" "$root_size" "$swap_size"

# フォーマット
set_format "$_DISK_BASE"

# 設定ファイルの書き換え
efi_partid=`name_to_partid "$disk" 'efi'`
boot_partid=`name_to_partid "$disk" 'boot'`
root_partid=`name_to_partid "$disk" 'root'`

modify_conf '_PAT_EFI' "$_DIR/conf/conf_mnt.sh" "/dev/disk/by-partuuid/$efi_partid"
modify_conf '_PAT_BOOT' "$_DIR/conf/conf_mnt.sh" "/dev/disk/by-partuuid/$boot_partid"
modify_conf '_PAT_ROOT' "$_DIR/conf/conf_mnt.sh" "/dev/disk/by-partuuid/$root_partid"
