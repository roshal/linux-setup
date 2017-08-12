# dd if=/dev/urandom of=/dev/<drive> bs=1M
# l /sys/firmware/efi/efivars
timedatectl set-ntp true
# timedatectl status
ping 8.8.8.8
# blkid
# df -T
# fdisk -l
# lsblk
gdisk
# o
# n
# 8e00
# w
	# modprobe dm-mod
	# modprobe -a dm-mod
# lvmdiskscan
# pvdisplay
# vgdisplay
# lvdisplay
# pvs
# vgs
# lvs
pvcreate /dev/sda1
vgcreate lvm /dev/sda1
lvcreate lvm -n root -L 20G
lvcreate lvm -n boot -L 512M
lvcreate lvm -n home -L 10G
lvcreate lvm -n swap -L 1G
mkfs.ext4 /dev/lvm/root
mkfs.ext4 /dev/lvm/boot
mkfs.ext4 /dev/lvm/home
mkswap /dev/lvm/swap
swapon /dev/lvm/swap
# swapon --show
mkdir /mnt/boot
mkdir /mnt/home
mount /dev/lvm/root /mnt
mount /dev/lvm/boot /mnt/boot
mount /dev/lvm/home /mnt/home
nano /etc/pacman.d/mirrorlist
# Server = http://mirror.yandecfx.ru/archlinux/$repo/os/$arch
pacman -Sy
pacstrap /mnt base
genfstab /mnt > /mnt/etc/fstab
# genfstab /mnt > /mnt/etc/fstab -U uuid
# genfstab /mnt > /mnt/etc/fstab -L label
arch-chroot /mnt
nano /etc/locale.gen
# en_US.UTF-8 UTF-8
# ru_RU.UTF-8 UTF-8
locale-gen
# nano /etc/vconsole.conf
echo "LANG=en_US.UTF-8" > /etc/locale.conf
export LANG=en_US.UTF-8
# timedatectl set-timezone Europe/Moscow
ln -s /usr/share/zoneinfo/Europe/Moscow /etc/localtime
# hwclock --systohc --utc
# hostnamectl set-hostname myhostname
# nano /etc/hosts
passwd
nano /etc/mkinitcpio.conf
# HOOKS="... lvm2 filesystems ..."
# pacman -Sy intel-ucode
# grub-mkconfig -o /boot/grub/grub.cfg # intell
mkinitcpio -p linux
nano /etc/lvm/lvm.conf
# use_lvmetad = 0
# pacman -S grub
# pacman -S efibootmgr
# pacman -S lvm2
nano /etc/default/grub
# GRUB_PRELOAD_MODULES="... lvm"
grub-install
grub-install --efi-directory=/boot
grub-install /dev/lvm/boot --recheck
grub-install --efi-directory=/boot/efi
grub-install --efi-directory=/boot/efi --target=x86_64-efi --recheck
grub-install --bootloader-id=archlinux --efi-directory=/boot/efi --target=x86_64-efi
grub-install --bootloader-id=arch --efi-directory=/boot/efi --target=x86_64-efi --recheck --debug
grub-mkconfig -o /boot/grub/grub.cfg
# grub-mkconfig -o /boot/efi/EFI/arch/grub.cfg
useradd user -G audio,power,storage,wheel
# useradd -m user -g users -G audio,power,storage,wheel
passwd user
exit
umount -R /mnt
reboot

# swap
fallocate -l 6G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
pacman -S systemd-swap
nano etc/systemd/swap.conf
systemctl enable systemd-swap
1wt3g5
# warning failed to connect to lvmetad falling back to device scanning
# ip link
# wifi-menu
# free -h
# localectl ststus
# hwclock --systohc

#

yaourt -Sy profile-sync-daemon

hwclock --systohc --utc

timedatectl set-timezone Europe/Moscow
localectl set-locale LANG=en_US.UTF-8

nano /etc/lvm/lvm.conf
# issue_discards = 1

# pvcreate /dev/sdb
# vgcreate ssd /dev/sdb
# lvcreate ssd -n root -L 20G
# btrfs subvolume create /mnt/@root
# mkfs.btrfs /dev/ssd/root
