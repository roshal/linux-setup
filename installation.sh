
# update the system clock

timedatectl set-ntp true

# partition the disks

sgdisk --zap-all /dev/nvme0n1
sgdisk --zap-all --new 0 --typecode 0:ef00 /dev/sda

# setup lvm

pvcreate     /dev/nvme0n1
vgcreate lvm /dev/nvme0n1

lvcreate lvm --name root --size  32g
lvcreate lvm --name boot --size   1g
lvcreate lvm --name home --size 256g
lvcreate lvm --name var  --size  16g
lvcreate lvm --name swap --size  32g

# make the filesystems

mkfs.fat /dev/sda1

mkfs.ext4 /dev/mapper/lvm-root
mkfs.ext4 /dev/mapper/lvm-boot
mkfs.ext4 /dev/mapper/lvm-home
mkfs.ext4 /dev/mapper/lvm-var

mkswap /dev/mapper/lvm-swap
swapon /dev/mapper/lvm-swap

# mount the file systems

mount --options discard /dev/mapper/lvm-root /mnt

mkdir /mnt/efi

mount /dev/sda1 /mnt/boot

mkdir /mnt/boot
mkdir /mnt/home
mkdir /mnt/var

mount --options discard /dev/mapper/lvm-boot /mnt/boot
mount --options discard /dev/mapper/lvm-home /mnt/home
mount --options discard /dev/mapper/lvm-var  /mnt/var

# installation

# select the mirrors

curl --output /etc/pacman.d/mirrorlist -- 'https://www.archlinux.org/mirrorlist/?protocol=https&use_mirror_status=on'

sed --in-place '/^#\b/!d;s/^.//' /etc/pacman.d/mirrorlist

yes | pacman --sync pacman-contrib

rankmirrors /etc/pacman.d/mirrorlist > /etc/pacman.d/mirrorlist

# install essential packages

pacstrap /mnt base

# configure the system

# fstab

genfstab -t uuid /mnt > /mnt/etc/fstab

# chroot

arch-chroot /mnt

# time zone

# timedatectl set-timezone Europe/Moscow

ln --force --symbolic /usr/share/zoneinfo/Europe/Moscow /etc/localtime

hwclock --systohc

# localization

sed --in-place ':a;N;$!ba;s/\n+/\n\n\n/' /etc/locale.gen
sed --in-place '0,/^$/s//\nru_RU.UTF-8 UTF-8/' /etc/locale.gen
sed --in-place '0,/^$/s//\nen_US.UTF-8 UTF-8/' /etc/locale.gen

locale-gen

# localectl set-locale LANG=en_US.UTF-8

echo 'LANG=en_US.UTF-8' >> /etc/locale.conf

# network configuration

# hostnamectl set-hostname host

echo host > /etc/hostname

# initramfs

yes | pacman --sync linux
yes | pacman --sync linux-firmware

sed --in-place '/^HOOKS\>/s/\<filesystems\>/lvm2 &/' /etc/mkinitcpio.conf
sed --in-place '/^HOOKS\>/s/^# /lvm2 &/' /etc/mkinitcpio.conf

mkinitcpio -p linux

# root password

echo root:pass | sudo chpasswd

# boot loader

yes | pacman --sync grub
yes | pacman --sync intel-ucode

grub-mkconfig --output /boot/grub/grub.cfg

mount /dev/sda1 /mnt

grub-install --efi-directory /mnt

umount /mnt

# reboot

yes | pacman --sync dhcpcd

exit

umount --recursive /mnt

reboot

# post-installation

# login root

yes | sudo pacman --sync base-devel

sudo sed '/^# %wheel ALL=(ALL) ALL/s/^..//' /etc/sudoers

sudo useradd --groups wheel --create-home -- user

echo user:pass | sudo chpasswd

exit

# login user

yes | sudo pacman --sync chromium
yes | sudo pacman --sync docker
yes | sudo pacman --sync firefox
yes | sudo pacman --sync gdm
yes | sudo pacman --sync sway
yes | sudo pacman --sync swayidle
yes | sudo pacman --sync swaylock
yes | sudo pacman --sync telegram
yes | sudo pacman --sync transmission-gtk
yes | sudo pacman --sync vlc
yes | sudo pacman --sync xorg-server-xwayland
