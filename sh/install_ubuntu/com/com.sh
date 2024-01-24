#!/bin/bash -e

# 共通の関数

# ディレクトリか
function is_dir(){
    for i in $@
    do
        if [ ! -d "$i" ]; then
            echo "$i"'はディレクトリではありません'
        fi
    done
}

# ファイルか
function is_file(){
    for i in $@
    do
        if [ ! -e "$i" ]; then
            echo "$i"'はファイルではありません'
        fi
    done
}

# パーティション分けを行う
# $1:ディスクパス
# $2:efiパーティションのサイズ
# $3:bootパーティションのサイズ
# $4:rootパーティションのサイズ
# $5:swapパーティションのサイズ
function set_partion(){
    disk=$1
    efi_size=$2
    boot_size=$3
    root_size=$4
    swap_size=$5

    # 初期化
    sudo sgdisk --zap-all "$disk"

    # 作成
    sudo sgdisk --new '1::+1M' "$disk"
    sudo sgdisk --new "2::+$efi_size" "$disk"
    sudo sgdisk --new "3::+$boot_size" "$disk"
    sudo sgdisk --new "4::+$root_size" "$disk"
    if [[ "$swap_size" != 'no' ]]; then
        sudo sgdisk --new "5::+$swap_size" "$disk"
    fi

    # 名前付け
    sudo sgdisk --change-name '1:biosgrub' "$disk"
    sudo sgdisk --change-name '2:efi' "$disk"
    sudo sgdisk --change-name '3:boot' "$disk"
    sudo sgdisk --change-name '4:root' "$disk"
    if [[ "$swap_size" != 'no' ]]; then
        sudo sgdisk --change-name '5:swap' "$disk"
    fi

    sudo partprobe
}

# ディスクとパーティションラベルからpartuuidを取得する
# ない場合は'no'を返す
function name_to_partid(){
    disk=$1
    name=$2
    num=`sudo gdisk -l "$disk" | grep -E '^ +[1-9][0-9]* +.*[ ]+'$name'$' | sed -r 's#^ +([1-9][0-9]*) +.*[ ]+'$name'$#\1#g' | head -n 1`
    if ! [[ $num =~ ^.+$ ]]; then
        echo 'no'

    fi
    partid_large=`sudo sgdisk "$disk" "-i=$num" | grep '^Partition unique GUID:' | sed -i 's#^Partition unique GUID: +([^ ]+)$#\1#g' | head -n 1`
    if ! [[ $partid_large =~ ^.+$ ]]; then
        echo 'no'

    fi
    echo "$partid_large" | tr '[:upper:]' '[:lower:]'
}

# フォーマットを行う
# $1:ディスクパス
function set_format(){
    disk=$1

    efi_partid=`name_to_partid "$disk" 'efi'`
    boot_partid=`name_to_partid "$disk" 'boot'`
    root_partid=`name_to_partid "$disk" 'root'`
    swap_partid=`name_to_partid "$disk" 'swap'`

    sudo mkfs.vfat "/dev/disk/by-partuuid/$efi_num"
    sudo mkfs.ext4 "/dev/disk/by-partuuid/$boot_partid"
    sudo mkfs.ext4 "/dev/disk/by-partuuid/$root_partid"
    if [[ $swap_partid != 'no' ]]; then
        sudo mkswap "/dev/disk/by-partuuid/$swap_partid"
    fi
}

# 設定ファイルを書き換える
function modify_conf(){
    conf_name=$1
    conf_path=$2
    new_value=$3

    # 設定ファイルの書き換え
    count=`cat "$conf_path" | grep -E '^'$conf_name'=.*$' | wc -l`
    if [[ "$count" -ge 1 ]]; then
        sudo sed -i 's#^('$conf_name'=).*$#\1'$new_value'#g'
    else
        sudo sed -i '2a '$conf_name'='$new_value
    fi
}

# ディスクイメージファイルをループバックディスクに展開する
# ループバックディスクパスを返す
function set_device(){
    disk=$1

    sudo losetup | grep "$disk" \
        | sed -r 's#^(/dev/loop[0-9]+) *.*$#\1#g' \
        | xargs sudo kpartx -d

    sudo losetup | grep "$disk" \
        | sed -r 's#^(/dev/loop[0-9]+) *.*$#\1#g' \
        | xargs sudo losetup -d

    sudo kpartx -a "$disk"
    loopback=`sudo losetup | grep "$disk" | sed -r 's#^(/dev/loop[0-9]+) *.*$#\1#g' | head -n 1`
    is_file "$loopback"
    echo "$loopback"
}