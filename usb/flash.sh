
exit

sudo dd status=progress bs=4096 if=/-/images/archlinux-2019.10.01-x86_64.iso of=/dev/sdb

sync

sudo mkdir /-/mount/iso-arch
sudo mkdir /-/mount/usb-arch

sudo mount --options loop /-/images/archlinux-2019.10.01-x86_64.iso /-/mount/iso-arch
sudo mount /dev/sdb1 /-/mount/usb-arch

cp --no-dereference --preserve=all --recursive /mnt/iso-arch/* /-/mount/usb-arch

sync

sudo umount /-/mount/iso-arch
sudo umount /-/mount/usb-arch

sudo mkfs.fat /dev/sdb1
