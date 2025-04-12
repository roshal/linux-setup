
#

# exit

#
#
#

### pre-installation

#
#

### update the system clock

#

timedatectl -- set-ntp true

#
#

### partition the disks

#

sgdisk --zap-all -- /dev/nvme0n1

#

sgdisk --zap-all --new 0 --typecode 0:ef00 -- /dev/sda

#

pvcreate /dev/nvme0n1

#

vgcreate volume /dev/nvme0n1

#

lvcreate volume --name root --size 64g

lvcreate volume --name root-var --size 64g

lvcreate volume --name root-home --size 128g

lvcreate volume --name data --size 128g

lvcreate volume --name swap --size 64g

lvcreate volume --name root-boot --size 1g

#
#

### make the filesystems

#

mkfs --type ext4 -- /dev/volume/data

mkfs --type ext4 -- /dev/volume/root

mkfs --type ext4 -- /dev/volume/root-boot

mkfs --type ext4 -- /dev/volume/root-home

mkfs --type ext4 -- /dev/volume/root-var

#

mkfs --type fat -n ESP -i 64617461 -- /dev/sda1

#

mkswap -- /dev/volume/swap

swapon -- /dev/volume/swap

#
#

### mount the file systems

#

mount --source /dev/sda1 --target /mnt/mnt

#

mount --options discard --source /dev/volume/root --target /mnt

#

mkdir -- /mnt/boot

mkdir -- /mnt/data

mkdir -- /mnt/home

mkdir -- /mnt/user

mkdir -- /mnt/var

#

mount --options discard --source /dev/volume/data --target /mnt/data

mount --options discard --source /dev/volume/root-boot --target /mnt/boot

mount --options discard --source /dev/volume/root-home --target /mnt/home

mount --options discard --source /dev/volume/root-user --target /mnt/user

mount --options discard --source /dev/volume/root-var --target /mnt/var

#
#
#

### installation

#
#

### select the mirrors

#

pacman --sync --refresh

#

yes | pacman --sync -- pacman-contrib

#

curl --output mirrors -- 'https://www.archlinux.org/mirrorlist/?protocol=https&use_mirror_status=on'

#

sed --expression '/^#\</!d;s/^#//' --in-place -- mirrors

#

rankmirrors -- mirrors > /etc/pacman.d/mirrorlist

#

sed --expression '/^#/d' --in-place -- /etc/pacman.d/mirrorlist
sed --expression '/^$/d' --in-place -- /etc/pacman.d/mirrorlist

#
#

### install essential packages

#

pacstrap /mnt

#
#
#

### configure the system

#
#

### fstab

#

genfstab /mnt >> /mnt/etc/fstab

#
#

### chroot

#

arch-chroot /mnt

#

# pacman --sync base

yes | pacman --sync base-devel

yes | pacman --sync dhcpcd

#
#

### time zone

#

ln --force --symbolic /usr/share/zoneinfo/Europe/Moscow -- /etc/localtime

#

hwclock --systohc

#
#

### localization

#

sed --expression '/^#en_US\.UTF-8 UTF-8$/s/^#/ /' --in-place -- /etc/locale.gen
sed --expression '/^#ru_RU\.UTF-8 UTF-8$/s/^#/ /' --in-place -- /etc/locale.gen

#

locale-gen

#
#
#

# localectl set-locale LANG=en_US.UTF-8

tee --append -- /etc/locale.conf <<< LANG=en_US.UTF-8

#

# tee --append -- /etc/locale.conf <<< LC_TIME=C

# tee --append -- /etc/locale.conf <<< LC_COLLATE=C

tee --append -- /etc/locale.conf <<< LC_TIME=POSIX

tee --append -- /etc/locale.conf <<< LC_COLLATE=POSIX

#

tee --append -- /etc/locale.conf <<< LC_MESSAGES=ru_RU.UTF-8

#
#
#

### network configuration

#
#

tee -- /etc/hostname <<< arch

#
#

### initramfs

#

yes | pacman --sync -- linux

yes | pacman --sync -- linux-firmware

yes | pacman --sync -- lvm2

#

sed --expression '/^HOOKS\>/s/\<block\>/& lvm2/' --in-place -- /etc/mkinitcpio.conf

#

mkinitcpio --preset linux

#
#

### root password

#

sudo -- chpasswd <<< root:pass

#
#

### boot loader

#

yes | pacman --sync -- efibootmgr

yes | pacman --sync -- grub

yes | pacman --sync -- intel-ucode

#

mkdir -- /boot/grub

#

grub-mkconfig --output /boot/grub/grub.cfg

#

### https://wiki.archlinux.org/index.php/GRUB#Default/fallback_boot_path

grub-install --efi-directory /mnt --removable

#
#
#

### reboot

#

exit

#

umount --recursive -- /mnt

#

reboot

#
#
#

### post-installation

### login root

sed --expression '/^# %wheel ALL=(ALL) ALL$/s/^# //' --in-place -- /etc/sudoers

useradd --groups wheel --create-home -- user

chpasswd <<< user:pass

#
#

### login user

#

sudo -- systemctl enable --now -- dhcpcd

#
#
#

yes | sudo -- pacman --sync -- yarn

mkdir -- /user/grim

mkdir --parents -- /home/user/.config/sway

cp -- /etc/sway/config /home/user/.config/sway/config

ssh-keygen -b 4096

#

sudo -- timedatectl -- set-ntp true

#

sudo -- localectl -- set-locale en_US.UTF-8

sudo -- localectl -- set-locale LC_TIME=C

sudo -- localectl -- set-locale LC_COLLATE=C

sudo -- localectl -- set-locale LC_MESSAGES=ru_RU.UTF-8
