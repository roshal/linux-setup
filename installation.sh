
# pre-installation

# update the system clock

timedatectl set-ntp true

# partition the disks

sgdisk --zap-all --new 0 --typecode 0:ef00 /dev/sda
sgdisk --zap-all /dev/nvme0n1

pvcreate        /dev/nvme0n1
vgcreate volume /dev/nvme0n1

lvcreate volume --name root      --size  16g
lvcreate volume --name root-boot --size   1g
lvcreate volume --name root-home --size  16g
lvcreate volume --name root-var  --size  16g
lvcreate volume --name data      --size 256g
lvcreate volume --name swap      --size  32g

# make the filesystems

mkfs --type fat -n ESP -i 64617461 /dev/sda1

mkfs --type ext4 /dev/volume/root
mkfs --type ext4 /dev/volume/root-boot
mkfs --type ext4 /dev/volume/root-home
mkfs --type ext4 /dev/volume/root-var
mkfs --type ext4 /dev/volume/data

mkswap /dev/volume/swap
swapon /dev/volume/swap

# mount the file systems

mount /dev/sda1 /mnt/mnt

mount --options discard --source /dev/volume/root --target /mnt

mkdir /mnt/-
mkdir /mnt/boot
mkdir /mnt/home
mkdir /mnt/var

mount --options discard --source /dev/volume/data      --target /mnt/-
mount --options discard --source /dev/volume/root-boot --target /mnt/boot
mount --options discard --source /dev/volume/root-home --target /mnt/home
mount --options discard --source /dev/volume/root-var  --target /mnt/var

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

#

yes | sudo pacman --sync yarn
mkdir /-/grim

mkdir --parents ~/.config/sway

cp /etc/sway/config ~/.config/sway/config

ssh-keygen -b 4096

mkdir /-/aur
mkdir /-/pictures
mkdir /-/sublime
mkdir /-/code-workspaces
mkdir /-/github
mkdir /-/grim

sudo timedatectl set-ntp true

sudo localectl set-locale en_US.UTF-8

sudo localectl set-locale LC_TIME=C
sudo localectl set-locale LC_COLLATE=C
sudo localectl set-locale LC_MESSAGES=ru_RU.UTF-8
