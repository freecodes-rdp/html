#!/bin/bash

# Fix permissions
sudo chown -R $USER:$USER "$HOME"

# Install packages
sudo apt update -y
sudo apt install -y tigervnc-standalone-server openbox neofetch kitty nemo software-properties-common

# Firefox PPA
sudo add-apt-repository -y ppa:mozillateam/ppa
echo -e "Package: firefox*\nPin: release o=LP-PPA-mozillateam\nPin-Priority: 1001" | sudo tee /etc/apt/preferences.d/mozillateamppa

sudo apt update -y
sudo apt install -y firefox

# Openbox config
mkdir -p ~/.config/openbox
echo 'kitty --hold -e bash $HOME/html/web &' >> ~/.config/openbox/autostart

# VNC setup
mkdir -p ~/.vnc
printf "1\n1\n" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

cat > ~/.vnc/xstartup << 'EOF'
#!/bin/sh
exec openbox-session
EOF

chmod +x ~/.vnc/xstartup

# Start VNC
vncserver :1

# Bashrc entries
echo '~/html/run' >> ~/.bashrc
echo '~/html/online' >> ~/.bashrc

# noVNC install
cd ~
git clone https://github.com/novnc/noVNC.git
cd noVNC

./utils/novnc_proxy --vnc 127.0.0.1:5901 --listen localhost:8080