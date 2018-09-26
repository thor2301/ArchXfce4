#!/bin/bash
set -e

echo "################################################################"
echo "####        REFLECTOR - SERVER NACH GESCHWINDIGKEIT          ###"
echo "################################################################"
# installing refector to test wich servers are fastest
sudo pacman -S --noconfirm --needed reflector
# finding the fastest archlinux servers
sudo reflector -l 50 -f 50 -c DE --sort rate --verbose --save /etc/pacman.d/mirrorlist
echo "################################################################"
echo "####       	SERVER GESPEICHERT          		   ###"
echo "################################################################"
cat /etc/pacman.d/mirrorlist
sudo pacman -Syu

echo "################################################################"
echo "#############            INSTALLATION BLUETOOH      ############"
echo "################################################################"
sudo pacman -S --noconfirm --needed blueman bluez bluez-libs bluez-utils bluez-firmware pulseaudio-bluetooth
sudo systemctl enable bluetooth.service
sudo sed -i 's/'#AutoEnable=false'/'AutoEnable=true'/g' /etc/bluetooth/main.conf

echo '/*Policy Kit -->  Datei "60-blueman.rules" im Ordner /etc/polkit-1/rules.d/ erstellen
        Allow users in wheel group to use blueman feature requiring root without authentication */
    polkit.addRule(function(action, subject) {
    if ((action.id == "org.blueman.network.setup" ||
     action.id == "org.blueman.dhcp.client" ||
    action.id == "org.blueman.rfkill.setstate" ||
    action.id == "org.blueman.pppd.pppconnect") &&
    subject.isInGroup("wheel")) {
    return polkit.Result.YES;
    }
    }); ' | sudo tee - /etc/polkit-1/rules.d/60-blueman.rules 

echo '/*Bluetooth bei booten --> Datei "50-bluetooth-hci-auto-poweron.rules" im Ordner /etc/udev/rules.d/ erstellen */
    CTION=="add", SUBSYSTEM=="bluetooth", KERNEL=="hci[0-9]*", RUN+="/bin/hciconfig %k up" '| sudo tee - /etc/udev/rules.d/50-bluetooth-auto.rules

echo "################################################################"
echo "########            NETZWERK MIT NETWORKMANAGER         ########"
echo "################################################################"
sudo pacman -S --noconfirm --needed networkmanager network-manager-applet nm-connection-editor
sudo systemctl enable NetworkManager

echo "################################################################"
echo "#######################     LOCALHOST    #######################"
echo "################################################################"
sudo echo 'ThorArch' | sudo tee - /etc/hostname
echo '
## Static table lookup for hostnames.
## See hosts(5) for details.

#<ip-address>   <hostname.domain.org>   <hostname>
127.0.0.1       localhost.localdomain   localhost
::1             localhost.localdomain   localhost
127.0.0.1       ThorArch.localdomain   ThorArch

# The following lines are desirable for IPv6 capable hosts
::1             localhost ip6-localhost ip6-loopback
ff02::1         ip6-allnodes
ff02::2         ip6-allrouters' | sudo tee - /etc/hosts

echo "################################################################"
echo "######################     AUDIO VIDEO    ######################"
echo "################################################################"
sudo pacman -S --noconfirm --needed alsa-tools alsa-utils alsa-plugins alsa-lib alsa-firmware pulseaudio-alsa pavucontrol gstreamer gst-plugins-good gst-plugins-bad gst-plugins-base gst-plugins-ugly gst-libav ffmpegthumbnailer playerctl vlc audacity # mp3splt-gtk

echo "################################################################"
echo "######################     REPOSITORIEN   ######################"
echo "################################################################"
echo '

[multilib]
Include = /etc/pacman.d/mirrorlist

[arcolinux_repo]
SigLevel = Required DatabaseOptional
Server = https://arcolinux.github.io/arcolinux_repo/$arch

[arcolinux_repo_3party]
SigLevel = Required DatabaseOptional
Server = https://arcolinux.github.io/arcolinux_repo_3party/$arch

[arcolinux_repo_iso]
SigLevel = Never
Server = https://arcolinux.github.io/arcolinux_repo_iso/$arch

# [archlinuxfr]
# SigLevel = Never
# Server = http://repo.archlinux.fr/$arch' | sudo tee --append /etc/pacman.conf

#sudo pacman-key --init
#sudo pacman-key --populate archlinux arcolinux
#sudo pacman-key --keyserver hkps://hkps.pool.sks-keyservers.net:443 -r 74F5DE85A506BF64
#sudo pacman-key -f 74F5DE85A506BF64
sudo pacman-key --keyserver hkp://pool.sks-keyservers.net:80 -r 74F5DE85A506BF64
sudo pacman-key --lsign-key  74F5DE85A506BF64

sudo pacman -Syu --noconfirm --needed trizen yaourt package-query yay

echo "################################################################"
echo "######################         XORG       ######################"
echo "################################################################"
sudo pacman -S --noconfirm --needed  xorg-server xorg-apps xorg-xinit xorg-twm xterm xf86-input-synaptics xorg-xrandr
#sudo localectl set-x11-keymap de pc105 nodeadkeys

