#!/bin/bash

# Install
#- Software
#  - "Работа с графикой"
#  - "Мультимедиа"
#- User morevna

# Grub configure
#https://www.altlinux.org/Grub#%D0%A1%D0%BF%D0%BE%D1%81%D0%BE%D0%B1_1

# Users
#- anim (1001)
#- morevna (2222)

if [ `id -u` != 0 ]; then
    echo "ERROR: You have to be root to run the script."
    exit 1
fi

apt-get update

PACKAGES="nextcloud-client \
    audacity \
    bindfs cachefilesd samba-client \
    calf-plugins sox \
    gimp \
    git git-gui gitk \
    geany \
    gparted \
    pavucontrol \
    shutter \
    xterm \
    obs-studio \
    peek \
    mypaint \
    firefox chromium \
    revelation \
    unison \
    x11vnc tk remmina remmina-plugins \
    vlc \
"

#for renderchan 
PACKAGES="$PACKAGES python3-modules-sqlite3"

#== Приятные украшательства ==
PACKAGES="$PACKAGES \
    gtk-theme-qogir \
    icon-theme-qogir \
    lightdm-settings
"

apt-get install -y $PACKAGES


# Extra soft
apt-get install -y eepm alien
rpm -qv zoom || epm play zoom
rpm -qv discord || epm play discord
rpm -qv anydesk || epm play anydesk

# gocryptfs
#apt-get install golang
#git clone https://github.com/rfjakob/gocryptfs.git
#cd gocryptfs
#./build-without-openssl.bash
#sudo cp -rf ./gocryptfs /usr/local/bin/
#cd ..
#rm -rf gocryptfs

# key-mon
#...

# Turbo VNC
#...

#== KRA / ORA Thumbnailers
wget https://moritzmolch.com/blog/files/1749/mmolch-thumbnailers.sh -O /tmp/mmolch-thumbnailers.sh && chmod +x /tmp/mmolch-thumbnailers.sh && /tmp/mmolch-thumbnailers.sh

#== 0install
curl -O https://get.0install.net/0install.sh && chmod +x 0install.sh && ./0install.sh install local && rm -f ./0install.sh

#== Tablet config
#sudo apt-get install python-module-pygtk
#http://mirror.centos.org/altarch/7/os/aarch64/Packages/python-appindicator-12.10.0-13.el7.aarch64.rpm
#https://github.com/wenhsinjen/ptxconf 
