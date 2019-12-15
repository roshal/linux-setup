
# pre-installation

# update the system clock

timedatectl set-ntp true

# partition the disks

sgdisk --zap-all --new 0 --typecode 0:ef00 /dev/sda
sgdisk --zap-all /dev/nvme0n1

pvcreate        /dev/nvme0n1
vgcreate volume /dev/nvme0n1

lvcreate volume --name root --size  32g
lvcreate volume --name boot --size   1g
lvcreate volume --name data --size 128g
lvcreate volume --name home --size 128g
lvcreate volume --name var  --size  16g
lvcreate volume --name swap --size  32g

# make the filesystems

mkfs --type fat /dev/sda1

mkfs --type ext4 /dev/mapper/volume-root
mkfs --type ext4 /dev/mapper/volume-boot
mkfs --type ext4 /dev/mapper/volume-data
mkfs --type ext4 /dev/mapper/volume-home
mkfs --type ext4 /dev/mapper/volume-var

mkswap /dev/mapper/volume-swap
swapon /dev/mapper/volume-swap

# mount the file systems

mount /dev/sda1 /mnt/mnt

mount --options discard --source /dev/mapper/volume-root --target /mnt

mkdir /mnt/boot
mkdir /mnt/-
mkdir /mnt/home
mkdir /mnt/var

mount --options discard --source /dev/mapper/volume-boot --target /mnt/boot
mount --options discard --source /dev/mapper/volume-data --target /mnt/-
mount --options discard --source /dev/mapper/volume-home --target /mnt/home
mount --options discard --source /dev/mapper/volume-var  --target /mnt/var

# installation

# select the mirrors

pacman --sync --refresh

yes | pacman --sync pacman-contrib

curl --output mirrors -- 'https://www.archlinux.org/mirrorlist/?protocol=https&use_mirror_status=on'

sed --in-place '/^#\</!d;s/.//' -- mirrors

rankmirrors mirrors > /etc/pacman.d/mirrorlist

sed --in-place '/^#/d' -- /etc/pacman.d/mirrorlist

# install essential packages

pacstrap /mnt

# configure the system

# fstab

genfstab /mnt >> /mnt/etc/fstab

# chroot

arch-chroot /mnt

# # # pacman --sync base
yes | pacman --sync base-devel
yes | pacman --sync dhcpcd

# time zone

ln --force --symbolic /usr/share/zoneinfo/Europe/Moscow /etc/localtime

hwclock --systohc

# localization

sed --in-place '/^#en_US\.UTF-8\>/s/./ /' /etc/locale.gen
sed --in-place '/^#ru_RU\.UTF-8\>/s/./ /' /etc/locale.gen

locale-gen

# localectl set-locale LANG=en_US.UTF-8

echo 'LANG=en_US.UTF-8' >> /etc/locale.conf
echo 'LC_TIME=C' >> /etc/locale.conf
echo 'LC_COLLATE=C' >> /etc/locale.conf
echo 'LC_MESSAGES=ru_RU.UTF-8' >> /etc/locale.conf

# network configuration

echo host > /etc/hostname

# initramfs

yes | pacman --sync linux
yes | pacman --sync linux-firmware
yes | pacman --sync lvm2

sed --in-place '/^HOOKS\>/s/\<block\>/& lvm2/' /etc/mkinitcpio.conf

mkinitcpio -p linux

# root password

echo root:pass | sudo chpasswd

# boot loader

yes | pacman --sync efibootmgr
yes | pacman --sync grub
yes | pacman --sync intel-ucode

mkdir /boot/grub

grub-mkconfig --output /boot/grub/grub.cfg

grub-install --efi-directory /mnt

# reboot

exit

umount --recursive /mnt

reboot

# post-installation

# login root

sed --in-place '/^# %wheel ALL=(ALL) ALL$/s/^..//' /etc/sudoers

useradd --groups wheel --create-home -- user

echo user:pass | chpasswd

exit

# login user

sudo systemctl enable --now dhcpcd

yes | sudo pacman --sync chromium
yes | sudo pacman --sync docker
yes | sudo pacman --sync firefox
yes | sudo pacman --sync gdm
yes | sudo pacman --sync nano
yes | sudo pacman --sync sway
yes | sudo pacman --sync swayidle
yes | sudo pacman --sync swaylock
yes | sudo pacman --sync telegram-desktop
yes | sudo pacman --sync terminator
yes | sudo pacman --sync transmission-gtk
yes | sudo pacman --sync vlc
yes | sudo pacman --sync xorg-server-xwayland
