# nvidiaドライバーのインストールの実験、確認手順を保存しておく
- [ここの焼き直し](https://github.com/yutaishikawa526/UbuntuSettings/issues/6)

## linuxの違い確認
`dpkg -l | grep linux`で確認
動いている側
```
linux-firmware
linux-generic-hwe-22.04
linux-headers-6.2.0-26-generic
linux-headers-generic-hwe-22.04
linux-hwe-6.2-headers-6.2.0-26
linux-image-generic-hwe-22.04
linux-modules-extra-6.2.0-26-generic

linux-objects-nvidia-535-6.2.0-26-generic
linux-signatures-nvidia-6.2.0-26-generic
```
があった\
`dpkg -l | grep nvidia`での違いは上述の`~-objects-nvidia-~`と`~-signatures-nvidia-~`しかなかった


## 実験手順
1. `dpkg -l | grep linux >  linux_0.txt`で保存後、`sudo apt install nvidia-driver-535`
2. `linux-objects-nvidia-535-6.2.0-26-generic linux-signatures-nvidia-6.2.0-26-generic`のインストール後、`dpkg -l | grep linux >  linux_1.txt`と`dpkg -l | grep nvidia > nvidia_1.txt`で変化を確認→rebootで確認
3. 上記2で変化がない場合は`sudo apt -y purge *nvidia*;sudo apt -y autoremove`
4. `sudo apt install linux-firmware linux-headers-6.2.0-26-generic linux-modules-extra-6.2.0-26-generic`を実行後,`dpkg -l | grep linux > linux_2.txt`と`dpkg -l | grep nvidia > nvidia_2.txt`を確認後reboot
5. `sudo apt install nvidia-driver-535`でrebootし確認
6. `dpkg -l | grep linux > linux_3.txt`と`dpkg -l | grep nvidia > nvidia_3.txt`で変化を確認
7. `sudo apt purge *nvidia*;sudo apt purge linux-firmware linux-headers-6.2.0-26-generic linux-hwe-6.2-headers-6.2.0-26 linux-modules-extra-6.2.0-26-generic;sudo apt autoremove`を実行しreboot
8. `sudo apt install linux-headers-6.2.0-26-generic`を実行後reboot
9. `sudo apt install nvidia-driver-535`でrebootし確認

## 結果
- 1→追加したパッケージが増えただけreboot後もdriverが効かない
- 6→driverが動いた
- 4→`linux-firmware linux-headers-6.2.0-26-generic linux-hwe-6.2-headers-6.2.0-26 linux-modules-extra-6.2.0-26-generic`が新たに追加。指定以外の追加は`linux-hwe-6.2-headers-6.2.0-26`のみ
- 6→`linux-objects-nvidia-535-6.2.0-26-generic linux-signatures-nvidia-6.2.0-26-generic`は追加されていなかったので要らなさそう
- 9→driverが動いた。`nvidia-smi`も動いた

## 結論
- 最終結論としては`linux-headers-${ver}-generic linux-modules-${ver}-generic linux-modules-extra-${ver}-generic`もデフォルトでインストールする
- `efibootmgr`はuefiの実行順序を変えられるらしい。追加のときにインストールしよう
- `linux-firmware`も必要かもしれないのでextraに入れておく
- [module-extraの必要性について](https://gihyo.jp/admin/serial/01/ubuntu-recipe/0578)。→dkmsにはheadersが必要らしい。だからnvidiaが動かなかった

## その他コマンド
- chroot
```sh
root_dev=/dev/nvme0n1p4
boot_dev=/dev/nvme0n1p3
efi_dev=/dev/nvme0n1p1
mount_point=/mnt

sudo mount "$root_dev" "$mount_point"
sudo mount "$root_dev" "$mount_point/boot"
sudo mount "$efi_dev" "$mount_point/boot/efi"
sudo mount /dev "$mount_point/dev"
sudo mount /proc "$mount_point/proc"
sudo mount /sys "$mount_point/sys"

sudo chroot "$mount_point"

```

- unmount
```sh
root_dev=/dev/nvme0n1p4
boot_dev=/dev/nvme0n1p3
efi_dev=/dev/nvme0n1p1
mount_point=/mnt

sudo umount "$mount_point/dev"
sudo umount "$mount_point/proc"
sudo umount "$mount_point/sys"
sudo umount "$mount_point/boot/efi"
sudo umount "$mount_point/boot"
sudo umount "$mount_point"
```

- sedによるファイルの修正
`sed -i 's#    .*$##g' "$filepath"`は`sed -i 's#  .*$##g`のがいいかも?
```sh
filepath='filename~~~';sed -i 's#^ii *##g' "$filepath";sed -i 's#^rc *##g' "$filepath";sed -i 's#    .*$##g' "$filepath"
```

- nvidiaパッケージのアンスト
```sh
sudo apt purge '*nvidia*';sudo apt autoremove
```

## その他
- [nvidiaのインストール公式](https://ubuntu.com/server/docs/nvidia-drivers-installation)。公式が一番か
- `sudo apt install  linux-modules-nvidia-535-6.20.0-26-generic`ならdriverとして認識した…
- `sudo apt install nvidia-driver-535`も必要そう
- `apt install`に`apt install linux-modules-~~~`もつけておく
- `sudo apt-cache policy linux-modules-nvidia-* | grep -E 'linux-modules-.*-(6\.2\.0-26|5\.15\.0-25)-generic'`module形式の確認
- [システムに登録されているか確認](https://note.com/sylphid_modder/n/nfa5612a989a8)
- nvidia-driver-535,545のインストールではdriverが効かない
- `sudo ubuntu-drivers install`では545が入る
- `sudo ubuntu-drivers install nvidia:535`でも`linux-modules-nvidia-~~`が入らないため、driverが効かない
- 動いているnvmeの方は`linux-modules-nvidia-~~`が入っていないけど動いている
