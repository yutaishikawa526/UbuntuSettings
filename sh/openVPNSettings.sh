#!/bin/bash

## openVPNによるVPNの設定
## 最終的には~/openVPNSettingsディレクトリにクライアント用の鍵と証明書が作成される
## 参考サイト: https://zenn.dev/noraworld/articles/openvpn-installation-and-setup-guidebook

## パッケージインストール
sudo apt -y install openvpn git
mkdir ~/openVPNSettings
cd ~/openVPNSettings
git clone https://github.com/OpenVPN/easy-rsa.git
cd easy-rsa/easyrsa3

## 認証局設定
./easyrsa init-pki
./easyrsa build-ca
sudo cp pki/ca.crt /etc/openvpn

## サーバー鍵作成
./easyrsa build-server-full server nopass
sudo cp pki/issued/server.crt /etc/openvpn
sudo cp pki/private/server.key /etc/openvpn

## dh鍵作成
./easyrsa gen-dh
sudo cp pki/dh.pem /etc/openvpn

## クライアント側の認証情報設定
./easyrsa gen-crl
sudo cp pki/crl.pem /etc/openvpn
sudo chmod o+r /etc/openvpn/crl.pem

## vpnサーバー設定
sudo touch /etc/openvpn/server.conf
{
    echo 'port   1194'
    echo 'proto  udp'
    echo 'dev    tun'
    echo ''
    echo 'ca          ca.crt'
    echo 'cert        server.crt'
    echo 'key         server.key'
    echo 'dh          dh.pem'
    echo 'crl-verify  crl.pem'
    echo ''
    echo 'ifconfig-pool-persist ipp.txt'
    echo ''
    echo 'server 10.8.0.0 255.255.255.0'
    echo ''
    echo 'push "redirect-gateway def1 bypass-dhcp"'
    echo 'push "route 10.8.0.0 255.255.255.0"'
    echo 'push "dhcp-option DNS 8.8.8.8"'
    echo ''
    echo 'client-to-client'
    echo 'keepalive 10 120'
    echo 'comp-lzo'
    echo ''
    echo 'user  nobody'
    echo 'group nogroup'
    echo ''
    echo 'persist-key'
    echo 'persist-tun'
    echo ''
    echo 'status      /var/log/openvpn-status.log'
    echo 'log         /var/log/openvpn.log'
    echo 'log-append  /var/log/openvpn.log'
    echo ''
    echo 'verb 3'
} | sudo sh -c 'cat - > /etc/openvpn/server.conf'

## ファイアーウォール設定
sudo ufw allow 1194/udp
sudo ufw enable

## openVPNの起動とサービス登録
sudo systemctl start openvpn@server
sudo systemctl disable openvpn
sudo systemctl enable openvpn@server

## クライアント側鍵作成
./easyrsa build-client-full vpn_client
sudo cp /etc/openvpn/ca.crt ~/openVPNSettings
cp pki/issued/vpn_client.crt ~/openVPNSettings
cp pki/private/vpn_client.key ~/openVPNSettings

## 掃除
cd ~/openVPNSettings
sudo rm -R easy-rsa

# fin
