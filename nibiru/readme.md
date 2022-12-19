

<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/94878333/200153512-dd6a14ee-69e1-4870-bd08-47149281a2c5.jpg">
</p>



# nibiru node setup for testnet

Official docs
>(official)[https://docs.nibiru.fi/run-nodes/testnet/]

## Update packages

```
sudo apt update && sudo apt upgrade -y
```

## install dependencies

```
sudo apt install curl build-essential git wget jq make gcc tmux chrony -y
```

## Install GO

```
ver="1.18.2"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
```

## Download and build binaries

```
cd ~
rm -rf nibiru
git clone https://github.com/NibiruChain/nibiru.git
cd nibiru
git checkout v0.15.0
make install
```

## Config app

```
nibid config chain-id $NIBIRU_CHAIN_ID
nibid config keyring-backend test
```

## Init

```
nibid init <node name> --chain-id nibiru-testnet-1
```

## Download genesis and addrbook

```
curl -s https://rpc.testnet-1.nibiru.fi/genesis | jq -r .result.genesis > $HOME/.nibid/config/genesis.json
```

## Set seeds and peers

```
SEEDS=""
PEERS="37713248f21c37a2f022fbbb7228f02862224190@35.243.130.198:26656,ff59bff2d8b8fb6114191af7063e92a9dd637bd9@35.185.114.96:26656,cb431d789fe4c3f94873b0769cb4fce5143daf97@35.227.113.63:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.nibid/config/config.toml
```

## Config pruning

```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.nibid/config/app.toml
```

## Set minimum gas price and timeout commit

```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0unibi\"/" $HOME/.nibid/config/app.toml
```

## Enable prometheus

```
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.nibid/config/config.toml
```

## Reset chain data

```
nibid tendermint unsafe-reset-all --home $HOME/.nibid
```

## Create service

```
sudo tee /etc/systemd/system/nibid.service > /dev/null <<EOF
[Unit]
Description=nibi
After=network-online.target

[Service]
User=$USER
ExecStart=$(which nibid) start --home $HOME/.nibid
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

## Register and start service

```
sudo systemctl daemon-reload
sudo systemctl enable nibid
sudo systemctl restart nibid && sudo journalctl -u nibid -f -o cat
```

```
source $HOME/.bash_profile
```

======================

check sync

```
nibid status 2>&1 | jq .SyncInfo
```


















