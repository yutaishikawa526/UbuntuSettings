#!/bin/bash -e

# 設定ファイル

# _DISK_DIR,_EFI_FNAME,_ROOT_FNAMEについては、
# 1a_create_disk.shで作成されたイメージディスクのみが対象
# 1b_setup_partitionを使用する場合は使わない
# 変更する必要はない
_DISK_DIR="$_DIR"/disk
_EFI_FNAME='efi.img'
_ROOT_FNAME='root.img'

# 1b_setup_partitionを使用する場合は
# 「/dev/sdb1」「/dev/sdb2」といったになる
# efiディスクのパス
_DISK_EFI="$_DISK_DIR/$_EFI_FNAME"
# rootディスクのパス
_DISK_ROOT="$_DISK_DIR/$_ROOT_FNAME"

# ディスクのマウントポイント
# すでにマウントポイントになっている場所は注意
_MNT_DIR="/mnt"

# 変更禁止
_COM_DIR="$_DIR/com"

# debianのディストリビューションの名前
_DEB_NAME=jammy

# debootstrapのときのオプション
_DEB_OPTION='--arch amd64 --variant minbase'
# debootstrapの対象のアーキテクチャ
_DEBOOT_TARGET=amd64

# カーネルのバージョン
_KERNEL_VER='5.15.0-25'

# その他で追加でインストールするパッケージ
_KERNEL_OTHER_INSTALL=''

# イーサネットのインターフェース名
# [ip a]コマンドで確認する
_NW_INTERFACE=enp0s25

# [grub-install]で指定するターゲット
_GRUB_TARGET=x86_64-efi

# [grub-efi-*]パッケージの名前
_GRUB_EFI_PACKAGE=grub-efi-amd64

# [1a_create_disk.sh]でのみ使用する
# rootディレクトリのサイズ(GB)
_ROOT_DSIZE=12