
pacman -S sudo zsh
nano /etc/sudoers
# %wheel ALL=(ALL) ALL

useradd -m -G wheel -s /bin/zsh user
passwd user
# pass

exit

# user
# pass

sudo pacman -Sy
sudo pacman -Su

sudo pacman -S xf86-input-synaptics
sudo pacman -S xf86-video-ati
sudo pacman -S xf86-video-nouveau

sudo pacman -S xorg-server

sudo pacman -S mesa
sudo pacman -S xorg-server-utils
sudo pacman -S xorg-xinit
sudo pacman -S xterm

sudo pacman -S slim
sudo pacman -S xfce4
sudo pacman -S xfce4-goodies

sudo systemctl enable slim.service

sudo pacman -S chromium
sudo pacman -S firefox
sudo pacman -S telegram

sudo pacman -S filezilla
sudo pacman -S transmission-gtk
sudo pacman -S vlc

nano .xinitrc
# exec startxfce4
chmod +x .xinitrc

sudo pacman -S networkmanager

systemctl enable NetworkManager.service
systemctl start NetworkManager.service

systemctl enable dhcpcd
systemctl start dhcpcd

sudo systemctl reboot
