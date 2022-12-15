<p style="font-size:20px" align="right">
<a href="https://t.me/GenzDrops" target="_blank"> Support <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>

<p align="center">
    <img height="200" widht="auto" src="https://user-images.githubusercontent.com/94878333/207777692-eca3e338-e425-4eac-8d59-ee8120cd311e.svg">
</p>

# How to join human ai testnet

chain id = testnet-1

## Hardware Requirements

- Memory: 8 GB RAM
- CPU: Quad-Core
- Disk: 250 GB SSD Storage
- Bandwidth: 1 Gbps for Download / 100 Mbps for Upload

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
echo "export HUMAN_CHAIN_ID=testnet-1" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

## update packages and install dependencies

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

## build and install binary

```
cd $HOME
git clone https://github.com/humansdotai/humans
cd humans
git checkout v1.0.0
go build -o humansd cmd/humansd/main.go
```

- copy

```
sudo cp humansd /usr/local/bin/humansd
```

- check 

```
humansd version --long
```

## config app

```
humansd config chain-id $HUMAN_CHAIN_ID
humansd config keyring-backend test
```

## init

```
humansd init $NODENAME --chain-id $HUMAN_CHAIN_ID
```

## get genesis and addrbook

- genesis

```
curl -s https://rpc-testnet.humans.zone/genesis | jq -r .result.genesis > $HOME/.humans/genesis.json
```

- addrbook

```
NA
```

## set peers and seed

```
SEEDS=""
PEERS="1df6735ac39c8f07ae5db31923a0d38ec6d1372b@45.136.40.6:26656,9726b7ba17ee87006055a9b7a45293bfd7b7f0fc@45.136.40.16:26656,6e84cde074d4af8a9df59d125db3bf8d6722a787@45.136.40.18:26656,eda3e2255f3c88f97673d61d6f37b243de34e9d9@45.136.40.13:26656,4de8c8acccecc8e0bed4a218c2ef235ab68b5cf2@45.136.40.12:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.humans/config/config.toml
```

## set minimum gas

```
sed -i 's/minimum-gas-prices =.*/minimum-gas-prices = "0.025uheart"/g' $HOME/.humans/config/app.toml
```

## Update block time parameters

```
CONFIG_TOML="$HOME/.humans/config/config.toml"
 sed -i 's/timeout_propose =.*/timeout_propose = "100ms"/g' $CONFIG_TOML
 sed -i 's/timeout_propose_delta =.*/timeout_propose_delta = "500ms"/g' $CONFIG_TOML
 sed -i 's/timeout_prevote =.*/timeout_prevote = "100ms"/g' $CONFIG_TOML
 sed -i 's/timeout_prevote_delta =.*/timeout_prevote_delta = "500ms"/g' $CONFIG_TOML
 sed -i 's/timeout_precommit =.*/timeout_precommit = "100ms"/g' $CONFIG_TOML
 sed -i 's/timeout_precommit_delta =.*/timeout_precommit_delta = "500ms"/g' $CONFIG_TOML
 sed -i 's/timeout_commit =.*/timeout_commit = "1s"/g' $CONFIG_TOML
 sed -i 's/skip_timeout_commit =.*/skip_timeout_commit = false/g' $CONFIG_TOML
``` 

## set config pruning

```
PRUNING="custom"
PRUNING_KEEP_RECENT="100"
PRUNING_INTERVAL="10"

sed -i -e "s/^pruning *=.*/pruning = \"$PRUNING\"/" $HOME/.humans/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \
\"$PRUNING_KEEP_RECENT\"/" $HOME/.humans/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \
\"$PRUNING_INTERVAL\"/" $HOME/.humans/config/app.toml
```

## reset data

```
humansd tendermint unsafe-reset-all --home $HOME/.humans
```

## create service file and start node

### create 

```
sudo tee /etc/systemd/system/humansd.service > /dev/null <<EOF
[Unit]
Description=humansd
Requires=network-online.target
After=network-online.target

[Service]
User=$USER
ExecStart=$(which humansd) start --home $HOME/.humans
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

### start node

```
systemctl daemon-reload
systemctl enable humansd
systemctl restart humansd
journalctl -fu humansd -o cat
```

## add keys or import keys

- create

```
humansd keys add wallet
```

- import 

```
humansd keys add wallet --recover
```


## Create validator

### faucet

https://discord.gg/humansdotai > # testnet faucet

### create validator

```
humansd tx staking create-validator \
--amount 10000000uheart \
--commission-max-change-rate "0.1" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--details "" \
--pubkey=$(humansd tendermint show-validator) \
--moniker $NODENAME \
--chain-id $HUMAN_CHAIN_ID \
--gas-prices 0.025uheart \
--from wallet -y
```

### check your validator

https://explorer.genznodes.dev/human-testnet

## commands 

- check logs 

```
journalctl -fu humansd -o cat
```

- check node info

```
humansd status |& jq
```

- delegate

```
humansd tx staking delegate <valoper_Address> <ammount> --from wallet --chain-id $HUMAN_CHAIN_ID --gas-prices 0.025uheart -y
```

- withdraw reward and commission

```
humansd tx distribution withdraw-rewards <valoper_Address> --commission --from wallet --gas-prices 0.025uheart --broadcast-mode block --chain-id $HUMAN_CHAIN_ID -y
```

### edit validator 
humansd tx staking edit-validator \
  --moniker $NODENAME \
  --identity <your_keybase_id> \
  --website "<your_website>" \
  --details "<your_validator_description>" \
  --chain-id $HUMAN_CHAIN_ID \
  --from wallet -y

### unjail

```
humansd tx slashing unjail \
  --broadcast-mode block \
  --from wallet \
  --chain-id $HUMAN_CHAIN_ID \
  --gas-prices 0.025uheart
```
 
### delete node

```
sudo systemctl stop humansd
sudo systemctl disable humansd
sudo rm -rf /etc/systemd/system/humansd*
sudo rm -rf $(which humansd)
sudo rm -rf $HOME/.humans
sudo rm -rf $HOME/humans
```

