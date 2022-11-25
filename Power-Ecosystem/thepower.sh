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

sudo apt update && sudo apt upgrade -y

echo -e "\e[1m\e[32minstall erlang and update dependencies... \e[0m" && sleep 2

apt install cmake clang gcc git curl libssl-dev build-essential automake autoconf libncurses5-dev elixir erlang erlang-base erlang-public-key erlang-ssl -y

echo -e "\e[1m\e[32mDownload and build the node... \e[0m" && sleep 1
# Build node v0.13.14
cd $HOME
rm -rf tpnode
git clone https://github.com/thepower/tpnode.git -b e24
cd tpnode
git checkout v0.13.14
./rebar3 get-deps
./rebar3 compile
./rebar3 release
cp -r _build/default/rel/thepower /opt

echo -e "\e[1m\e[32mcreate service file... \e[0m" && sleep 1
sudo tee /etc/systemd/system/powerd.service > /dev/null <<EOF
[Unit]
Description=powerd
After=network.target
[Service]
Type=simple
User=root
Group=root
ExecStart=/opt/thepower/bin/thepower foreground
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable powerd.service

echo -e "\e[1m\e[32m============DONE==============... \e[0m" && sleep 1
