

<p align=center>
<img height="auto" src="https://user-images.githubusercontent.com/94878333/200184787-2465bb11-9e4a-40df-9926-7e8948803c83.jpg">
</p>


# HOW TO JOIN LOYAL TESTNET

OFFICIAL DOCS
>[OFFICIAL](https://docs.joinloyal.io/)

## Install automatic

```
wget -O loyal.sh https://raw.githubusercontent.com/Genz22/Testnet-node/main/loyal/loyal.sh && chmod +x loyal.sh && ./loyal.sh
```

- check sync 

```
loyald status 2>&1 | jq .SyncInfo
```

waiting to `false`

## Create Wallet

```
loyald keys add wallet
```

or recover if you have mnemonic

```
loyald keys add wallet --recover
```

>input your mnemonic

- check list wallet

```
loyald keys list
```

- valoper 

```
loyald keys show wallet --bech val -a
```

## Create validator

- faucet 

```
curl -X POST "https://faucet.joinloyal.io/" -H "accept: application/json" -H "Content-Type: application/json" -d "{ \"address\": \",address>\", \"coins\": [ \"2000000ulyl\" ]}"
```

- create validator

```
loyald tx staking create-validator \
  --amount 10000000ulyl \
  --from wallet \
  --commission-max-rate "0.2" \
  --commission-rate "0.05" \
  --pubkey  $(loyald tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id loyal-1 \
  --gas auto -y
```

- explore 

https://ping-pub.joinloyal.io/loyal/staking

## Command

- check logs

```
journalctl -fu loyald -o cat
```

- stop node

```
systemctl stop loyald
```

- restart node

```
systemctl restart loyald
```

- Check status 

```
loyald status |& jq
```

## Delete node 

```
sudo systemctl stop loyald
sudo systemctl disable loyald
sudo rm -rf /etc/systemd/system/loyald* 
sudo rm -rf $(which loyald) 
sudo rm -rf $HOME/.loyal* 
sudo rm -rf $HOME/loyal* 
```
