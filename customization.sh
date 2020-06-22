
exit

sudo pacman --sync sudo zsh
nano /etc/sudoers
# %wheel ALL=(ALL) ALL

useradd -m -G wheel -s /bin/zsh user
passwd user
# # pass

exit

# # user
# # pass

sudo pacman -Sy
sudo pacman -Su

sudo pacman --sync xf86-input-synaptics
sudo pacman --sync xf86-video-ati
sudo pacman --sync xf86-video-nouveau

sudo pacman --sync xorg-server

sudo pacman --sync mesa
sudo pacman --sync xorg-server-utils
sudo pacman --sync xorg-xinit
sudo pacman --sync xterm

sudo pacman --sync slim
sudo pacman --sync xfce4
sudo pacman --sync xfce4-goodies

sudo systemctl enable slim.service

sudo pacman --sync chromium
sudo pacman --sync firefox
sudo pacman --sync telegram

sudo pacman --sync filezilla
sudo pacman --sync transmission-gtk
sudo pacman --sync vlc

nano .xinitrc
# # exec startxfce4
chmod +x .xinitrc

sudo pacman --sync networkmanager

systemctl enable NetworkManager.service
systemctl start NetworkManager.service

systemctl enable dhcpcd
systemctl start dhcpcd

sudo systemctl reboot

sudo sed --in-place '/^#Color$/s/.//' /etc/pacman.conf
