#!/bin/bash -e

# バックアップを復元

_DIR=$(cd $(dirname $0) ; pwd)
source "$_DIR/conf/conf.sh"

echo '以下から選択してください。'
while read b_name ; do
    echo `basename "$b_name"`
done << END
`find "$_DISK_DIR" -mindepth 1 -maxdepth 1 -type d`
END

read -p ":" b_name
backup_dir="$_DISK_DIR/$b_name"

if [ ! -e "$backup_dir/$_EFI_FNAME" ] || [ ! -e "$backup_dir/$_ROOT_FNAME" ]; then
    echo 'バックアップが存在しません。'
    exit 1
fi

# clear
bash "$_COM_DIR/clear.sh"

sudo cp "$backup_dir/$_EFI_FNAME" "$_DISK_DIR"
sudo cp "$backup_dir/$_ROOT_FNAME" "$_DISK_DIR"
