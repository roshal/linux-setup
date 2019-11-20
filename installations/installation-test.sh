wifi-menu

timedatectl set-ntp true

gdisk /dev/sda
# o
# n
# t
# 8e00
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

pacstrap /mnt base grub dialog iw wpa_supplicant

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

nano /etc/default/grub
# GRUB_PRELOAD_MODULES="... lvm"

grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

exit
umount -R /mnt
reboot

useradd user -G wheel
passwd user
nano /etc/sudoers
# %wheel ALL=(ALL) ALL

pacman -Sy

pacman -S xorg-server xorg-drivers
pacman -S xfce4 xfce4-goodies lxdm
pacman -S networkmanager network-manager-applet ppp
systemctl enable lxdm NetworkManager

pacman -S xf86-video-intel lib32-intel-dri
pacman -S nvidia  nvidia-utils  lib32-nvidia-utils
pacman -S xf86-video-ati lib32-ati-dri

grub-install
grub-install --target=i386-pc

pacman -S iw and wpa_supplicant dialog
