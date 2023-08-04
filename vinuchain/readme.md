# Guide installation node vinuchain testnet

## Install dependencies

```bash
sudo apt update && sudo apt upgrade -y && \
sudo apt install git build-essential curl libclang-dev clang cmake screen -y
```

- install Go

```bash
ver="1.20.4"
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
```

```
go version
```

> go version go1.20.4 ...

## Install Opera

```bash
git clone https://github.com/VinuChain/VinuChain vinuchain
cd vinuchain
make
mv ./build/opera $HOME/go/bin
```

- check opera

```bash
opera version
```

## config and start node

- download genesis

```bash
mkdir $HOME/.opera
```

```bash
wget -O $HOME/.opera/genesis.g "https://github.com/genznodes-ecosystem/testnet-node-/raw/main/vinuchain/genesis-testnet.g"
```

- start in screen

```bash
screen -S opera
```

```bash
opera --syncmode full --port 1212 --nat any --genesis.allowExperimental --genesis $HOME/.opera/genesis.g --bootnodes enode://3c4da2358ce3c3e117b03e4c87dff1d8d767a684e3c94f5eb29a4e88f549ba2f5a458eab60df637417411bb59b52f94542cf7d22f0dd1a10e45d5ae71c66e334@54.203.151.219:3000
```

- close screen with `CTRL A + D`

## create validator

### create wallet and key validator

```
opera account new 
```

```
opera validator new
```

- **open console**

```bash
opera attach
```

- init SFC 

Open link [SFC.JS](https://notepad.pw/raw/QIMEW3BawgTp06zTxzEy) copy all js code from there

```
Welcome to the Lachesis JavaScript console!

instance: go-opera/genznodes/v1.1.2-rc.3-2dc4be4c-1690293001/linux-amd64/go1.20.4
coinbase: 0x0000000000000000000000000000000000000000
at block: 196439 (Fri Aug 04 2023 04:14:28 GMT+0000 (UTC))
 datadir: /home/testnet/.opera
 modules: abft:1.0 admin:1.0 dag:1.0 debug:1.0 ftm:1.0 net:1.0 personal:1.0 rpc:1.0 txpool:1.0 web3:1.0

To exit, press ctrl-d

> PASTE HERE
```

```
sfcc = web3.ftm.contract(abi).at("0xfc00face00000000000000000000000000000000")
```

- unlock wallet

```
personal.unlockAccount("WALLET_ADDRESS", "PASSWORD")
```

- create validator

```
tx = sfcc.createValidator("VALIDATOR_PUBKEY", {from:"WALLET_ADDRESS", value:web3.toWei("100000.0", "ftm")})
```

> TXHASH

search your tx in explorer https://vinuscan.com/transactions/TXHASH

check your validator ID 

```bash
sfc.getValidatorID("WALLET_ADDRESS")
```

- close console `CTRL + D`

## Stop node 

```bash
screen -rd opera
```

and then  `CTRL + C`

## Start validator node

- create password file

```bash
echo "YOUR_WALLET_PASSWORD" > $HOME/.opera/keystore/pwd.txt
```

- set service file 

make sure change `NODE_NAME` , `VALIDATOR_ID` and `YOUR_PUBKEY`  .

```bash
sudo tee /etc/systemd/system/opera.service > /dev/null <<EOF
[Unit]
Description="vinuchain daemon node"
After=network-online.target

[Service]
User=$USER
ExecStart=$(which opera) --syncmode full --identity NODE_NAME --gcmode full --port 1212 --genesis.allowExperimental --genesis $HOME/.opera/genesis.g --validator.id VALIDATOR_ID --validator.pubkey YOUR_PUBKEY --validator.password $HOME/.opera/keystore/pwd.txt --bootnodes enode://3c4da2358ce3c3e117b03e4c87dff1d8d767a684e3c94f5eb29a4e88f549ba2f5a458eab60df637417411bb59b52f94542cf7d22f0dd1a10e45d5ae71c66e334@54.203.151.219:3000
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

- start service

```bash
sudo systemctl daemon-reload
sudo systemctl enable opera
sudo systemctl restart opera
```

- check logs 

```bash
journalctl -fu opera -o cat
```