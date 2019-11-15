
# network
wifi-menu

# ntp
timedatectl set-ntp true

# restore
gpart /dev/sdb

# rescue
parted /dev/sdb rescue 2048 1073741823

# diff
grub-mkconfig | diff - /boot/grub/grub.cfg

# ids
blkid

# mbr
echo o.n.p.1....w. | tr . '\n' | fdisk /dev/sdb

# lvm
pvs
vgs
lvs

# parted
parted -s /dev/sdb mklabel gpt mkpart esp fat32 0% 100% set 1 boot on print

# mounts
findmnt

# lspci
lspci

# dmesg
dmesg

# xrandr
xrandr
xrandr --prop
