#!/bin/bash

# Update source list
sudo cp /etc/apt/sources.list /etc/apt/source.list.bak

wget https://raw.githubusercontent.com/GLUA-UA/UbuntuMirrorsScript/master/glua_mirrors_ubuntu.sh
sudo bash glua_mirrors_ubuntu.sh
sudo apt-get update

# Install docker and docker compose

curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

echo "Download rootless-install.sh..."
wget https://raw.githubusercontent.com/docker/docker-install/master/rootless-install.sh
chmod +x rootless-install.sh

# Executa o script rootless-install.sh e captura o status de saída
echo "Executando o script rootless-install.sh..."
./rootless-install.sh

# Verifica o status de saída do script rootless-install.sh
if [ $? -ne 0 ]; then
    # Em caso de erro, instala uidmap e tenta ativar o módulo ip_tables
    echo "Installing..."
    SKIP_IPTABLES=1 ./rootless-install.sh

    if [ $? -ne 0 ]; then
        echo "Error: SKIP_IPTABLES=1 ./rootless-install.sh"
    fi
fi

