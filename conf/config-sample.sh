#!/bin/bash

# 設定値のサンプル
# config.shファイルを作成し、そこに記載する

# rootとefiパーティションがあるディスク名
# [sudo fdisk -l]でefiとboot含め確認できる
_DISK=/dev/sdb
# efiパーティションのディスク
_EFI_PART=/dev/sdb1
# rootパーティションのディスク
_ROOT_PART=/dev/sdb2
# カーネルバージョン
_LINUX_KERNEL_VER=5.15.0-91
# 127.0.0.1に設定するドメイン名
_LOCALHOST=localhost
# 追加するlinuxユーザーの名前
_USER=user
# イーサネットのインターフェース名
# [ip a]コマンドで確認する
_NETWORK_INTERFACE=enp1s0
# マウントで使用するディスク名
_MOUNT_DIR=/mnt/tmp
# [grub-efi-*]パッケージの名前
_GRUB_EFI_PACKAGE=grub-efi-amd64
# [grub-install]のときのターゲットの名前
# [/usr/lib/grub/]ディレクトリに生成されるディレクトリが指定される
_GRUB_TARGET=x86_64-efi
# [debootstrap]実行時のアーキテクチャ名
_DEBOOT_TARGET=amd64
