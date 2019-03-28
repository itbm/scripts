#!/bin/bash
## sudo bash ./setup.sh

customisations=none;
razer=n;
ath10k=n;
release=bionic;

echo "*****************************************************";
echo "*";
echo -n "* Which release is this based on? (cosmic/bionic/xenial/zesty/trusty):";
read release;
echo -n "* Would you like to run customisations? (gnome/cinnamon/none):";
read customisations;
echo -n "* Is this a razer laptop? (y/n):";
read razer;
echo -n "* Do you want to install the new ath10k firmware? (y/n):";
read ath10k;
echo "*";
echo "*****************************************************";
echo "";

apt update
apt upgrade -y

apt remove docker docker-engine docker.io
apt install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   ${release} \
   stable"

apt update
apt install docker-ce docker-compose -y

curl -sL https://deb.nodesource.com/setup_11.x | -E bash -
apt install nodejs npm -y

apt install snapd mysql-workbench pgadmin3 pidgin pidgin-sipe evolution evolution-ews \
	vim dos2unix git git-svn composer s3cmd curl wget virtualbox virtualbox-ext-pack chromium-browser remmina -y

apt install php-mbstring php-dom php-pdo-sqlite sqlite3 -y

snap install onlyoffice-desktopeditors
snap install phpstorm --classic
snap install webstorm --classic
snap install datagrip --classic
snap install pycharm-professional --classic
snap install sublime-text --classic
snap install gitkraken --beta
snap install github-desktop --edge
snap install sftpclient
snap install postman
snap install insomnia
snap install spotify
snap install vscode --classic
snap install gimp

snap install chromium

curl -L https://download.teamviewer.com/download/linux/teamviewer_amd64.deb -o ~/teamviewer_amd64.deb \
	&& apt install ~/teamviewer_amd64.deb -y \
	&& rm ~/teamviewer_amd64.deb 

curl -L https://installerstorage.blob.core.windows.net/public/install/tresorit_installer.run -o ~/tresorit_installer.run \
	&& sh ./tresorit_installer.run \
	&& rm ~/tresorit_installer.run

curl -L https://github.com/balena-io/etcher/releases/download/v1.5.18/balena-etcher-electron_1.5.18_amd64.deb -o ~/etcher.deb \
	&& apt install ~/etcher.deb -y \
	&& rm ~/etcher.deb

snap install kubectl --classic
snap install doctl --classic
snap install aws-cli --classic

curl -fLSs https://circle.ci/cli | sudo bash

echo " "
echo "*****************************************************";

echo "* Setting inotify max_user_watches ...."
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf; sudo sysctl -p

if [ "$razer" = "y" ]; then
	echo "* Installing openrazer and polychromatic ....";
	add-apt-repository ppa:openrazer/stable -y
	add-apt-repository ppa:polychromatic/stable -y
	apt update
	apt install openrazer-meta -y
	apt install polychromatic -y

	echo "* Downloading razer wallpaper ....";
	wget https://assets.razerzone.com/eedownloads/desktop-wallpapers/Prism_1920x1080.png -P ~/Pictures
	wget https://assets.razerzone.com/eedownloads/desktop-wallpapers/Leviathan-1920x1080.png -P ~/Pictures
	wget https://assets.razerzone.com/eedownloads/desktop-wallpapers/Graphite-1920x1080.png -P ~/Pictures
	wget https://assets.razerzone.com/eedownloads/desktop-wallpapers/Wave-1920x1080.png -P ~/Pictures
	wget https://assets.razerzone.com/eedownloads/desktop-wallpapers/razer_hud_1920x1080.png -P ~/Pictures
	wget https://assets.razerzone.com/eedownloads/desktop-wallpapers/Forged-1920x1080.png -P ~/Pictures
fi

if [ "$ath10k" = "y" ]; then
	mkdir -p  /lib/firmware/ath10k/QCA6174/hw3.0
	mv /lib/firmware/ath10k/QCA6174/hw3.0/board-2.bin /lib/firmware/ath10k/QCA6174/hw3.0/board-2.bin.bak
	mv /lib/firmware/ath10k/QCA6174/hw3.0/firmware-6.bin /lib/firmware/ath10k/QCA6174/hw3.0/firmware-6.bin.bak
	curl https://github.com/kvalo/ath10k-firmware/blob/master/QCA6174/hw3.0/board-2.bin?raw=true > /lib/firmware/ath10k/QCA6174/hw3.0/board-2.bin
	curl https://github.com/kvalo/ath10k-firmware/blob/master/QCA6174/hw3.0/4.4.1/firmware-6.bin_WLAN.RM.4.4.1-00065-QCARMSWP-1?raw=true > /lib/firmware/ath10k/QCA6174/hw3.0/firmware-6.bin
fi

if [ "$customisations" = "gnome" ]; then
	echo "* Running gnome customisations ....";
	apt install gnome-shell-extensions
	if [ "$razer" = "y" ]; then
		gsettings set org.gnome.desktop.background picture-uri file:///${HOME}/Pictures/Graphite-1920x1080.png
	fi
	gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
	gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 24
	gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'chromium_chromium.desktop', 'org.gnome.Evolution.desktop', 'virtualbox.desktop', 'vscode_vscode.desktop', 'phpstorm_phpstorm.desktop', 'webstorm_webstorm.desktop', 'pycharm-professional_pycharm-professional.desktop', 'datagrip_datagrip.desktop', 'mysql-workbench.desktop', 'pgadmin3.desktop', 'sublime-text_subl.desktop', 'sftpclient_sftpclient.desktop', 'gitkraken_gitkraken.desktop', 'github-desktop_github-desktop.desktop', 'postman_postman.desktop', 'insomnia_insomnia.desktop', 'remmina_remmina.desktop', 'pidgin.desktop', 'spotify_spotify.desktop', 'onlyoffice-desktopeditors_onlyoffice-desktopeditors.desktop']"
fi

if [ "$customisations" = "cinnamon" ]; then
	echo "* Running cinnamon customisations ....";
	cp -f cinnamon/menu.json ~/.cinnamon/configs/menu@cinnamon.org/1.json
	cp -f cinnamon/panel.json ~/.cinnamon/configs/panel-launchers@cinnamon.org/3.json
fi

echo "*****************************************************";
echo " "

echo " "
echo "*****************************************************";
echo "* You need to reboot to finish setup."
echo "* After reboot run 'sudo groupadd docker && sudo usermod -aG docker <username>'"
echo "*****************************************************";
echo " "

read -p "Do you want to reboot now? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
	then
		reboot
	fi
