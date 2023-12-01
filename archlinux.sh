sudo pacman -S fuse-overlayfs --noconfirm
sudo touch /etc/sysctl.conf
sudo sh -c 'echo "kernel.unprivileged_userns_clone=1" >> /etc/sysctl.conf'
sudo sysctl --system
sudo systemctl disable --now docker.service docker.socket
curl -fsSL https://get.docker.com/rootless | SKIP_IPTABLES=1 sh
[ -f ~/.zshrc ] && echo 'export PATH=/home/enrell/bin:$PATH' >> ~/.zshrc
[ -f ~/.bashrc ] && echo 'export PATH=/home/enrell/bin:$PATH' >> ~/.bashrc
[ -f ~/.zshrc ] && echo "export DOCKER_HOST=unix:///run/user/1000/docker.sock" >> ~/.zshrc
[ -f ~/.bashrc ] && echo "export DOCKER_HOST=unix:///run/user/1000/docker.sock" >> ~/.bashrc
