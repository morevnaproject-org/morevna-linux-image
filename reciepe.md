
## System Configuration

Base system: Linux Mint 19


```
# disk labels
e2label device STUDIO_ROOT
nano /etc/fstab
> LABEL=STUDIO_ROOT /               ext4    errors=remount-ro 0       1
> LABEL=STUDIO_HOME /home           ext4    defaults        0       2

# Убедиться что в настройках Grub стоит правильная система по-умолчанию
- https://possiblelossofprecision.net/?p=1334
grep ^menuentry /boot/grub2/grub.cfg | cut -d "'" -f2
nano /etc/default/grub
GRUB_DEFAULT="FULL MENU ENTRY NAME"

# Install root ssh keys for Ansible
...


# Настроить NFS-Cache

apt-get install bindfs nfs-common nfs-kernel-server  cachefilesd ecryptfs-utils 
nano /etc/fstab
> 192.168.2.2:/home/data /home/data nfs fsc,noauto 0 0
nano /etc/default/cachefilesd
> RUN=yes
nano /etc/cachefilesd.conf
> dir /home/nfscache
mkdir /home/nfscache
chmod u+rwx /home/nfscache
chmod go-w /home/nfscache

# Скопировать /etc/rc.local
rsync -azP -H --progress --numeric-ids rsync://rescue@192.168.2.2/studio_root_debian/etc/rc.local /etc/rc.local

# Старт rc.local после инициализации сети:
# https://askubuntu.com/questions/882123/rc-local-only-executing-after-connecting-to-ethernet
# https://unix.stackexchange.com/questions/126009/cause-a-script-to-execute-after-networking-has-started
cp /lib/systemd/system/rc-local.service /etc/systemd/system/
nano /etc/systemd/system/rc-local.service
> After=network-online.target
> Wants=network-online.target
systemctl enable NetworkManager-wait-online # on Debian 8


# Пользователи

- morevna - 1111
- anim - 1001

useradd -m -k /etc/skel/ -s /bin/bash -u 1111 morevna
passwd morevna
useradd -m -k /etc/skel/ -s /bin/bash -u 1001 anim
passwd anim

# Скопировать папку /tools
- sudo bash /home/data/sync/tools/mount_dirs.sh
Далее от пользователя "owner":
- bash /home/data/sync/tools/setup.sh
- /usr/bin/unison tools -auto -batch

# Отключить эффекты MATE
# https://sites.google.com/site/easylinuxtipsproject/3#TOC-Turn-off-visual-effects-in-Cinnamon

a. Menu button - Preferences - Windows
Tab General: deselect: Enable software compositing window manager

b. Menu button - Preferences - Desktop settings
Click Windows - section Window Manager: set it to plain Marco (instead of Marco + Compositing).

c. Remove Compiz:
sudo apt-get remove compiz-core

```



## Набор программ

Edit /etc/apt/sources.list, add "contrib" and "non-free" to jessie-backports entry.
```
deb http://debian.mirrors.ovh.net/debian/ jessie-backports main contrib non-free
deb-src http://debian.mirrors.ovh.net/debian/ jessie-backports main contrib non-free
```

