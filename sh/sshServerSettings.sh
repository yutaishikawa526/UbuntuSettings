#!/bin/bash -e

# sshのサーバー設定
# 最終的には~/sshSettingsディレクトリにssh接続用の秘密鍵が残る

## sshサーバーのインストール
sudo apt -y update
sudo apt -y install openssh-server

mkdir ~/sshSettings
cd ~/sshSettings

## ホームディレクトリ
HOME_DIR=`cd ~;pwd`
AUTH_KEY_PATH="$HOME_DIR/.ssh/authorized_keys"

## 自動起動設定
sudo systemctl enable ssh

## クライアント用秘密鍵、公開鍵の作成
ssh-keygen -t rsa -b 2048  -C ''  -f id_rsa_ssh_main
sudo touch "$AUTH_KEY_PATH"
cat id_rsa_ssh_main.pub | sudo sh -c 'cat - >> '"$AUTH_KEY_PATH"
sudo chmod 600 "$AUTH_KEY_PATH"

## 設定ファイルの修正
{
    echo 'Port 22'
    echo '#ListenAddress 0.0.0.0'
    echo ''
    echo '# Logging'
    echo 'LogLevel INFO'
    echo ''
    echo 'PasswordAuthentication no'
    echo 'PermitRootLogin yes'
    echo 'StrictModes yes'
    echo 'MaxAuthTries 6'
    echo 'MaxSessions 10'
    echo ''
    echo 'PubkeyAuthentication yes'
    echo "AuthorizedKeysFile $AUTH_KEY_PATH"
    echo ''
    echo 'KbdInteractiveAuthentication no'
    echo ''
    echo 'UsePAM no'
    echo ''
    echo ''
    echo '#AllowAgentForwarding yes'
    echo '#AllowTcpForwarding yes'
    echo '#GatewayPorts no'
    echo 'X11Forwarding yes'
    echo '#X11DisplayOffset 10'
    echo '#X11UseLocalhost yes'
    echo '#PermitTTY yes'
    echo 'PrintMotd no'
    echo '#PrintLastLog yes'
    echo '#TCPKeepAlive yes'
    echo '#PermitUserEnvironment no'
    echo '#Compression delayed'
    echo '#ClientAliveInterval 0'
    echo '#ClientAliveCountMax 3'
    echo '#UseDNS no'
    echo '#PidFile /run/sshd.pid'
    echo '#MaxStartups 10:30:100'
    echo '#PermitTunnel no'
    echo '#ChrootDirectory none'
    echo '#VersionAddendum none'
    echo '# Allow client to pass locale environment variables'
    echo 'AcceptEnv LANG LC_*'
    echo '# override default of no subsystems'
    echo 'Subsystem sftp /usr/lib/openssh/sftp-server'
} | sudo sh -c 'cat - > /etc/ssh/sshd_config'

## 公開鍵削除
rm id_rsa_ssh_main.pub

## ファイアーウォール設定
sudo ufw allow 22/tcp
sudo ufw enable

## 再起動
sudo systemctl restart ssh

# fin
