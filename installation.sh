wifi-menu

timedatectl set-ntp true

fdisk /dev/sda
# o
# n
# w

pvcreate     /dev/sda1
vgcreate lvm /dev/sda1

lvcreate lvm -n boot -L   1g
lvcreate lvm -n home -L 256g
lvcreate lvm -n root -L  32g
lvcreate lvm -n swap -L   4g
lvcreate lvm -n var  -L  16g

mkfs.ext2 /dev/lvm/boot
mkfs.ext4 /dev/lvm/home
mkfs.ext4 /dev/lvm/root
mkfs.ext4 /dev/lvm/var

mkswap /dev/lvm/swap
swapon /dev/lvm/swap

mount /dev/lvm/root /mnt

mkdir /mnt/boot
mkdir /mnt/home
mkdir /mnt/var

mount /dev/lvm/boot /mnt/boot
mount /dev/lvm/home /mnt/home
mount /dev/lvm/var  /mnt/var

nano /etc/pacman.d/mirrorlist
# Server = http://mirror.yandecfx.ru/archlinux/$repo/os/$arch

pacstrap /mnt base

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

ln -fs /usr/share/zoneinfo/Europe/Moscow /etc/localtime
hwclock -w

nano /etc/locale.gen
# en_US.UTF-8 UTF-8
# ru_RU.UTF-8 UTF-8
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "archlinux" > /etc/hostname
nano /etc/hosts
# 127.0.1.1 archlinux.localdomain archlinux

nano /etc/mkinitcpio.conf
# HOOKS="... lvm2 filesystems ..."
mkinitcpio -p linux

passwd

pacman -S grub

nano /etc/default/grub
# GRUB_PRELOAD_MODULES="... lvm"

grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

pacman -S dialog wpa_supplicant

exit
umount -R /mnt
reboot
