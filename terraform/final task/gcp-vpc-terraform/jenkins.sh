#!/bin/bash
sudo apt-get update
#sudo apt-get install -y\
#    apt-transport-https \
#    ca-certificates \
#   curl \
#    gnupg-agent \
#    software-properties-common
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository 
#   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
#   $(lsb_release -cs) \
#   stable"
sudo apt-get update
#sudo apt-get install -y docker-ce docker-ce-cli containerd.io
#sudo apt install mc -y
#sudo usermod -aG docker agcossack
sudo apt install openjdk-8-jdk -y
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt install jenkins -y
