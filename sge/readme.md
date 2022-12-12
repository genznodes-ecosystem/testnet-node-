<p style="font-size:20px" align="right">
<a href="https://t.me/GenzDrops" target="_blank"> Support <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>

<p align="center">
    <img height="200" widht="auto" src="https://user-images.githubusercontent.com/94878333/207117324-e429929d-3c97-4681-9d92-1496ab1450dd.jpg">
</p>

# How to join Sge testnet

chain id = sge-testnet-1

## Hardware Requirements

| Minimal | Recommended |
| --- | --- |
| 1 GB RAM | 2 GB RAM |
| 25 GB HDD | 100 GB HDD |
| 1.4 GHz CPU | 2.0 GHz x2 CPU |

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
git clone https://github.com/sge-network/sge
cd sge
git checkout v0.0.3
go mod tidy 
make install
```

check version

```
sged version --long
```

## init 

```
sged init <moniker> --chain-id sge-testnet-1
```

## Create wallet

```
sged keys add wallet
```

or import with :

```
sged keys add wallet --recover
```

## Get genesis

```
curl https://github.com/sge-network/blob/master/networks/sge-testnet-1/genesis.json > $HOME/.sge/config/genesis.json
```

## Get addrbook

```
wget -O $HOME/.sge/config/addrbook.json https://raw.githubusercontent.com/Genz22/Testnet-node/main/sge/addrbook.json
```

## Create service file 

```
sudo tee /etc/systemd/system/sged.service > /dev/null <<EOF
[Unit]
Description=sged
After=network-online.target

[Service]
User=$USER
ExecStart=$(which sged) start $HOME/.sge
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
sudo systemctl enable sged
sudo systemctl restart sged && sudo journalctl -u neutrond -f -o cat
```

- check sync info

```
sged status 2>&1 | jq .SyncInfo
```

- check status 

```
sged status |& jq
```

## Create validator

- faucet 

>    [#faucet_sge-network](https://discord.gg/VRfR9XXfaZ)

- create validator

```
sged tx staking create-validator \
  --amount 500000000usge \
  --moniker <moniker> \
  --chain-id sge-testnet-1 \
  --identity="" \
  --details="" \
  --website="" \
  --from wallet \
  --commission-max-change-rate "0.1" \
  --commission-max-rate "0.2" \
  --commission-rate "0.1" \
  --fees 200usge \
  --pubkey $(sged tendermint show-validator) \
  --gas=auto -y
```

- check your validator 

    https://explorer.genznodes.dev/sge-testnet-1/staking

## Useful commands

SOON !

## Delete node ( dyor )

```
sudo systemctl stop sged
sudo systemctl disable sged
rm /etc/systemd/system/sged.service
sudo systemctl daemon-reload
cd $HOME
rm -rf sge
rm -rf .sge
rm -rf $(which sged)
```