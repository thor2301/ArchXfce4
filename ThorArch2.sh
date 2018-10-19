#!/bin/bash
set -e
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