```
apt-get install audacity bindfs cachefilesd calf-plugins \
caja-actions caja-rename cmake \
dconf-editor digikam docker docker.io \
ecryptfs-utils exfat-fuse exfat-utils  filelight fileschanged ffmpeg flac formiko \
gamin gimp git git-gui git-lfs gitk geany gnome-disk-utility  gparted \
homebank hyphen-ru hunspell-ru inkscape jackd2 jekyll \
kde-config-gtk-style kde-l10n-ru key-mon kphotoalbum krdc  \
libreoffice libreoffice-l10n-ru mpg123 nemiver nfs-common openssh-server \
pavucontrol php7.2-cli printer-driver-foo2zjs python3-setuptools revelation \
mesa-utils \
shutter smartmontools smplayer sox stow travis \
ufw unison-gtk unrar virtualbox-ext-pack vorbis-tools wakeonlan wine-stable wine32 wodim xterm

+++++++++++++++++++++++++++++++++++++++++++++++++
+++++++++++++++++++++++++++++++++++++++++++++++++
+++++++++++++++++++++++++++++++++++++++++++++++++
dolphin kde-plasma-desktop kio-extras qt5ct
ntfs-3g cheese davfs2
+++++++++++++++++++++++++++++++++++++++++++++++++
+++++++++++++++++++++++++++++++++++++++++++++++++
+++++++++++++++++++++++++++++++++++++++++++++++++

# Debian 8:
gtk2-engines-oxygen gtk3-engines-oxygen  nvidia-detect

# Mint 18.04: gstreamer-plugins-bad crash Caja
apt-get remove gstreamer1.0-plugins-bad

# Docker-compose
# see latest release number at https://github.com/docker/compose/releases
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose


# Iphone
apt install ideviceinstaller python-imobiledevice libimobiledevice-utils python-plist ifuse

# Aegisub
add-apt-repository ppa:alex-p/aegisub
apt-get update
apt-get install aegisub

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


# Linux Wacom driver requirements
apt-get install linux-headers-$(uname -r) build-essential autoconf pkg-config make xutils-dev libtool xserver-xorg-dev libx11-dev libxi-dev libxrandr-dev libxinerama-dev libudev-dev
cd /root
wget https://github.com/linuxwacom/input-wacom/releases/download/input-wacom-0.44.0/input-wacom-0.44.0.tar.bz2
tar xf input-wacom-0.44.0.tar.bz2
rm tar xf input-wacom-0.44.0.tar.bz2
cd input-wacom-0.44.0
if test -x ./autogen.sh; then ./autogen.sh; else ./configure; fi && make && sudo make install || echo "Build Failed"

# git-lfs
apt-get install git-lfs
https://git-lfs.github.com/

#syncthing
curl -s https://syncthing.net/release-key.txt | sudo apt-key add -
echo "deb https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
sudo apt-get update
sudo apt-get install syncthing

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
	"af_servername":"192.168.2.2",

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

#Ubuntu 18.10
ln -sf /usr/lib/x86_64-linux-gnu/libpython3.6m.so.1 /usr/lib/x86_64-linux-gnu/libpython3.5m.so.1
ln -sf /usr/lib/x86_64-linux-gnu/libpython3.6m.so.1.0 /usr/lib/x86_64-linux-gnu/libpython3.5m.so.1.0

/etc/init.d/afrender restart
/etc/init.d/afserver restart #Server

# Wacom GUI
https://github.com/tb2097/wacom-gui

#TurboVNC
https://turbovnc.org/

#Chrome
https://www.google.ru/intl/ru/chrome/

#KitScenarist
https://kitscenarist.ru/download.html

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

- /home/etc/owner - определяет имя пользователя владельца
- /home/etc/hostname - host name
- /home/etc/rc.local - специфичные настройки
- /home/etc/nfs - определяет нужно ли монтировать nfs при загрузке
- /home/etc/windows - должен ли Grub загружать windows по-умолчанию

## Подготовка рабочего места

```
mkdir /home/etc
chown root /home/etc
chmod 700 /home/etc/
echo "konstantin" > /home/etc/owner
echo "studio-3" > /home/etc/hostname
```
Если не NFS (начало):
```
mkdir -p /home/data/sync/
chown -R `head -n 1 /home/etc/owner` /home/data/sync/
```

- Установить имя пользователя и пароль Syncthing - http://127.0.0.1:8384/
- Set default path - /home/data/sync
- Добавить master (и cloud?), поставить опцию автоматичски добавлять новые шары.
- Синхронизировать "tools" в "/home/data/sync/tools"

Если не NFS (конец)



От пользователя owner:

```
- sudo bash /home/data/sync/tools/mount_dirs.sh
- bash /home/data/sync/tools/setup.sh
- /usr/bin/unison-2.40 tools -auto -batch
- sudo -u morevna bash /home/morevna/tools/setup.sh
```

Перелогиниться.

Если NFS (начало)

- Назначить IP для компьютера в DSL-роутере
- Добавить IP-адрес в /home/konstantin/0-work/tools/ansible/hosts

Если NFS (конец)


## Cкрипт запуска системы

- установить имя хоста (хак для Afanasy)
- запустить /tools/mount_links.sh
- запустить syncthing
- запустить /home/etc/rc.local

## Скрипт клонирования

Список игнорирования
- /root/.ecryptfs
- /home/

## Прочие настройки

- /etc/rsyncd.conf.rescue - файл-шаблон для клонирования системы с текущего устройства
- /etc/rsyncd.pass.rescue - пароль к нему

## Миграция
- ~/syncthing/ to /home/data/sync/
- ~/0-work/ to /home/data/work/
- /home/data/work/tools/ to /tools/
- Update Syncthing config paths
- Update Unison paths
- bash /home/data/sync/tools/mount_dirs.sh
- Unison
- Start Syncthing
- Установить имя пользователя и пароль Syncthing - http://127.0.0.1:8384/
- Set default path - /home/data/sync
- Добавить master (и cloud?), поставить опцию автоматичски добавлять новые шары.
