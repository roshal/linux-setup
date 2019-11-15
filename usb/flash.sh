
exit

sudo dd status=progress bs=4096 if=/-/arch/archlinux-2019.10.01-x86_64.iso of=/dev/sdb

sudo mkdir /mnt/iso-arch
sudo mkdir /mnt/usb-arch
sudo mount --options loop /-/arch/archlinux-2019.10.01-x86_64.iso /mnt/iso-arch
sudo mount /dev/sdb1 /mnt/usb-arch
cp --no-dereference --preserve=all --recursive /mnt/iso-arch/* /mnt/usb-arch
sync
sudo umount /mnt/iso-arch
sudo umount /mnt/usb-arch
