<p style="font-size:14px" align="right">
<a href="https://t.me/genznodes" target="_blank">Join our telegram <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>


<p align="center">
    <img src="https://user-images.githubusercontent.com/94878333/202221381-f685d4eb-0888-4544-a466-823f1898eb50.jpg">
</p>

# How to join Neutron Guide to run Node 

Neutron Testnet quark-1

Attribute	Value
Chain ID	quark-1

Requirements
Hardware
4 Cores
32 GB RAM
2x512 GB SSD

### Download and update dependencies

```
sudo apt update && sudo apt upgrade -y && sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```

### Install Go

```
ver="1.19"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
```

check golang

```
go version
```

### build and install binary

```
git clone -b v0.1.0 https://github.com/neutron-org/neutron.git
cd neutron
make install
```

`neutrond version --long`

>name: neutron
>
>server_name: neutrond
>
>version: 0.1.0
>
>commit: a9e8ba5ebb9230bec97a4f2826d75a4e0e6130d9

### init

```
neutrond inti <moniker> --chain-id quark-1
```

### Create wallet

```
neutrond keys add wallet
```

- or recover with

```
neutrond keys add wallet --recover
```

### Download Genesis

```
curl -s https://raw.githubusercontent.com/neutron-org/testnets/main/quark/genesis.json > ~/.neutrond/config/genesis.json
```

- Genesis sha256

```
sha256sum ~/.neutrond/config/genesis.json
```

>357c4d33fad26c001d086c0705793768ef32c884a6ba4aa73237ab03dd0cc2b4

### Set up gas price and Peers,Seeds,Filter peers and MaxPeers

```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0untrn\"/" $HOME/.neutrond/config/app.toml
sed -i -e "s/^filter_peers *=.*/filter_peers = \"true\"/" $HOME/.neutrond/config/config.toml
external_address=$(wget -qO- eth0.me) 
sed -i.bak -e "s/^external_address *=.*/external_address = \"$external_address:26656\"/" $HOME/.neutrond/config/config.toml
peers="fcde59cbba742b86de260730d54daa60467c91a5@23.109.158.180:26656,5bdc67a5d5219aeda3c743e04fdcd72dcb150ba3@65.109.31.114:2480,3e9656706c94ae8b11596e53656c80cf092abe5d@65.21.250.197:46656,9cb73281f6774e42176905e548c134fc45bbe579@162.55.134.54:26656,27b07238cf2ea76acabd5d84d396d447d72aa01b@65.109.54.15:51656,f10c2cb08f82225a7ef2367709e8ac427d61d1b5@57.128.144.247:26656,20b4f9207cdc9d0310399f848f057621f7251846@222.106.187.13:40006,5019864f233cee00f3a6974d9ccaac65caa83807@162.19.31.150:55256,2144ce0e9e08b2a30c132fbde52101b753df788d@194.163.168.99:26656,b37326e3acd60d4e0ea2e3223d00633605fb4f79@nebula.p2p.org:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.neutrond/config/config.toml
seeds="e2c07e8e6e808fb36cca0fc580e31216772841df@seed-1.quark.ntrn.info:26656,c89b8316f006075ad6ae37349220dd56796b92fa@tenderseed.ccvalidators.com:29001"
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.neutrond/config/config.toml
sed -i -e "s/^timeout_commit *=.*/timeout_commit = \"2s\"/" $HOME/.neutrond/config/config.toml
sed -i 's/max_num_inbound_peers =.*/max_num_inbound_peers = 100/g' $HOME/.neutrond/config/config.toml
sed -i 's/max_num_outbound_peers =.*/max_num_outbound_peers = 100/g' $HOME/.neutrond/config/config.toml
```

### Costum pruning 

```
pruning="custom" && \
pruning_keep_recent="100" && \
pruning_keep_every="0" && \
pruning_interval="10" && \
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" ~/.neutrond/config/app.toml && \
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" ~/.neutrond/config/app.toml && \
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" ~/.neutrond/config/app.toml && \
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" ~/.neutrond/config/app.toml
```

### Download addrbook

```
wget -O $HOME/.neutrond/config/addrbook.json https://raw.githubusercontent.com/Genz22/Testnet-node/main/neutron/addrbook.json
```

### Create service file 

```
sudo tee /etc/systemd/system/neutrond.service > /dev/null <<EOF
[Unit]
Description=neutron
After=network-online.target

[Service]
User=$USER
ExecStart=$(which neutrond) start $HOME/.neutrond
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

- enable service file and start node

```
sudo systemctl daemon-reload
sudo systemctl enable neutrond
sudo systemctl restart neutrond && sudo journalctl -u neutrond -f -o cat
```

- check sync info

```
neutrond status 2>&1 | jq .SyncInfo
```

```
neutrond status |& jq
```

### Create validator 

- faucet 

```
.
```

- create validator

```
neutrond tx staking create-validator \
  --amount 1000000untrn \
  --moniker <moniker> \
  --chain-id quark-1 \
  --identity="" \
  --details="" \
  --website="" \
  --from <wallet> \
  --commission-max-change-rate "0.1" \
  --commission-max-rate "0.2" \
  --commission-rate "0.1" \
  --min-self-delegation "1" \
  --pubkey  $(neutrond tendermint show-validator) \
  --gas=auto -y
```

- unjail

```
neutrond tx slashing unjail \
  --broadcast-mode block \
  --from <wallet> \
  --broadcast-mode block \
  --chain-id quark-1 \
  --fees 200untrn \
  --gas-adjustment 1 \
  -y
```  
### Delete node 

```
sudo systemctl stop neutrond
sudo systemctl disable neutrond
rm /etc/systemd/system/neutrond.service
sudo systemctl daemon-reload
cd $HOME
rm -rf neutron
rm -rf .neutrond
rm -rf $(which neutrond)
```


