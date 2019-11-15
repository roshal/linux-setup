
wifi-menu

timedatectl set-ntp true

fdisk /dev/sda
# o
# n
# t
# 8e
# w

echo "noop" > /sys/block/sdb/queue/scheduler

pvcreate     /dev/sda1
vgcreate lvm /dev/sda1

lvcreate lvm -n boot -L   1g
lvcreate lvm -n home -L 512g
lvcreate lvm -n swap -L  12g
lvcreate lvm -n var  -L  16g

mkfs.btrfs /dev/sdb
mkfs.ext2  /dev/lvm/boot
mkfs.ext4  /dev/lvm/home
mkfs.ext4  /dev/lvm/var

mkswap /dev/lvm/swap
swapon /dev/lvm/swap

mount /dev/sdb /mnt -o defaults,discard,noatime

mkdir /mnt/boot
mkdir /mnt/home
mkdir /mnt/var

mount /dev/lvm/boot /mnt/boot
mount /dev/lvm/home /mnt/home
mount /dev/lvm/var  /mnt/var

nano /etc/pacman.d/mirrorlist
# Server = http://mirror.yandecfx.ru/archlinux/$repo/os/$arch

pacstrap /mnt base btrfs-progs dialog grub intel-ucode iw wpa_supplicant

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
