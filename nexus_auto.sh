#!/bin/bash

echo "✅ Installing Docker..."
wget --no-cache -q -O docker_main.sh https://raw.githubusercontent.com/noxuspace/cryptofortochka/main/docker/docker_main.sh
chmod +x docker_main.sh
./docker_main.sh

echo "✅ Downloading Nexus..."
docker pull nexusxyz/nexus-cli:latest

echo "✅ Installing Screen and other dependencies..."
apt update
apt install -y screen

echo "✅ Creating swap file (16 GB)..."
dd if=/dev/zero of=/swapfile bs=1M count=16384
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab

echo "✅ Setup completed."
echo "⚠️ Please enter your unique Node ID:"
read NODE_ID

echo "✅ Removing previous container (if exists)..."
docker stop nexus 2>/dev/null
docker rm nexus 2>/dev/null

echo "✅ Starting Nexus node with auto-restart..."
docker run -d --restart unless-stopped --name nexus nexusxyz/nexus-cli:latest start --node-id $NODE_ID

echo "🎉 All done! Your node is running in background."

echo "🔧 Useful commands:"
echo "Check running container: docker ps"
echo "View node logs: docker logs -f nexus"
echo "Stop node: docker stop nexus"
echo "Start node again: docker start nexus"