echo "################################################################"
echo "######################     BUMBLEBEE      ######################"
echo "################################################################"
sudo pacman -S --noconfirm --needed bumblebee mesa xf86-video-intel nvidia-390xx nvidia-390xx-utils lib32-nvidia-390xx-utils lib32-virtualgl bbswitch lib32-mesa-libgl mesa-libgl
sudo gpasswd -a thorsten bumblebee 
sudo gpasswd -a thorsten video
sudo systemctl enable bumblebeed.service 

echo "################################################################"
echo "######################    XFCE4 LIGHTDM   ######################"
echo "################################################################"
sudo pacman -S --noconfirm --needed xfce4 xfce4-goodies lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings gtk-engine-murrine 
sudo systemctl enable lightdm.service
sudo systemctl set-default graphical.target
sudo pacman -R xfce4-artwork mousepad orage xfce4-eyes-plugin --noconfirm
yay -S --noconfirm xfce4-panel-profiles

echo "################################################################"
echo "######################    SOFTWARE ARCH   ######################"
echo "################################################################"
# DIENSTE
sudo pacman -S --noconfirm --needed acpid dbus avahi cups cronie neofetch galculator
sudo systemctl enable acpid.service cronie.service avahi-daemon dbus.service org.cups.cupsd.service

# SYSTEMTOOLS
sudo pacman -S --noconfirm --needed thunar tumbler thunar-archive-plugin thunar-volman catfish gvfs gvfs-mtp hardinfo gparted gnome-disk-utility glances unace unrar zip unzip sharutils uudeview arj cabextract file-roller xarchiver inkscape ristretto gimp archlinux-wallpaper transmission-cli transmission-gtk exfat-utils fsarchiver gnu-netcat gpm mtpfs

# SCHRIFTAREN
sudo pacman -S --noconfirm --needed adobe-source-sans-pro-fonts cantarell-fonts noto-fonts terminus-font ttf-bitstream-vera ttf-dejavu ttf-droid ttf-inconsolata ttf-roboto ttf-ubuntu-font-family
sudo pacman -Syyu 

# SYSTEMTOOLS AUR  BROWSER AUR OFFICE PROGRAMME
trizen -S --noconfirm --needed gksu inxi menulibre mugshot grub-customizer sublime-text-dev vivaldi vivaldi-codecs-ffmpeg-extra-bin ttf-ms-fonts yad libreoffice-fresh libreoffice-fresh-de polkit polkit-gnome python2-dbus python2-xdg qt5ct qt5-styleplugins qt5-tools qt5-webkit

# SYSTEMTREIBER
trizen -S --noconfirm --needed wd719x-firmware aic94xx-firmware wps-office chromium-widevine p7zip-gui pamac gcolor2 pulseaudio-equalizer-ladspa jmtpfs

# THEMES ICONS
trizen -S --noconfirm --noedit archlinux-artwork arc-icon-theme oxygen-icons-svg moka-icon-theme faba-icon-theme arc-gtk-theme adwaita-icon-theme adwaita-xfce-theme-git numix-gtk-theme-git numix-icon-theme-pack-git sardi-icons gtk-arc-flatabulous-theme-git breeze-snow-cursor-theme xdg-user-dirs hardcode-fixer-git breeze breeze-blue-cursor-theme xfwm4-theme-breeze zephyr-gtk-theme-git xdg-desktop-portal-gtk mint-y-icons

# HEADERS DKMS
sudo pacman -S --noconfirm --needed linux-headers dkms
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "################################################################"
echo "######################    ORDNER IN HOME  ######################"
echo "################################################################"
 xdg-user-dirs-update
 xdg-user-dirs-update --force

#[ -d $HOME"/.aur" ] || mkdir -p $HOME"/.aur"
[ -d $HOME"/.icons" ] || mkdir -p $HOME"/.icons"
[ -d $HOME"/.themes" ] || mkdir -p $HOME"/.themes"
[ -d $HOME"/.fonts" ] || mkdir -p $HOME"/.fonts"

echo "################################################################"
echo "######################     ALLE KERNE     ######################"
echo "################################################################"
sudo sed -i 's/#MAKEFLAGS="-j2"/MAKEFLAGS="-j5"/g' /etc/makepkg.conf
sudo sed -i 's/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T 4 -z -)/g' /etc/makepkg.conf

echo "################################################################"
echo "######################         ZSH        ######################"
echo "################################################################"
trizen -S --noconfirm --noedit zsh zsh-completions zsh-syntax-highlighting wget
wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - | sh
sudo sed -i 's/ZSH_THEME=\"robbyrussell\"/ZSH_THEME=\"random\"/g' ~/.zshrc
echo 'source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 
neofetch' | sudo tee --append  ~/.zshrc

sudo chsh thorsten -s /bin/zsh


# gpg --receive-keys 42C9C8D3AF5EA5E3
# trizen -S --noconfirm --noedit compton compton -conf