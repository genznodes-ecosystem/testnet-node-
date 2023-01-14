<p style="font-size:20px" align="right">
<a href="https://t.me/GenzDrops" target="_blank"> Support <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>

<p align="center">
    <img height="200" widht="auto" src="https://user-images.githubusercontent.com/94878333/212456741-5a590e8d-24f4-4ca3-a9c9-5b6fc89b3b6d.jpg">
</p>


# HOW TO JOIN MARS TESTNET

`chain-id = ares-1`

## Hardware Requirements

A production-ready server typically requires:
- 8-core x86 CPU. Cosmos apps do compile on ARM chips (e.g. Apple's M1 processor) but the reliability is not battle-tested. Notably, chains that incorporate the CosmWasm module won't even compile on ARM servers.

- 64 GB RAM. Cosmos apps typically use less than 32 GB under normal conditions, but during events such as chain upgrades, up to 64 GB is usually needed.

- 4 TB NVME SSD. Hard drive I/O speed is crucial! Validators who run on HDD or SATA SSD often find themselves missing blocks. Requirements on disk space depends on the chain and your pruning settings but generally at least 2 TB is recommended. 

- Linux operating system. 

# setting vars

`<YOUR_MONIKER>` change with your moniker / name of your validator in explorer

```
NODENAME=<YOUR_MONIKER>
```

save and import variable

```
echo "export NODENAME=$NODENAME" >> $HOME/.bash_profile
if [ ! $WALLET ]; then
	echo "export WALLET=wallet" >> $HOME/.bash_profile
fi
echo "export MARS_CHAIN_ID=ares-1" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

# Install and update dependencies

```
sudo apt update && sudo apt upgrade -y && sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```

# Install Go

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

# Install app

```
git clone https://github.com/mars-protocol/hub.git
cd hub
git checkout v1.0.0-rc7
make install
```

check if already marsd

```
marsd version --long
```

# config node

```
marsd config chain-id $MARS_CHAIN_ID
marsd config keyring-backend test
```

# init

```
marsd init $NODENAME --chain-id $MARS_CHAIN_ID
```

## get genesis and addrbook

- genesis

```
curl -s https://raw.githubusercontent.com/mars-protocol/networks/main/ares-1/genesis.json > $HOME/.mars/config/genesis.json
```

- addrbook

```
NA
```

## set peers and seed

```
SEEDS=
PEERS=5dd3b89f9496b13c9e82becd6c201099805d789c@109.123.254.36:26656

sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.nolus/config/config.toml
```

## set config pruning

```
PRUNING="custom"
PRUNING_KEEP_RECENT="100"
PRUNING_INTERVAL="10"

sed -i -e "s/^pruning *=.*/pruning = \"$PRUNING\"/" $HOME/.mars/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \
\"$PRUNING_KEEP_RECENT\"/" $HOME/.mars/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \
\"$PRUNING_INTERVAL\"/" $HOME/.mars/config/app.toml
```

# Set gas price

```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0umars\"/" $HOME/.mars/config/app.toml
```

# index ( optional )

```
indexer="null"
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.mars/config/config.toml
```
# reset data

```
marsd tendermint unsafe-reset-all --home $HOME/.mars
```

## create service file and start node

- create 

```
sudo tee /etc/systemd/system/marsd.service > /dev/null <<EOF
[Unit]
Description=marsd
After=network-online.target

[Service]
User=$USER
ExecStart=$(which marsd) start --home $HOME/.mars
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

- start

```
sudo systemctl daemon-reload
sudo systemctl enable marsd
sudo systemctl restart marsd
sudo journalctl -fu marsd -o cat
```

- check node

```
marsd status | jq
```

# StateSync ( optional )

```
systemctl stop marsd
marsd tendermint unsafe-reset-all

SNAP_RPC="https://test-mars-rpc.genznodes.dev:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

PEERS=5dd3b89f9496b13c9e82becd6c201099805d789c@109.123.254.36:26656
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.mars/config/config.toml

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.mars/config/config.toml

systemctl restart marsd
journalctl -fu marsd -o cat
```

## add keys or import keys

- create

```
marsd keys add wallet
```

or

- import 

```
marsd keys add wallet --recover
```

## Create validator

- check sync info

```
marsd status | jq -r .SyncInfo
```

- faucet

https://faucet.marsprotocol.io/

- create validator

```
marsd tx staking create-validator \
  --pubkey $(marsd tendermint show-validator) \
  --moniker $NODENAME \
  --details "" \
  --identity "" \
  --website "" \
  --min-self-delegation 1 \
  --commission-rate "0.05" \
  --commission-max-rate "0.20" \
  --commission-max-change-rate "0.01" \
  --amount 1000000umars \
  --from wallet \
  --chain-id ares-1 \ 
  --gas auto \
  --gas-adjustment 1.4 \
  --gas-prices 0umars -y
```

- check your validator

https://testnet-explorer.genznodes.dev/mars-testnet/staking

## Usefull commands

NA
