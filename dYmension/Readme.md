# dYmension

## Minimum Requirements

To prepare for the upcoming testnet and network upgrades the dYmension settlement layer validators and full nodes should be prepared with the following minimum recommended hardware requirements:

* Dual Core
* At least 500GB of SSD disk storage
* At least 8GB of memory (RAM)
* At least 100mbps network bandwidth

These requirements will continually be revisted and tested by the core team and community.

# RUN NODE

## Update and upgrade

```
sudo apt update && sudo apt upgrade -y
```

## Install Go

```
sudo apt instal golang-go
```

check if already installed

```
go version
```
output
>go version go1.19.2 linux/amd64

* Environments

```
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
```

## Install binaries

```
git clone https://github.com/dymensionxyz/dymension.git --branch v0.1.0-alpha
cd dymension
make install
```

check 

```
dymd version
```

>latest

## Initializing dymd

Set variable

```
export CHAIN_ID="local-testnet"
export KEY_NAME="local-user"
export MONIKER_NAME="local"
```

When starting a node you need to initialize a chain with a user:

```
dymd init "$MONIKER_NAME" --chain-id "$CHAIN_ID"
dymd keys add "$KEY_NAME" --keyring-backend test
dymd add-genesis-account "$(dymd keys show "$KEY_NAME" -a --keyring-backend test)" 100000000000stake
dymd gentx "$KEY_NAME" 100000000stake --chain-id "$CHAIN_ID" --keyring-backend test
dymd collect-gentxs
```

Now start the chain!

```
dymd start
```

You should have a running local node! Let's run a sample transaction.

Keep the node running and open a new tab in the terminal. Let's get your validator consensus address

## Interacting with node

```
dymd tendermint show-address
```

This returns an address with the prefix "dymvalcons" or the dYmension validator consensus address.


Done for now , Wait for update !! 
