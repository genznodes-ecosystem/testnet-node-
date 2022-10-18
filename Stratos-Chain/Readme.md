<p style="font-size:14px" align="right">
<a href="https://t.me/GenzDrops" target="_blank">Join our telegram <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>

# Tropos Incentive Testnet

## Setup and Run a Stratos-chain Full node

Stratos blockchain facilitates all decentralized ledger transactions and functionalities, providing settlement services and related financial payment services for network providers and network users in an efficient, fair and transparent manner.

The Stratos-chain full-nodes are dedicated servers with sufficient computing power that participate in block generation cycle. It is necessary in order to be a validator.

In practice, running a full-node only implies running a non-compromised and up-to-date version of the software with low network latency and without downtime. It is encouraged to run a full-node even if you do not plan to be a validator.

The Stratos-chain validator is a full-node that participates in the Stratos Chain block generation cycle and also voting for the validity of a block proposed.

### Requirements

* Recomendend Hardware

|  Machine |  Minimum  |
| ------------ | ------------ |
| CPU       | i5 (4 Core) |
| RAM       | 16 GB       |
| Hard disk | 2 TB        |

### Environment 

* Update the system
```
sudo apt update && sudo apt upgrade -y
```
    
* Install git, snap and make(you can also install them separately as your needs)
```
sudo apt install git build-essential curl snapd --yes
```

* Install Go 1.16+ with Snap 
```
sudo snap install go --classic
```

* export environment variables
```
echo 'export GOPATH="$HOME/go"' >> ~/.profile
echo 'export GOBIN="$GOPATH/bin"' >> ~/.profile
echo 'export PATH="$GOBIN:$PATH"' >> ~/.profile
source ~/.profile
```

### Setup a Stratos-chain full-node

* Get release binary executable files


  - **Build the extracted source code**
  
    ```
    git clone https://github.com/stratosnet/stratos-chain.git
    cd stratos-chain
    git checkout tags/v0.8.0
    make build
    ```
    
  - **Installing the binary executable**
    
    The binary can be installed to the default $GOPATH/bin folder by running:

    ```
    make install
    ```

* Get the genesis and configuration files

  - Initialize your node
  
  ```
  cd $HOME
  ./stchaind init "your_node_moniker>
  ```
  
* Download the genesis.json and config.toml files

```
wget https://raw.githubusercontent.com/stratosnet/stratos-chain-testnet/main/genesis.json
wget https://raw.githubusercontent.com/stratosnet/stratos-chain-testnet/main/config.toml
```

Change `moniker` in the downloaded **config.toml** file

```
# A custom human readable name for this node
moniker = "<your_node_moniker>"
```

Move the downloaded config.toml and genesis.json files to $HOME/.stchaind/config/ folder. Replace if you already have these files.

```
mv config.toml $HOME/.stchaind/config/
mv genesis.json $HOME/.stchaind/config/
```

* Run as Service

```
sudo nano /lib/systemd/system/stratos.service
```

Paste Following content below

```
[Unit]
Description=Stratos Chain Node
After=network-online.target

[Service]
User=root
Group=root
Environment=DAEMON_NAME=stchaind
Environment=DAEMON_HOME=/root/.stchaind
Environment=DAEMON_ALLOW_DOWNLOAD_BINARIES=on
Environment=DAEMON_RESTART_AFTER_UPGRADE=on
ExecStart=/root/stchaind start --home=/root/.stchaind
Restart=on-failure
RestartSec=3
LimitNOFILE=8192

[Install]
WantedBy=multi-user.target
```

>CTRL + X , Y AND ENTER

* Enable service and start 

```
systemctl daemon-reload
systemctl enable stratos.service
systemctl start stratos.service
```

*  Check log and other commands
    - Check service 
    ```
    systemctl status stratos.service
    ```
  
    - Check Log Service 
    ```
    journalctl -u stratos.service -f 
    ```
  
    - Stop the service
    ```
    systemctl stop stratos.service
    ```
  
    - Restart 
    ```
    systemctl restart stratos.service
    ```
    
* Check node status

```
stchaind status |& jq
```

If the `catching_up : false ` in the sync_info section, it means that you are fully synced.

After sync Go to next step

* Set up wallet 

```
stchaind keys add <your wallet name> --hd-path="m/44'/606'/0'/0/0" --keyring-backend test
```

* Fund your wallet with faucet 

```
curl --header "Content-Type: application/json" --request POST --data '{"denom":"ustos","address":"<your wallet address>"} ' https://faucet-tropos.thestratos.org/credit
```

>1 stos = 1,000,000,000 ustos
Change <your wallet address> with your wallet

### How to become a validator 

[official docs](https://github.com/stratosnet/stratos-chain/wiki/How-to-Become-a-Validator)

* Get a new Validator Pubkey

```
cd
stchaind tendermint show-validator
```

* Create Validator
  
```
stchaind tx staking create-validator \
--amount=100000000000ustos \
--pubkey='your output in step Get a new Validator Pubkey' \
--moniker="<your moniker>" \
--chain-id=tropos-4  --keyring-backend=test --gas=auto -y \
--commission-rate=0.10 \
--commission-max-rate=0.20 \
--commission-max-change-rate=0.01 \
--min-self-delegation=1 \
--from=<Wallet> \
--gas=auto -y
  ```
  
* Explore
  
[Explore](https://explorer-tropos.thestratos.org/validators)
  
