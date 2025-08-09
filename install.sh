#!/bin/bash

# Install doas
sudo pacman -Syu opendoas --noconfirm --needed
echo -e "permit nopass $USER as root"| sudo tee /etc/doas.conf 

# Create Directories
mkdir $HOME/Downloads/{video/final,audio} $HOME/Source $HOME/Documents -p
doas mkdir /mnt/{USB,SSD,HDD,Phone,Batocera}

# Install Text Editors
doas pacman -Syu zathura zathura-pdf-mupdf nano neovim obsidian --needed --noconfirm

# Install Browser (Firefox)
doas pacman -Syu firefox --noconfirm --needed

# Install Terminal Tools
doas pacman -Syu fzf bat lsd zoxide fd duf ripgrep tldr ffmpeg wget curl fastfetch htop starship git yazi man-db jq base-devel stow ntfs-3g
kitty openssh kitty nwg-look zram-generator nm-connection-editor pavucontrol bind trash-cli poppler imagemagick grim slurp --noconfirm --needed

# Install Compressing and Archiving Tools
doas pacman -Syu 7zip unzip zip gzip unrar tar --needed --noconfirm

# Install Programming Languages
doas pacman -Syu go python python-pip python-pipx gcc make cmake npm --noconfirm --needed

# Insatall ZSH and Oh_my_zsh
doas pacman -Syu zsh zsh-autosuggestions zsh-syntax-highlighting --noconfirm --needed
curl https://raw.githubusercontent.com/Ahmed-Dadousha/Arch/refs/heads/main/Scripts/oh_my_zsh.sh | sh

# Install Hyprland tools
doas pacman hyprland waybar waypaper swww wl-clipboard rofi-wayland -Syu --needed --noconfirm

# Install BlackArch
curl https://raw.githubusercontent.com/Ahmed-Dadousha/Arch/refs/heads/main/Scripts/blackarch.sh | sh

# Install Arabic Fonts
cd Fonts
doas cp -r Arimo Cousine Tinos Noto_Sans_Arabic /usr/share/fonts/

# Install Dotfiles
cd ..
cp -r .dotfiles $HOME/
cd $HOME/.dotfiles
stow .
doas fc-cache -fv

# Burpsuite Pro Launcher
cd -
doas cp BurpsuitePro.desktop /usr/share/applications
doas cp burpsuite.png        /usr/share/pixmaps

# Install Scripts
cd Scripts
doas cp * /usr/local/bin/ -r
doas chown adosha:adosha /usr/local/bin/*
doas chmod +x /usr/local/bin/* 

# Install Nerd Fonts
cd $HOME/Downloads
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -P ./MesloLGS-NF
doas mv MesloLGS-NF /usr/share/fonts

# Install Drivers
doas pacman -Syu nvidia-settings nvidia-utils nvidia linux-firmware-nvidia --noconfirm --needed

# Add the next Line To /etc/mkinitcpio.conf then regenerate the initramfs
# MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
# doas mkinitcpio -P

# Install AUR Helper Paru
cd $HOME/Source 
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm

# Install Hacking Tools
cd $HOME
gotools=(
github.com/projectdiscovery/katana/cmd/katana@latest
github.com/tomnomnom/waybackurls@latest
github.com/ffuf/ffuf/v2@latest
github.com/projectdiscovery/httpx/cmd/httpx@latest
github.com/lc/gau/v2/cmd/gau@latest
github.com/tomnomnom/assetfinder
)

for tool in "${gotools[@]}"; do
    go install -v $tool
done

paru -S sqlmap nmap --noconfirm --needed

# Power Management TLP and Auto-cpufreq
doas pacman -Syu tlp tlp-rdw --noconfirm --needed
doas systemctl enable NetworkManager-dispatcher.service
doas systemctl mask systemd-rfkill.service systemd-rfkill.socket
paru -S auto-cpufreq --noconfirm
doas systemctl enable --now auto-cpufreq 

# Drivers and Disks 
echo -e "#/dev/sda\nUUID=9C5CE1415CE116B4 /mnt/HDD ntfs defaults 0 2" | doas tee -a /etc/fstab

# Install Logout Menu
paru -S wlogout --noconfirm

# Install System Icons and themes
doas cp Andromeda /usr/share/themes -r
doas chown adosha:adosha /usr/share/themes/*

# Install Login Manager SDDM and Theme 
doas pacman -Syu sddm --noconfirm --needed
doas systemctl enable sddm
paru -S sddm-theme-sugar-candy
echo -e "[Theme]\nCurrent=Sugar-Candy\n\n[General]\nNumlock=on"| doas tee /etc/sddm.conf

# Install Python Libraries
pip install bs4 requests --break-system-changes
paru -S python-pytubefix --noconfirm

# Crontab 
doas systemctl enable cronie.service 
# Add WAYLAND_DISPLAY=wayland-1 to crontab -e

# Install unimatrix
paru -S unimatrix --noconfirm

# Install Plymouth
paru -S plymouth --noconfirm
# Add plymouth to HOOKS=() after udev in /etc/mkinitcpio.conf 
# Then run doas mkinitcpio -p linux
# Add splash to the end of this line GRUB_CMDLINE_LINUX_DEFAULT="" /etc/default/grub
# Then run doas grub-mkconfig -o /boot/grub/grub.cfg
# Set Them For Plymouth
# doas plymouth-set-default-theme -R spinfinity

# Pacmman Configuration
# Add ILoveCandy and Remove the # before Color to /etc/pacman.conf
# Install Andromeda theme, Tela Theme, Nordic cursors
# Tela Icon Theme  https://www.gnome-look.org/p/1279924/ ==> /usr/share/icons  ==> ~/.icons  ==> Icon Theme.
# Cursors Theme https://www.pling.com/p/1662218/         ==> /usr/share/icons  ==> ~/.icons  ==> Cursors Theme.
# Andromeda Theme https://www.gnome-look.org/p/2039961   ==> /usr/share/themes ==> ~/.themes ==> System Theme.
