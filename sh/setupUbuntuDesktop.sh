#!/bin/bash -e

# ubuntuのデスクトップ環境を構築する
# 「install_ubuntu」の手順の場合はCUIでしかアクセスできないため、ここでGUIの設定をする
# 以下の処理はubuntuのインストールが完了し、ubuntuをCUIで起動したあと、そのCUIから実行することを想定している

sudo apt update

# いくつかのパッケージインストール
sudo apt install -y vim git curl

# デスクトップ用パッケージのインストール
sudo apt install -y ubuntu-desktop

# uefiの実行順序を変えられるツール
sudo apt install -y efibootmgr

# 必要になるかもしれないためfirmwareを入れておく
# 参考: https://access.redhat.com/documentation/ja-jp/red_hat_enterprise_linux/7/html/kernel_administration_guide/ch-manually_upgrading_the_kernel
sudo apt install -y linux-firmware
