#!/bin/bash

echo -e "\033[0;35m"
echo " ██████╗ ███████╗███╗   ██╗███████╗███╗   ██╗ ██████╗ ██████╗ ███████╗███████╗";
echo "██╔════╝ ██╔════╝████╗  ██║╚══███╔╝████╗  ██║██╔═══██╗██╔══██╗██╔════╝██╔════╝";
echo "██║  ███╗█████╗  ██╔██╗ ██║  ███╔╝ ██╔██╗ ██║██║   ██║██║  ██║█████╗  ███████╗";
echo "██║   ██║██╔══╝  ██║╚██╗██║ ███╔╝  ██║╚██╗██║██║   ██║██║  ██║██╔══╝  ╚════██║";
echo "╚██████╔╝███████╗██║ ╚████║███████╗██║ ╚████║╚██████╔╝██████╔╝███████╗███████║";
echo " ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚══════╝╚══════╝";
echo -e "\e[0m"  

sleep 4 

echo -e "\e[1m\e[32mUpdating and install packages... \e[0m" && sleep 1

# update
sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32mInstalling dependencies... \e[0m" && sleep 1

apt install git libssl-dev clang cmake make curl automake autoconf libncurses5-dev gcc g++ erlang elixir

echo -e "\e[1m\e[32mInstalling docker... \e[0m" && sleep 1

sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update && sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin && sudo apt install docker-compose

# download image

echo -e "\e[1m\e[32mDownload image... \e[0m" && sleep 1

docker pull thepowerio/tpnode

echo "===================================================" && sleep 1

# run node

docker run -d -p 44000:44000 --name testnet thepowerio/tpnode

echo "=======================DONE============================"
