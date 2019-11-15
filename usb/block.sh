
exit

df
df -h
df -T

blkid

lsblk
lsblk -f
lsblk -r
lsblk -J
lsblk --json
lsblk -O
lsblk --output-all
lsblk -S
lsblk --scsi


less -S
less --ch

lsblk -O | less -S
lsblk --output-all | less --chop-long-lines

fatlabel /dev/sdb arch

mount
mount -l

lshw

sudo fdisk -l

xargs sudo blockdev --getbsz /dev/sdb

echo /dev/sdb | xargs sudo blockdev --getbsz

cat /sys/class/block/sdb/size

lsof

sudo swapoff /dev/lvm/swap
