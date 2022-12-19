<p style="font-size:20px" align="right">
<a href="https://t.me/GenzDrops" target="_blank"> Support <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>

<p align="center">
    <img height="200" widht="auto" src="https://user-images.githubusercontent.com/94878333/208455208-18ec3655-1917-4356-a5fd-47f96dd45280.jpg">
</p>

# How to join Realio-network testnet

chain-id: realionetwork_1110-2

## setting vars

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
echo "export REALIO_CHAIN_ID=realionetwork_1110-2" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

## Download and update dependencies

```
sudo apt update && sudo apt upgrade -y && sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```

## install go

```
ver="1.18"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
```

check go 

```
go version
```

## build and install node

```
cd $HOME
git clone https://github.com/realiotech/realio-network.git && cd realio-network
git checkout v0.6.3
make install
```

- check if app installed

```
realio-networkd version --long
```

## config app

```
realio-networkd config chain-id $REALIO_CHAIN_ID
realio-networkd config keyring-backend test
```

## init 

```
realio-networkd init $NODENAME --chain-id $REALIO_CHAIN_ID
```

## Create wallet

```
realio-networkd keys add wallet
```

or import with :

```
realio-networkd keys add wallet --recover
```

## Get genesis and addrbook

- genesis

```
curl https://raw.githubusercontent.com/realiotech/testnets/master/realionetwork_1110-2/genesis.json > $HOME/.realio-network/config/genesis.json
```

- addrbook

```
wget -O $HOME/.realio-network/config/addrbook.json https://raw.githubusercontent.com/Genz22/Testnet-node/main/realio/addrbook.json
```

## set peers and seed

```
SEEDS="aa194e9f9add331ee8ba15d2c3d8860c5a50713f@143.110.230.177:26656"
PEERS="0b45c2a8b4e644929f5e439603af1fe6fea5ebce@154.26.138.73:26656"

sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.reakio-network/config/config.toml
```

## set config pruning

```
PRUNING="custom"
PRUNING_KEEP_RECENT="100"
PRUNING_INTERVAL="10"

sed -i -e "s/^pruning *=.*/pruning = \"$PRUNING\"/" $HOME/.realio-network/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \
\"$PRUNING_KEEP_RECENT\"/" $HOME/.realio-network/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \
\"$PRUNING_INTERVAL\"/" $HOME/.realio-network/config/app.toml
```

## Create service file 

```
sudo tee /etc/systemd/system/realio-networkd.service > /dev/null <<EOF
[Unit]
Description=realio-networkd
After=network-online.target

[Service]
User=$USER
ExecStart=$(which realio-networkd) start --home $HOME/.realio-network
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
sudo systemctl enable realio-networkd
sudo systemctl restart realio-networkd && sudo journalctl -u realio-networkd -f -o cat
```



- check status 

```
realio-networkd status |& jq
```

## create validator

- check sync info

```
realio-networkd status 2>&1 | jq .SyncInfo
```

you must sync `catching_up: false` 

- create 

```
realio-networkd tx staking create-validator \
  --amount 1000000000000000000ario \
  --from wallet \
  --commission-max-change-rate "0.1" \
  --commission-max-rate "0.2" \
  --commission-rate "0.05" \
  --min-self-delegation "1" \
  --pubkey $(realio-networkd tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id $REALIO_CHAIN_ID \
  --identity="" \
  --details="" \
  --website="" \
  --gas auto \
  --gas-adjustment=1.5 \
  --gas-prices="7ario" -y
```

- explorer

https://explorer.genznodes.dev/realio-testnet

## commands 

- check logs node

```
journalctl -fu realio-networkd -o cat
```

- check sync info

```
realio-networkd status 2>&1 | jq .SyncInfo
```

- check status 

```
realio-networkd status |& jq
```

- delegate

```
realio-networkd tx staking delegate <valoper_Address> <ammount> --from wallet --chain-id $REALIO_CHAIN_ID --gas-prices 7ario -y
```

- withdraw reward and commission

```
nolusd tx distribution withdraw-rewards <valoper_Address> --commission --from wallet --gas-prices 7ario --broadcast-mode block --chain-id $REALIO_CHAIN_ID -y
```

### edit validator 
realio-networkd tx staking edit-validator \
  --moniker $NODENAME \
  --identity <your_keybase_id> \
  --website "<your_website>" \
  --details "<your_validator_description>" \
  --chain-id $REALIO_CHAIN_ID \
  --from wallet -y

### unjail

```
realio-networkd tx slashing unjail \
  --broadcast-mode block \
  --from wallet \
  --chain-id $REALIO_CHAIN_ID \
  --gas-prices 7ario
```
 
### delete node

```
sudo systemctl stop realio-networkd
sudo systemctl disable realio-networkd
sudo rm -rf /etc/systemd/system/realio*
sudo rm -rf $(which realio-networkd)
sudo rm -rf $HOME/.realio*
sudo rm -rf $HOME/realio*
sed -i '/REALIO_/d' ~/.bash_profile
```