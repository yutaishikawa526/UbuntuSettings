#!/bin/bash -e

# 設定ファイル

# ディスクイメージ
_DISK_BASE=/dev/sda

# マウントポイント
_MNT_POINT=/mnt

# debianのディストリビューションの名前
_DEB_NAME=jammy
# debootstrapのときのオプション
_DEB_OPTION='--arch amd64 --variant minbase'

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

# ディスクイメージファイルのフルパス
_DISK_IMG_PATH="$_DIR/disk/img.raw"
