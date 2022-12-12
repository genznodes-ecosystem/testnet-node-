## RUN MASTER NODE 

### 1. Configuration

```
cd
cd inery-node/inery.setup/tools/
```

```
nano config.json
```
> *NOTE Name can have maximum of 12 characters ASCII lowercase a-z, 1-5 and dot character "." but dot can't be at the end of string

```"MASTER_ACCOUNT":
{
    "NAME": "<AccountName>",
    "PUBLIC_KEY": "<PublicKey>",
    "PRIVATE_KEY": "<PrivateKey>",
    "PEER_ADDRESS": "<IP>:9010",
    "HTTP_ADDRESS": "0.0.0.0:8888",
    "HOST_ADDRESS": "0.0.0.0:9010"
}
```
CHANGE

* Account name 
* public key 
* PrivateKey
* IP

> Save it (ctrl+S), Type "Y" and exit (ctrl+X)

### 2. Start blockchain protocol

```
cd inery-node/inery.setup
```

```
screen -R master
```

```
./ine.py --master
```

If everything is setup properly, after executing above command you should be able to see replay of blocks, may be up to few hours until sync is finished. After blockchain is replayed you will see new created blocks.

WAIR FOR SYNC > marked with a changed log

```
cd inery-node/inery.setup/master.node
```

```
./start.sh
```

### 3. Register and approve

After everything is setup, you have to register and after approve it your account as producer

```
cd inery-node/inery.setup/master.node
```

```
cline wallet create -n <name wallet> --file Wallet.txt
```

Now you created your default wallet with password saved in "Wallet.txt" file In order to use wallet, 
wallet must me unlocked To do so,replace WALLET_PASSWORD with acctual password and execute command :

```
cline wallet unlock --password WALLET_PASSWORD
```

After wallet is unlocked, import your account's private key, replacing MASTER_PRIVATE_KEY with private key of your account, by executing command :

```
cline wallet import --private-key MASTER_PRIVATE_KEY -n <name wallet>
```

Now you can register and approve your account as Master (block producer)

REGISTER ;
```
cline system regproducer <ACCOUNT_NAME> <ACCOUNT_PUBLIC_KEY> 0.0.0.0:9010
```

Approve your account as producer ;
```
cline system makeprod approve <ACCOUNT_NAME> <ACCOUNT_NAME>
```


## Stoping a Node

```
cd inery-node/inery.setup/master.node
```

```
./stop.sh
```


## Clean Blockchain 

```
./clean.sh
```

---





