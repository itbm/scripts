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

# Update & Install
apt update
apt upgrade -y
apt install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common -y

# Install Docker
apt remove docker docker-engine docker.io
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   ${release} \
   stable"
apt update
apt install docker-ce docker-compose -y

# Install Node
curl -sL https://deb.nodesource.com/setup_11.x | bash -
apt install nodejs -y

# Install MySQL Workbench & pgAdmin3
apt install mysql-workbench pgadmin3 -y 

# Install Pidgin & Evolution
apt install pidgin pidgin-sipe evolution evolution-ews -y

# Install Tools
apt install vim dos2unix git git-svn composer s3cmd curl wget -y

# Install Virtualbox, Chromium, Remmina & GIMP
apt install virtualbox virtualbox-ext-pack chromium-browser remmina gimp -y

# Install PHP Extensions
apt install php-mbstring php-dom php-pdo-sqlite sqlite3 -y

# Install Snaps
apt install snapd -y
snap install onlyoffice-desktopeditors
snap install phpstorm --classic
snap install webstorm --classic
snap install datagrip --classic
snap install pycharm-professional --classic
snap install sublime-text --classic
snap install github-desktop --edge
snap install sftpclient
snap install vscode --classic
snap install powershell --classic
snap install altair
snap install aws-cli --classic

# Install Postman
apt install libgconf-2-4 -y
wget https://dl.pstmn.io/download/latest/linux64 -O postman.tar.gz
tar -xzf postman.tar.gz -C /opt
rm postman.tar.gz
ln -s /opt/Postman/Postman /usr/bin/postman
wget https://www.getpostman.com/img/v2/logo-glyph.png -O /opt/Postman/postman.png
cat <<EOT >> /usr/share/applications/postman.desktop
[Desktop Entry]
Type=Application
Name=Postman
Icon=/opt/Postman/postman.png
Path=/opt/Postman
Exec="/opt/Postman/Postman"
StartupNotify=false
StartupWMClass=Postman
OnlyShowIn=Unity;GNOME;
X-UnityGenerated=true
EOT

# Install Insomnia REST Client
echo "deb https://dl.bintray.com/getinsomnia/Insomnia /" | tee -a /etc/apt/sources.list.d/insomnia.list
wget --quiet -O - https://insomnia.rest/keys/debian-public.key.asc | apt-key add -
apt update
apt install insomnia -y

# Install doctl
curl -sL https://github.com/digitalocean/doctl/releases/download/v1.14.0/doctl-1.14.0-linux-amd64.tar.gz | tar -xzv
mv ~/doctl /usr/local/bin

# Install Kubectl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
apt update
apt install -y kubectl

# Install helm
curl -sL https://storage.googleapis.com/kubernetes-helm/helm-v2.13.1-linux-amd64.tar.gz | tar -xzv
mv ~/helm /usr/local/bin

# Install Spotify
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90
echo deb http://repository.spotify.com stable non-free | tee /etc/apt/sources.list.d/spotify.list
apt update
apt install spotify-client -y

# Install GitKraken
curl -L https://release.gitkraken.com/linux/gitkraken-amd64.deb -o ~/gitkraken.deb \
	&& apt install ~/gitkraken.deb -y \
	&& rm ~/gitkraken.deb

# Install Wavebox
wget -qO - https://wavebox.io/dl/client/repo/archive.key | apt-key add -
echo "deb https://wavebox.io/dl/client/repo/ x86_64/" | tee --append /etc/apt/sources.list.d/wavebox.list
apt update
apt install wavebox ttf-mscorefonts-installer -y

# Install TeamViewer
curl -L https://download.teamviewer.com/download/linux/teamviewer_amd64.deb -o ~/teamviewer_amd64.deb \
	&& apt install ~/teamviewer_amd64.deb -y \
	&& rm ~/teamviewer_amd64.deb 

# Install Tresorit
curl -L https://installerstorage.blob.core.windows.net/public/install/tresorit_installer.run -o ~/tresorit_installer.run \
	&& sh ./tresorit_installer.run \
	&& rm ~/tresorit_installer.run

# Install Etcher
curl -L https://github.com/balena-io/etcher/releases/download/v1.5.18/balena-etcher-electron_1.5.18_amd64.deb -o ~/etcher.deb \
	&& apt install ~/etcher.deb -y \
	&& rm ~/etcher.deb

# Install ExpressVPN
curl -L https://download.expressvpn.xyz/clients/linux/expressvpn_2.0.0-1_amd64.deb -o ~/expressvpn.deb \
	&& apt install ~/expressvpn.deb -y \
	&& rm ~/expressvpn.deb

# Install CircleCI
curl -fLSs https://circle.ci/cli | sudo bash

# Install ZeroTier
curl -s 'https://pgp.mit.edu/pks/lookup?op=get&search=0x1657198823E52A61' | gpg --import && \
if z=$(curl -s 'https://install.zerotier.com/' | gpg); then echo "$z" | bash; fi

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
	apt install network-manager-openvpn-gnome strongswan network-manager-strongswan libstrongswan-extra-plugins network-manager-l2tp network-manager-l2tp-gnome network-manager-ssh network-manager-ssh-gnome -y
	if [ "$razer" = "y" ]; then
		gsettings set org.gnome.desktop.background picture-uri file:///${HOME}/Pictures/Graphite-1920x1080.png
	fi
	gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
	gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 24
	gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'powershell_powershell.desktop', 'chromium-browser.desktop', 'org.gnome.Evolution.desktop', 'virtualbox.desktop', 'vscode_vscode.desktop', 'phpstorm_phpstorm.desktop', 'webstorm_webstorm.desktop', 'pycharm-professional_pycharm-professional.desktop', 'datagrip_datagrip.desktop', 'mysql-workbench.desktop', 'pgadmin3.desktop', 'sublime-text_subl.desktop', 'sftpclient_sftpclient.desktop', 'gitkraken.desktop', 'github-desktop_github-desktop.desktop', 'postman.desktop', 'insomnia.desktop', 'altair_altair.desktop', 'org.remmina.Remmina.desktop', 'pidgin.desktop', 'spotify.desktop', 'onlyoffice-desktopeditors_onlyoffice-desktopeditors.desktop', 'balena-etcher-electron.desktop', 'org.gnome.Screenshot.desktop', 'wavebox.desktop']"
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
echo "* After reboot run 'expressvpn activate'"
echo "*****************************************************";
echo " "

read -p "Do you want to reboot now? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
	then
		reboot
	fi
