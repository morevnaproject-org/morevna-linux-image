
Base system: Linux Mint 19

## Базовая настройка системы

```
# Настроить метки дисков (нужно для упрощения клонирования системы)
e2label device STUDIO_ROOT
nano /etc/fstab
> LABEL=STUDIO_ROOT /               ext4    errors=remount-ro 0       1
> LABEL=STUDIO_HOME /home           ext4    defaults        0       2

```

```
# Пользователи

- morevna - 1111
- anim - 1001

useradd -m -k /etc/skel/ -s /bin/bash -u 1111 morevna
passwd morevna
useradd -m -k /etc/skel/ -s /bin/bash -u 1001 anim
passwd anim

```

```
# NFS-Cache

apt-get install bindfs nfs-common nfs-kernel-server  cachefilesd ecryptfs-utils 
#nano /etc/fstab
#> 192.168.1.11:/home/data /home/data nfs fsc,noauto 0 0
nano /etc/default/cachefilesd
> RUN=yes
nano /etc/cachefilesd.conf
> dir /home/nfscache
mkdir /home/nfscache
chmod u+rwx /home/nfscache
chmod go-w /home/nfscache
```

```
# Убедиться что в настройках Grub стоит правильная система по-умолчанию
- https://possiblelossofprecision.net/?p=1334
grep ^menuentry /boot/grub/grub.cfg | cut -d "'" -f2
nano /etc/default/grub

> #GRUB_HIDDEN_TIMEOUT=0
> ...
> GRUB_DEFAULT="FULL MENU ENTRY NAME"
```

```
# Скопировать /etc/rc.local
rsync -azP -H --progress --numeric-ids rsync://rescue@192.168.1.11/studio_root_debian/etc/rc.local /etc/rc.local

# Старт rc.local после инициализации сети:
# https://askubuntu.com/questions/882123/rc-local-only-executing-after-connecting-to-ethernet
# https://unix.stackexchange.com/questions/126009/cause-a-script-to-execute-after-networking-has-started
cp /lib/systemd/system/rc-local.service /etc/systemd/system/
nano /etc/systemd/system/rc-local.service
> After=network-online.target
> Wants=network-online.target

touch /etc/rc.local
chmod +x /etc/rc.local
nano /etc/rc.local
```

/etc/rc.local:

```
#!/bin/bash

# NFS Cache
if [ ! -d /home/nfscache ]; then
mkdir /home/nfscache
chmod u+rwx /home/nfscache
chmod go-w /home/nfscache
fi

if [ -e /home/etc/rc.local ]; then
bash /home/etc/rc.local
fi

exit 0
```


## Набор программ


