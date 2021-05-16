#! /bin/bash

if [ ! -f 2021-03-04-raspios-buster-armhf-full.img ]; then
    if [ ! -f 2021-03-04-raspios-buster-armhf-full.zip ]; then
        wget -4 https://downloads.raspberrypi.org/raspios_full_armhf/images/raspios_full_armhf-2021-03-25/2021-03-04-raspios-buster-armhf-full.zip
    fi
    
    unzip 2021-03-04-raspios-buster-armhf-full.zip
fi

mkdir -p media
mkdir -p rootfs

losetup -P /dev/loop0 2021-03-04-raspios-buster-armhf-full.img
mount /dev/loop0p2 ./media

rsync -av --prune-empty-dirs \
    --exclude={'opt/Wolfram','opt/minecraft-pi','var','usr/lib/python*'} \
    --include={'*/','*.h','*.a','*pigpio*.so*'} \
    --exclude '*' \
    ./media/ ./rootfs

rsync -av --prune-empty-dirs \
    --include={'*/','etc/ld.so.conf.d/*'} \
    --exclude '*' \
    ./media/ ./rootfs

tar -cvzf rootfs.tgz rootfs

rm -rf rootfs

umount media

losetup -d /dev/loop0

