
<p align="center">
    <img heigt="auto" src="https://user-images.githubusercontent.com/94878333/202914833-e95984d8-70d8-4a15-8c1a-84ade2711b5e.png">
</p>

# Guide to run Aleo

**Overview**

snarkOS is a decentralized operating system for zero-knowledge applications. This code forms the backbone the Aleo network, which verifies transactions and stores the encrypted state applications in a publicly-verifiable manner.

## Requirements

The following are minimum requirements to run an Aleo node:

- CPU: 16-cores (32-cores preferred)
- RAM: 16GB of memory (32GB preferred)
- Storage: 128GB of disk space
- Network: 10 Mbps of upload and download bandwidth

Please note to run an Aleo Prover that is competitive, the machine will require more than these requirements.

## Build and run Node

### 1. Update and install automatic

```
wget -O aleo.sh https://raw.githubusercontent.com/Genz22/Testnet-node/main/ALEO/aleo.sh && chmod +x aleo.sh && ./aleo.sh
```

### 2. Create account prover

```
snarkos account new
```

save output 

example output:

> Attention - Remember to store this account private key and view key.
>
>       Private Key  APrivateKey1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
>
>           View Key  AViewKey1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
>
>               Address  aleo1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 

### 3. Run aleo prover with screen

```
cd snarkOS
screen -R aleo-prover
./run-prover.sh
```

input your private keys and close with `CTRL A + D` 

- check logs with `screen -rd aleo-prover`
