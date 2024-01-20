#!/bin/bash -e

# ubuntuのデスクトップ環境を構築する
# 「install_ubuntu」の手順の場合はCUIでしかアクセスできないため、ここでGUIの設定をする
# 以下の処理はubuntuのインストールが完了し、ubuntuをCUIで起動したあと、そのCUIから実行することを想定している

sudo apt update

# いくつかのパッケージインストール
sudo apt install -y vim git curl

# デスクトップ用パッケージのインストール
sudo apt install -y ubuntu-gnome-desktop
