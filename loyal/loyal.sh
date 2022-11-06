#!/bin/bash


echo "=================================================="
echo -e "\033[0;34m"
echo " ██████╗ ███████╗███╗   ██╗███████╗███╗   ██╗ ██████╗ ██████╗ ███████╗███████╗";
echo "██╔════╝ ██╔════╝████╗  ██║╚══███╔╝████╗  ██║██╔═══██╗██╔══██╗██╔════╝██╔════╝";
echo "██║  ███╗█████╗  ██╔██╗ ██║  ███╔╝ ██╔██╗ ██║██║   ██║██║  ██║█████╗  ███████╗";
echo "██║   ██║██╔══╝  ██║╚██╗██║ ███╔╝  ██║╚██╗██║██║   ██║██║  ██║██╔══╝  ╚════██║";
echo "╚██████╔╝███████╗██║ ╚████║███████╗██║ ╚████║╚██████╔╝██████╔╝███████╗███████║";
echo " ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚══════╝╚══════╝";
echo -e "\e[0m"    
echo "=================================================="


sleep 3

if [ ! $NODENAME ]; then
	  read -p "Name your node: " NODENAME
	  echo 'export NODENAME='$NODENAME >> $HOME/.bash_profile
fi

echo -e "Nama Node: \e[1m\e[32m$NODENAME\e[0m"
echo -e "Chain ID: \e[1m\e[32mloyal-1\e[0m"
echo '================================================='

sleep 2


# Update Dependencies
echo -e "\e[1m\e[32m1. UPDATE BANG !!!... \e[0m" && sleep 1
sudo apt update && sudo apt upgrade -y


# Install 
echo -e "\e[1m\e[32m2. INSTALL ALAT-ALAT... \e[0m" && sleep 1
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y

# INSTALL GO

ver="1.19.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version

sleep 1

# BUILD 

echo -e "\e[1m\e[32m CLONE... \e[0m" && sleep 1
cd $HOME
wget https://github.com/LoyalLabs/loyal/releases/download/v0.25.1/loyal_v0.25.1_linux_amd64.tar.gz
tar xzf loyal_v0.25.1_linux_amd64.tar.gz
chmod 775 loyald
sudo mv loyald /usr/local/bin/
sudo rm loyal_v0.25.1_linux_amd64.tar.gz

sleep 1

# Config app
echo -e "\e[1m\e[32m CONFIG APP... \e[0m" && sleep 1
loyald config chain-id loyal-1
loyald config keyring-backend file
loyald init $NODENAME --chain-id loyal-1

# Download addrbook & genesis
wget https://raw.githubusercontent.com/LoyalLabs/net/main/mainnet/genesis.json -O $HOME/.loyal/config/genesis.json
wget $LYL_ADDRBOOK -O $HOME/.loyal/config/addrbook.json

# Seeds peers
SEEDS="7490c272d1c9db40b7b9b61b0df3bb4365cb63a6@loyal-seed.netdots.net:26656,b66ecdf36bb19a9af0460b3ae0901aece93ae006@pubnode1.joinloyal.io:26656"
PEERS=""
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.loyal/config/config.toml

sleep 1


# config pruning

pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.loyal/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.loyal/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.loyal/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.loyal/config/app.toml


# Enable prometheus
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.loyal/config/config.toml

# Set gas price
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.000025ulyl\"/" $HOME/.loyal/config/app.toml

# index

indexer="null" && \
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.loyal/config/config.toml

# Reset blockchain history
loyald tendermint unsafe-reset-all --home $HOME/.loyal

echo -e "\e[1m\e[32m CREATE SERVICE FILE... \e[0m" && sleep 1
# create service
sudo tee /etc/systemd/system/loyald.service > /dev/null <<EOF
[Unit]
Description=loyald
After=network.target
[Service]
Type=simple
User=root
ExecStart=$(which loyald) start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF


# Enable and start

sudo systemctl daemon-reload
sudo systemctl enable loyald
sudo systemctl restart loyald

echo '=============== !!!! ==================='
echo -e 'Check logs: \e[1m\e[32mjournalctl -fu loyald -o cat\e[0m'
echo -e "Check sync info: \e[1m\e[32mcurl -s localhost:26656/status | jq .result.sync_info\e[0m"

source $HOME/.bash_profile
