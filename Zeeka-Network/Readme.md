# CHAOS TESTNET BY ZEEKA NETWORK 

--------------------------------------------

## RULES 

- Participants are required to keep themselves updated regarding the announcements published on our Discord and Twitter.
- You have to updat your node/executor/miner software when asked. Outdated miners/nodes will not receive their rewards.
- In order to control the height progress of the testnet, we have put a hard-coded height limit on our software. The height limit is currently set to: 5000 blocks.
- During the testnet, we may be required to resync our nodes or restart building blocks from height 0. Do not panic! We will keep track of all participants' contribution even after fresh starts!

## HOW TO RUN BAZUKA 

If you only want to run a Zeeka node and do not want to execute Zero Contract or mine Zeeka, you will only need to install bazuka (This repo).
In case you also want to mine Zeeka, you will need to install zoro (The Main Payment Network executor) and also the uzi-miner (A RandomX CPU miner).

### install bazuka 

- Update and upgrade

```
sudo apt update && sudo apt upgrade -y
```

- install cmake 

```
sudo apt install -y build-essential libssl-dev cmake
```

- Install the Rust toolchain (https://rustup.rs/)

```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

- Clone the `bazuka` repo:

```
git clone https://github.com/zeeka-network/bazuka
```

- Warning: Make sure Rust binaries are present in your PATH before compiling:

```
source "$HOME/.cargo/env"
```

- Compile and install:

```
cd bazuka
cargo install --path .
```

- Then initialize:

```
bazuka init --seed [your seed phrase] --network chaos --node 127.0.0.1:8765
```

(Example seed: "AOSFJOISDFOPISDFM005834JKJLKSFLDSKFASF")

The seed is a random string of characters, not mnemonic phrases. You do not need to generate it using wallets! (E.g Metamask) The longer the seed is, the safer. 
We suggest a seed string of at least 80 random characters. Your regular and zero-knowledge private-keys are derived from the --seed value,
so don't forget to keep them somewhere safe and do not share it!

- Run your node:

```
bazuka node --listen 0.0.0.0:8765 --external [your external ip]:8765 \
  --network chaos --db ~/.bazuka-chaos \
  --bootstrap [bootstrap node 1] --bootstrap [bootstrap node 2] \
  --discord-handle [your username on discord server]
```

**IMPORTANT** : You are required to provide your Discord handle through the --discord-handle flag.
By providing your handle, we will be able to authenticate your node, as a part of rewarding process.

## How to mine ℤeeka?

In order to be a miner, besides working on a PoW puzzle, you will also need to execute the MPN contract on each block you generate. 
The zoro software is a CPU/GPU-executor of MPN contract. In order to run zoro, you'll need a machine with at least 32GB of RAM. 
If you want to be competitive miner you'll also have to competitive CPU. (In future versions, GPU will be used instead of CPU)

- Make sure Bazuka is the latest version.

```
cd bazuka
git pull origin master
cargo install --path .
```

If you get a DifferentGenesis error, it means that the genesis block has changed in the updated software. So you need to start fresh. 
Remove the `~/.bazuka-chaos` folder by running: `rm -rf ~/.bazuka-chaos`

Now run Bazuka again.

- Install the MPN executor (zoro)

Make sure you have your GPU drivers installed. You also have to install ocl-icd-opencl-dev! **(Currently, only NVIDIA GPUs are supported!)**

- clone zoro 

```
git clone https://github.com/zeeka-network/zoro
cd zoro
cargo install --path .
```

- Download the proving parameters

```
wget https://api.rues.info/payment_params.dat -O payment_params.dat
wget https://api.rues.info/update_params.dat -O update_params.dat
```

- Run zoro beside your node: (This will use your Nvidia GPU for mining!)

```
zoro --node 127.0.0.1:8765 --seed [seed phrase for the executor account] --network chaos \
--update-circuit-params [path to update_params.dat] --payment-circuit-params [path to payment_params.dat] \
--db $HOME/.bazuka-chaos --gpu
```

**Note** : 
* You can switch to CPU by removing the --gpu flag, but your chances of mining a block will be very little with a CPU executor!
* The seed phrase for the executor account needs to be different from the seed you use for your node!
  The transaction fees of the Zero transactions processed by your executor will go to this account

- After a new block is generated, the *uzi-miner* should start working on the PoW puzzle, so you will also need to have uzi-miner running on your system:

```
git clone https://github.com/zeeka-network/uzi-miner
cd uzi-miner
cargo install --path .
uzi-miner --node 127.0.0.1:8765 --threads 32
```

(Note: Change number of `--threads` based on the spec of your system)

















  
  
  
  
