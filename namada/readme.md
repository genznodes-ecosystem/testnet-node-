<p style="font-size:20px" align="right">
<a href="https://t.me/GenzDrops" target="_blank"> Support <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>

<p align="center">
    <img height="200" widht="auto" src="https://user-images.githubusercontent.com/94878333/214481209-eac4a567-1ee3-4a5f-b6e6-2766e859198f.jpg">
</p>

# HOW TO JOIN Namada Testnet

`chain-id: public-testnet-2.1.4014f207f6d`

# Setting Vars 

`<YOUR_MONIKER>` change with your moniker / name of your validator in explorer

```
echo "export VALIDATOR_ALIAS=YOUR_MONIKER" >> ~/.bash_profile
echo "export NAMADA_TAG=v0.13.2" >> ~/.bash_profile
echo "export TM_HASH=v0.1.4-abciplus" >> ~/.bash_profile
echo "export CHAIN_ID=public-testnet-2.1.4014f207f6d" >> ~/.bash_profile
echo "export WALLET=wallet" >> ~/.bash_profile
source ~/.bash_profile
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

# Install rust and nodejs

```
sudo curl https://sh.rustup.rs -sSf | sh -s -- -y
source "$HOME/.cargo/env"
curl https://deb.nodesource.com/setup_16.x | sudo bash
sudo apt install cargo nodejs -y < "/dev/null"
```

```
cargo --version
```

# Install Namada

```
cd $HOME 
git clone https://github.com/anoma/namada
cd namada
git checkout $NAMADA_TAG
make build-release
```

```
cp -r "$HOME/namada/target/release/namada" "$HOME/.cargo/bin/namada"
cp -r "$HOME/namada/target/release/namadac" "$HOME/.cargo/bin/namadac" 
cp -r "$HOME/namada/target/release/namadan" "$HOME/.cargo/bin/namadan"
cp -r "$HOME/namada/target/release/namadaw" "$HOME/.cargo/bin/namadaw"
```

- check 

```
namada --version
```

Output
> Namada v0.13.2

# Install tendermint

```
cd $HOME 
git clone https://github.com/heliaxdev/tendermint 
cd tendermint
git checkout $TM_HASH
make build
```

```
cp -r $HOME/tendermint/build/tendermint  /usr/local/bin/tendermint
```

```
tendermint version
```
Output
> 0.1.4-abciplus

# Join network and run node

```
cd $HOME 
namada client utils join-network --chain-id $CHAIN_ID
wget "https://github.com/heliaxdev/anoma-network-config/releases/download/public-testnet-2.1.4014f207f6d/public-testnet-2.1.4014f207f6d.tar.gz"
tar xvzf "$HOME/public-testnet-2.1.4014f207f6d.tar.gz"
```

- create service file

```
sudo tee /etc/systemd/system/namadad.service > /dev/null <<EOF
[Unit]
Description=Namada
After=network-online.target

[Service]
User=$USER
WorkingDirectory=$HOME/.namada
Environment=NAMADA_LOG=debug
Environment=NAMADA_TM_STDOUT=true
ExecStart=$(which namada) --base-dir=$HOME/.namada node ledger run 
StandardOutput=syslog
StandardError=syslog
Restart=always
RestartSec=10
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

```
sudo systemctl daemon-reload
sudo systemctl enable namadad
sudo systemctl restart namadad
journalctl -fu namadad -o cat
```

# Create validator

- check sync status 

```
curl -s localhost:26657/status |& jq
```

must `"catching_up": false`

- create wallet

```
namada wallet address gen --alias $WALLET
```

- get faucet

```
namada client transfer \
  --source faucet \
  --target $WALLET \
  --token NAM \
  --amount 1000 \
  --signer $WALLET
```

