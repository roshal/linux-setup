
exit

sudo fallocate -l 8g /swapfile

sudo chmod 600 /swapfile

sudo mkswap /swapfile

sudo swapon /swapfile

sudo swapoff /swapfile

cat /sys/fs/cgroup/memory/memory.swappiness

sudo sysctl vm.swappiness=60

sudo sysctl vm.swappiness=50
sudo sysctl vm.swappiness=25

# device                directory  type  options         dump  pass
# /dev/mapper/lvm-swap  none       swap  discard,pri=80  0     0
# /swapfile             none       swap  discard,pri=20  0     0

sudo swapon --priority -10 /swapfile
mkswap
