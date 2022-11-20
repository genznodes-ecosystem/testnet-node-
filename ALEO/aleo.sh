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

apt install build-essential git libssl-dev clang cmake make curl screen llvm pkg-config xz-utils tmux -y

echo -e "\e[1m\e[32mInstalling rust... \e[0m" && sleep 1

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env

echo -e "\e[1m\e[32mClone repo and install snarkOS... \e[0m" && sleep 1

git clone https://github.com/AleoHQ/snarkOS.git --depth 1
cd snarkOS
cargo install path .

echo -e "\e[1m\e[32mSucces... \e[0m" && sleep 1