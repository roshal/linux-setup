
exit

timedatectl set-ntp true

pvcreate     /dev/nvme0n1
vgcreate lvm /dev/nvme0n1

lvcreate lvm --name root --size  32g
lvcreate lvm --name boot --size   1g
lvcreate lvm --name home --size 256g
lvcreate lvm --name var  --size  16g
lvcreate lvm --name swap --size  16g

sgdisk --zap-all --new 0 --typecode 0:ef00 /dev/sdb

mkfs.fat /dev/sdb1

mkfs.ext4 /dev/lvm/root
mkfs.ext4 /dev/lvm/boot
mkfs.ext4 /dev/lvm/home
mkfs.ext4 /dev/lvm/var

mkswap /dev/lvm/swap
swapon /dev/lvm/swap

mount --options discard /dev/lvm/root /mnt

mkdir /mnt/efi

mount /dev/sda1 /mnt/boot

mkdir /mnt/boot
mkdir /mnt/home
mkdir /mnt/var

mount --options discard /dev/lvm/boot /mnt/boot
mount --options discard /dev/lvm/home /mnt/home
mount --options discard /dev/lvm/var  /mnt/var

sed -i.backup 's/^#\b//' /etc/pacman.d/mirrorlist
rankmirrors /etc/pacman.d/mirrorlist > /etc/pacman.d/mirrorlist

pacstrap /mnt base refind-install

genfstab -t uuid /mnt > /mnt/etc/fstab

arch-chroot /mnt

ln --force --symbolic /usr/share/zoneinfo/Europe/Moscow /etc/localtime
hwclock --systohc

sed --in-place ':a;N;$!ba;s/\n+/\n\n\n/' /etc/locale.gen
sed --in-place '0,/^$/s//\nru_RU.UTF-8 UTF-8/' /etc/locale.gen
sed --in-place '0,/^$/s//\nen_US.UTF-8 UTF-8/' /etc/locale.gen

locale-gen

localectl set-locale LANG=en_US.UTF-8

hostnamectl set-hostname host

sed --in-place '/^HOOKS\>/s/\<filesystems\>/lvm2 &/' /etc/mkinitcpio.conf
mkinitcpio -p linux

refind-install

exit
umount --recursive /mnt
reboot

adduser --groups docker,wheel user

pacman --sync chromium
pacman --sync firefox
pacman --sync gdm
pacman --sync sway
pacman --sync swayidle
pacman --sync swaylock
pacman --sync telegram
pacman --sync transmission-gtk
pacman --sync vlc