```
apt-get install audacity bindfs cachefilesd calf-plugins \
caja-actions caja-rename cmake \
dconf-editor digikam docker docker.io \
ecryptfs-utils exfat-fuse exfat-utils  filelight fileschanged ffmpeg flac formiko \
gamin gimp git git-gui git-lfs gitk geany gnome-disk-utility  gparted \
homebank hyphen-ru hunspell-ru inkscape jackd2 jekyll \
kde-config-gtk-style kde-l10n-ru key-mon kphotoalbum krdc  \
libreoffice libreoffice-l10n-ru mpg123 nemiver nfs-common openssh-server \
pavucontrol php7.2-cli pidgin printer-driver-foo2zjs python3-setuptools revelation \
mesa-utils owncloud-client \
samba-client shutter smartmontools smplayer sox stow travis \
ufw unison-gtk unrar vorbis-tools vlc wakeonlan wine-stable wine32 wodim xterm


+++++++++++++++++++++++++++++++++++++++++++++++++
+++++++++++++++++++++++++++++++++++++++++++++++++
+++++++++++++++++++++++++++++++++++++++++++++++++
dolphin kio-extras qt5ct ark
kde-plasma-desktop
ntfs-3g cheese davfs2 hplip-gui
+++++++++++++++++++++++++++++++++++++++++++++++++
+++++++++++++++++++++++++++++++++++++++++++++++++
+++++++++++++++++++++++++++++++++++++++++++++++++

# Mint 18.04: gstreamer-plugins-bad crash Caja
apt-get remove gstreamer1.0-plugins-bad

# Docker-compose
# see latest release number at https://github.com/docker/compose/releases
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# VirtualBox
# https://www.virtualbox.org/wiki/Linux_Downloads
https://download.virtualbox.org/virtualbox/6.1.18/virtualbox-6.1_6.1.18-142142~Ubuntu~bionic_amd64.deb
https://download.virtualbox.org/virtualbox/6.1.18/Oracle_VM_VirtualBox_Extension_Pack-6.1.18.vbox-extpack

# IPhone support
apt install ideviceinstaller python-imobiledevice libimobiledevice-utils python-plist ifuse

# Aegisub
add-apt-repository ppa:alex-p/aegisub
apt-get update
apt-get install aegisub

# Nextcloud
sudo add-apt-repository ppa:nextcloud-devs/client
sudo apt-get update
apt install nextcloud-desktop

# OBS
sudo add-apt-repository ppa:obsproject/obs-studio
sudo apt-get update
sudo apt install obs-studio

# Mypaint
apt-get install g++ python-dev libglib2.0-dev python-numpy python-gtk2-dev swig scons gettext liblcms2-dev libjson-c-dev 
cp /usr/lib/x86_64-linux-gnu/pkgconfig/json-c.pc /usr/lib/x86_64-linux-gnu/pkgconfig/json.pc

# AzPainter
add-apt-repository ppa:alex-p/azpainter
apt-get update
apt-get install azpainter

# Shutter: Enable Edit option
https://gist.github.com/linuxkathirvel/bbc7f85b97583525fbd14afd21bfaa8c
wget -q http://mirrors.kernel.org/ubuntu/pool/universe/g/goocanvas/libgoocanvas-common_1.0.0-1_all.deb
wget -q http://mirrors.kernel.org/ubuntu/pool/universe/g/goocanvas/libgoocanvas3_1.0.0-1_amd64.deb
wget -q http://launchpadlibrarian.net/330848267/libgoo-canvas-perl_0.06-2ubuntu3_amd64.deb
sudo dpkg -i libgoocanvas-common_1.0.0-1_all.deb ; sudo apt-get -f install ; sudo dpkg -i libgoocanvas3_1.0.0-1_amd64.deb ; sudo apt-get -f install; sudo dpkg -i libgoo-canvas-perl_0.06-2ubuntu3_amd64.deb ; sudo apt-get -f install

# Peek (gif recorder)
sudo add-apt-repository ppa:peek-developers/stable
sudo apt update
sudo apt install peek

#Digimend Tablet drivers (v10)
# https://github.com/DIGImend/digimend-kernel-drivers/releases
cd /tmp
wget https://github.com/DIGImend/digimend-kernel-drivers/releases/download/v10/digimend-dkms_10_all.deb
dpkg -i digimend-dkms_10_all.deb

# Linux Wacom driver requirements
apt-get install linux-headers-$(uname -r) build-essential autoconf pkg-config make xutils-dev libtool xserver-xorg-dev libx11-dev libxi-dev libxrandr-dev libxinerama-dev libudev-dev
cd /root
wget https://github.com/linuxwacom/input-wacom/releases/download/input-wacom-0.48.0/input-wacom-0.48.0.tar.bz2
tar xf input-wacom-0.48.0.tar.bz2
rm input-wacom-0.48.0.tar.bz2
cd input-wacom-0.48.0
if test -x ./autogen.sh; then ./autogen.sh; else ./configure; fi && make && sudo make install || echo "Build Failed"

# git-lfs
apt-get install git-lfs
https://git-lfs.github.com/

# 0install
curl -O https://get.0install.net/0install.sh && chmod +x 0install.sh
sudo ./0install.sh install local

#Ansible
http://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

# CGRU Afanasy
http://cgru.info/downloads
install_cgru.sh
install_afserver.sh #Server
sudo update-rc.d -f afrender remove
sudo update-rc.d -f afserver remove
echo morevna > /opt/cgru/afanasy/nonrootuser
sed -i 's/export BLENDER_LOCATION=.\+/export BLENDER_LOCATION="\/tools\/bin\/"/' /opt/cgru/software_setup/setup_blender.sh

nano /opt/cgru/config.json
===========================
{"cgru_config":{
	"af_servername":"192.168.1.11",

"":"Render:",

	"af_render_zombietime":60,
		"":"If render will not send update its resources for this time(seconds),",
		"":"server will put it in 'OFFLINE' state.",

	"af_render_exit_no_task_time":-1,
		"":"Program will exit if there will be no tasks for this time(seconds),",
		"":"Negative value disables this feature",

	"af_task_update_timeout":30,
		"":"If task progress (state or percentage) has not been updated for this period,",
		"":"It wiil considered as an error, and render will be push in error hosts list.",

	"af_task_stop_timeout":30,
		"":"If render was asked to stop a task, but it did not send task finish message,",
		"":"it wiil be considered as not running any way.",

	"af_task_progress_change_timeout":-1,
		"":"If task progress did not change within this time, consider that it is erroneous.",
		"":"A value of -1 will disable this feature.",

	"":""
}}
===========================

/etc/init.d/afrender restart
/etc/init.d/afserver restart #Server

# Wacom GUI
https://github.com/tb2097/wacom-gui

#TurboVNC
https://turbovnc.org/

#Chrome
https://www.google.ru/intl/ru/chrome/

#Zoom
https://zoom.us/download#client_4meeting

#Discord
https://discord.com/

#KitScenarist
https://kitscenarist.ru/download.html

#Opera
https://www.opera.com/

# AverMedia driver - https://www.qsl.net/ew1ln/cx231xx.html
nano /etc/udev/rules.d/usb_ezmaker.rules

=================================
# load cx231xx for DVD EZMaker7

SUBSYSTEMS=="usb", ATTRS{idVendor}=="07ca", ATTRS{idProduct}=="c039", RUN+="/sbin/modprobe cx231xx" ,\
RUN+="/bin/sh -c 'echo 07ca c039 0 1f4d 0102 > /sys/bus/usb/drivers/cx231xx/new_id'"

# and unload after remove (in console, without X)

ACTION=="remove", SUBSYSTEMS=="usb", ATTRS{idVendor}=="07ca", ATTRS{idProduct}=="c039", \
RUN+="/sbin/rmmod cx231xx_alsa", RUN+="/sbin/rmmod cx231xx", \
RUN+="/bin/sh -c 'echo 07ca c039 > /sys/bus/usb/drivers/cx231xx/remove_id'"
=================================


```

## Файлы настроек

- /home/etc/hostname - host name
- /home/etc/rc.local - специфичные настройки
- /home/etc/nfs - определяет нужно ли монтировать nfs при загрузке




## Подготовка рабочего места

```
mkdir /home/etc
chown root /home/etc
chmod 700 /home/etc/
echo "studio-3" > /home/etc/hostname
```

Если NFS (начало)

- Назначить IP для компьютера в DSL-роутере
- Добавить IP-адрес в /home/konstantin/0-work/tools/ansible/hosts

Если NFS (конец)


## Скрипт клонирования ОС

Список игнорирования
- /root/.ecryptfs
- /home/
