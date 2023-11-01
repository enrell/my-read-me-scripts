#!/bin/bash

# Update source list
sudo cp /etc/apt/sources.list /etc/apt/source.list.bak

wget https://raw.githubusercontent.com/GLUA-UA/UbuntuMirrorsScript/master/glua_mirrors_ubuntu.sh
sudo bash glua_mirrors_ubuntu.sh
sudo apt-get update

# Install Docker and Docker Compose

curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

echo "Downloading rootless-install.sh..."
wget https://raw.githubusercontent.com/docker/docker-install/master/rootless-install.sh
chmod +x rootless-install.sh

# Run the rootless-install.sh script and capture the exit status
echo "Running rootless-install.sh..."
./rootless-install.sh

# Check the exit status of the rootless-install.sh script
if [ $? -eq 0 ]; then
    echo "rootless-install.sh successful. Enabling and starting Docker service..."
    systemctl --user enable docker.service --now

    if [ $? -eq 0 ]; then
        echo "Docker service enabled successfully. Adding environment variables to .bashrc..."

        # Adiciona as variáveis de ambiente ao final do arquivo .bashrc
        echo "export PATH=/home/enrell/bin:\$PATH" >> ~/.bashrc
        echo "export DOCKER_HOST=unix:///run/user/1000/docker.sock" >> ~/.bashrc

        echo "Environment variables added to .bashrc."
    else
        echo "Failed to enable Docker service. Environment variables not added to .bashrc."
    fi
else
    # If it returns an error, install uidmap and try to activate ip_tables
    echo "Installing uidmap..."
    sudo apt-get install -y uidmap

    if [ $? -eq 0 ]; then
        echo "uidmap installed. Trying to activate ip_tables..."
        sudo modprobe ip_tables

        if [ $? -ne 0 ]; then
            echo "Error: Unable to activate ip_tables. Your environment may not support this operation."
            echo "Consider using SKIP_IPTABLES=1 ./rootless-install.sh"
        else
            # Tenta executar o rootless-install.sh novamente
            echo "Trying to run rootless-install.sh again..."
            ./rootless-install.sh

            # Verifica se a segunda execução do rootless-install.sh foi bem-sucedida
            if [ $? -eq 0 ]; then
                echo "rootless-install.sh successful. Enabling and starting Docker service..."
                systemctl --user enable docker.service --now

                if [ $? -eq 0 ]; then
                    echo "Docker service enabled successfully. Adding environment variables to .bashrc..."

                    # Adiciona as variáveis de ambiente ao final do arquivo .bashrc
                    echo "export PATH=/home/enrell/bin:\$PATH" >> ~/.bashrc
                    echo "export DOCKER_HOST=unix:///run/user/1000/docker.sock" >> ~/.bashrc

                    echo "Environment variables added to .bashrc."
                else
                    echo "Failed to enable Docker service. Environment variables not added to .bashrc."
                fi
            else
                echo "rootless-install.sh failed. Docker service not enabled."
            fi
        fi
    else
        echo "Error: Failed to install uidmap. Check your network and try again."
    fi
fi

