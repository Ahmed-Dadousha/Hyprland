#!/bin/bash

# Install sudo
# usermod -aG wheel adosha 

# Create Directories
mkdir $HOME/Downloads/{video/final,audio} $HOME/Source $HOME/Documents -p
sudo mkdir /mnt/{USB,SSD,HDD,Phone,Batocera}

# Install Text Editors
sudo pacman -Syu zathura zathura-pdf-mupdf nano neovim obsidian --needed --noconfirm

# Install Browser (Firefox)
sudo pacman -Syu firefox --noconfirm --needed

# Install Terminal Tools
sudo pacman -Syu fzf bat lsd zoxide fd duf ripgrep tldr ffmpeg wget curl fastfetch htop starship git yazi man-db jq base-devel stow ntfs-3g
kitty openssh kitty nwg-look zram-generator nm-connection-editor pavucontrol bind trash-cli poppler imagemagick grim slurp dunst libnotify -cifs-utils -noconfirm --needed

# Install Compressing and Archiving Tools
sudo pacman -Syu 7zip unzip zip gzip unrar tar --needed --noconfirm

# Install Programming Languages
sudo pacman -Syu go python python-pip python-pipx gcc make cmake npm --noconfirm --needed

# Install Tmux

sudo pacman -Syu tmux --noconfirm --needed
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Insatall ZSH and Oh_my_zsh
sudo pacman -Syu zsh zsh-autosuggestions zsh-syntax-highlighting --noconfirm --needed
curl https://raw.githubusercontent.com/Ahmed-Dadousha/Arch/refs/heads/main/Scripts/oh_my_zsh.sh | sh

# Install Hyprland tools
sudo pacman hyprland waybar waypaper swww wl-clipboard rofi-wayland -Syu --needed --noconfirm

# Install BlackArch
curl https://raw.githubusercontent.com/Ahmed-Dadousha/Arch/refs/heads/main/Scripts/blackarch.sh | sh

# Install Arabic Fonts
cd Fonts
sudo cp -r Arimo Cousine Tinos Noto_Sans_Arabic /usr/share/fonts/

# Install Dotfiles
cd ..
cp -r .dotfiles $HOME/
cd $HOME/.dotfiles
stow .
sudo fc-cache -fv

# Burpsuite Pro Launcher
cd -
sudo cp BurpsuitePro.desktop /usr/share/applications
sudo cp burpsuite.png        /usr/share/pixmaps

# Install Scripts
cd Scripts
sudo cp * /usr/local/bin/ -r
sudo chown adosha:adosha /usr/local/bin/*
sudo chmod +x /usr/local/bin/* 

# Install Nerd Fonts
cd $HOME/Downloads
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -P ./MesloLGS-NF
sudo mv MesloLGS-NF /usr/share/fonts

# Install Drivers
sudo pacman -Syu nvidia-settings nvidia-utils nvidia linux-firmware-nvidia --noconfirm --needed

# Add the next Line To /etc/mkinitcpio.conf then regenerate the initramfs
# MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
# sudo mkinitcpio -P

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
github.com/jaeles-project/gospider@latest
github.com/tomnomnom/gf@latest
github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
)

for tool in "${gotools[@]}"; do
    go install -v $tool
done

# Install tools from main Repo and Black Arch Repo
sudo pacman -Syu gnu-netcat nmap sqlmap whois sublist3r tcpdump tcpflow wireshark-qt --needed --noconfirm

# Install Python tools
pipx install git+https://github.com/RevoltSecurities/ShodanX

# Power Management TLP and Auto-cpufreq
sudo pacman -Syu tlp tlp-rdw --noconfirm --needed
sudo systemctl enable NetworkManager-dispatcher.service
sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket
paru -S auto-cpufreq --noconfirm
sudo systemctl enable --now auto-cpufreq 

# Drivers and Disks 
echo -e "#/dev/sda\nUUID=9C5CE1415CE116B4 /mnt/HDD ntfs defaults 0 2" | sudo tee -a /etc/fstab

# Install Logout Menu
paru -S wlogout --noconfirm

# Install System Icons and themes
sudo cp Andromeda /usr/share/themes -r
sudo chown adosha:adosha /usr/share/themes/*

# Install Login Manager SDDM and Theme 
sudo pacman -Syu sddm --noconfirm --needed
sudo systemctl enable sddm
paru -S sddm-theme-sugar-candy
echo -e "[Theme]\nCurrent=Sugar-Candy\n\n[General]\nNumlock=on"| sudo tee /etc/sddm.conf

# Install Python Libraries
pip install bs4 requests --break-system-changes
sudo pacman -Syu yt-dlp --noconfirm --needed
paru -S python-pytubefix --noconfirm

# Crontab 
sudo systemctl enable cronie.service 
# Add WAYLAND_DISPLAY=wayland-1 to crontab -e

# Install unimatrix
paru -S unimatrix simple-mtpfs --noconfirm

# Install Plymouth
paru -S plymouth --noconfirm
# Add plymouth to HOOKS=() after udev in /etc/mkinitcpio.conf 
# Then run sudo mkinitcpio -p linux
# Add splash to the end of this line GRUB_CMDLINE_LINUX_DEFAULT="" /etc/default/grub
# Then run sudo grub-mkconfig -o /boot/grub/grub.cfg
# Set Them For Plymouth
# sudo plymouth-set-default-theme -R spinfinity

# Pacmman Configuration
# Add ILoveCandy and Remove the # before Color to /etc/pacman.conf
# Install Andromeda theme, Tela Theme, Nordic cursors
# Tela Icon Theme  https://www.gnome-look.org/p/1279924/ ==> /usr/share/icons  ==> ~/.icons  ==> Icon Theme.
# Cursors Theme https://www.pling.com/p/1662218/         ==> /usr/share/icons  ==> ~/.icons  ==> Cursors Theme.
# Andromeda Theme https://www.gnome-look.org/p/2039961   ==> /usr/share/themes ==> ~/.themes ==> System Theme.
