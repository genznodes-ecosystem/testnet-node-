<p style="font-size:20px" align="right">
<a href="https://t.me/GenzDrops" target="_blank"> Support <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>

<p align="center">
    <img height="200" widht="auto" src="https://user-images.githubusercontent.com/94878333/207770697-66faac80-a27c-4475-8589-08eecb5cb234.jpg">
</p>

# How to join nolus testnet

chain id = nolus-rila

## Hardware Requirements

| Minimal | Recommended |
| --- | --- |
| 1 GB RAM | 4+ GB RAM |
| 120+ GB SSD | 120+ GB SSD |
| 1.4 GHz CPU | 2+ vCPU |

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
echo "export NOLUS_CHAIN_ID=nolus-rila" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

## update packages and install dependencies

```
sudo apt update && sudo apt upgrade -y && sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```

## install go

```
ver="1.19.5"
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
git clone https://github.com/Nolus-Protocol/nolus-core
cd nolus-core
git checkout v0.1.43
make install
```

check 

```
nolusd version --long
```

## config app

```
nolusd config chain-id $NOLUS_CHAIN_ID
nolusd config keyring-backend test
```

## init

```
nolusd init $NODENAME --chain-id $NOLUS_CHAIN_ID
```

## get genesis and addrbook

- genesis

```
curl https://raw.githubusercontent.com/Nolus-Protocol/nolus-networks/main/testnet/nolus-rila/genesis.json > $HOME/.nolus/config/genesis.json
```

- addrbook

```
NA
```

## set peers and seed

```
SEEDS=""
PEERS="$(curl -s "https://raw.githubusercontent.com/Nolus-Protocol/nolus-networks/main/testnet/nolus-rila/persistent_peers.txt")"

sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.nolus/config/config.toml
```

## set config pruning

```
pruning="nothing"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.nolus/config/app.toml
```

## reset data

```
nolusd tendermint unsafe-reset-all --home $HOME/.nolus
```

## create service file and start node

- create 

```
sudo tee /etc/systemd/system/nolusd.service > /dev/null <<EOF
[Unit]
Description=nolusd
After=network-online.target

[Service]
User=root
ExecStart=$(which nolusd) start --home $HOME/.nolus
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
sudo systemctl enable nolusd
sudo systemctl restart nolusd
sudo journalctl -fu nolusd -o cat
```

## add keys or import keys

- create

```
nolusd keys add wallet
```

- import 

```
nolusd keys add wallet --recover
```

## Create validator

- faucet

https://faucet-rila.nolus.io/

- create validator

```
nolusd tx staking create-validator \
--amount 1000000unls \
--commission-rate "0.1" \
--commission-max-rate "0.20" \
--commission-max-change-rate "0.1" \
--min-self-delegation "1" \
--pubkey=$(nolusd tendermint show-validator) \
--moniker $NODENAME \
--chain-id $NOLUS_CHAIN_ID \
--gas-prices 0.0042unls \
--from wallet \
--details "" \
--website "" \
-y
```

check your validator

https://explorer.genznodes.dev/nolus-rila/staking

## commands 

- check logs 

```
journalctl -fu nolusd -o cat
```

- check node info

```
nolusd status |& jq
```

- delegate

```
nolusd tx staking delegate <valoper_Address> <ammount> --from wallet --chain-id $NOLUS_CHAIN_ID --gas-prices 0.0042unls -y
```

- withdraw reward and commission

```
nolusd tx distribution withdraw-rewards <valoper_Address> --commission --from wallet --gas-prices 0.0042unls --broadcast-mode block --chain-id $NOLUS_CHAIN_ID -y
```

=======
### edit validator

```
nolusd tx staking edit-validator \
  --moniker $NODENAME \
  --identity <your_keybase_id> \
  --website "<your_website>" \
  --details "<your_validator_description>" \
  --chain-id $NOLUS_CHAIN_ID \
  --from wallet -y
```

### unjail

```
nolusd tx slashing unjail \
  --broadcast-mode block \
  --from wallet \
  --chain-id $NOLUS_CHAIN_ID \
  --gas-prices 0.0042unls
```
 
### delete node

```
sudo systemctl stop nolusd
sudo systemctl disable nolusd
sudo rm -rf /etc/systemd/system/nolusd*
sudo rm -rf $(which nolusd)
sudo rm -rf $HOME/.nolus
sudo rm -rf $HOME/nolus
sed -i '/NOLUS_/d' ~/.bash_profile
```

