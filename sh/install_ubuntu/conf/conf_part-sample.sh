#!/bin/bash -e

# パーティションに関する設定ファイル
# [1a_create_disk.sh][1b_parted_format.sh]でディスク作成、パーティション設定で使用する

# ディスクの合計サイズ
# [1a_create_disk.sh]でディスク作成時のみ使用する
_TOTAL_GSIZE=6

# efiパーティションのサイズ(M|G)
_EFI_SIZE='200M'

# bootパーティションのサイズ(M|G)
_BOOT_SIZE='2G'

# rootパーティションのサイズ(M|G)
_ROOT_SIZE='3G'

# スワップパーティションのサイズ(M|G)
# 'no'を指定することで、作成しない
_SWAP_SIZE='no'
