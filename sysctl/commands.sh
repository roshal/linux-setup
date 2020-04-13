
exit

# # https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
sudo sysctl fs.inotify.max_user_watches
sudo sysctl fs.inotify.max_user_watches=524288

# # https://wiki.archlinux.org/index.php/Swap#Swappiness
cat /sys/fs/cgroup/memory/memory.swappiness
sudo sysctl vm.swappiness=25

sudo sysctl --load
sudo sysctl --system
sudo sysctl -f
sudo sysctl -p
