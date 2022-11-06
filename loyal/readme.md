

<p align=center>
<img height="auto" src="https://user-images.githubusercontent.com/94878333/200184787-2465bb11-9e4a-40df-9926-7e8948803c83.jpg">
</p>


# HOW TO JOIN LOYAL TESTNET

OFFICIAL DOCS
>![OFFICIAL](https://docs.joinloyal.io/)

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

##
