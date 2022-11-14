
<p align="center">
  <img height="100" height="auto" src="https://user-images.githubusercontent.com/94878333/200793599-be61658c-27d7-4de6-957c-79b43740ae2a.png">
</p>

# Running an Aleph Node on Testnet

OFFICIAL DOCS
>[OFFICIAL](https://docs.alephzero.org/)

## System Requirements

| Item | Minimum |
| --- | --- |
| OS Version | CentOS 7 or Ubuntu 22.04 (High will good) |
| CPU | 4 Core or Higher |
| Memory | 16 GB or Higher |
| Storage | 1 TB or Higher (SSD Recommended) |

## Prepare

- update packages

```
sudo apt update && sudo apt upgrade -y
```

- install dependencies

```
apt install git libssl-dev clang cmake make curl automake autoconf libncurses5-dev screen -y
```

- install docker

```
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update && sudo apt install docker-ce docker-ce-cli docker.io
```

## Build node

- clone repository

```
git clone https://github.com/Cardinal-Cryptography/aleph-node-runner
cd aleph-node-runner
```

- setup and running

```
cd aleph-node-runner
screen -R aleph
```

```
./run_node.sh -n <your_nodes_name>  --ip <your public ip>
```

It might take quite some time before you actually get the node running: the script will first download required files, including a database snapshot (sized ~100GB). It will then run the node for you and you can inspect the logs by running `docker logs <your_nodes_name>`

- check logs

```
docker logs --follow <name node>
```

- To check whether RPC calls work execute

```
curl -H "Content-Type: application/json" -d '{"id":1, "jsonrpc":"2.0", "method": "rpc_methods"}' https://example.com:9933
```


## Setting your identity

This section will guide you through the process of attaching real-world information to your Aleph account.
When you are a validator, you care for your credibility and recognizability as seen by potential nominators. One way of ensuring the trustworthiness of your account is attaching some real-world information to your account, including the display name, email, website, etc.
Additionally, for Testnet, it makes it significantly easier for the Aleph Zero team to verify your submission.
The easiest way to set up attach information to your identity is by using the 'Accounts' -> 'My accounts' section of the Aleph Wallet. After clicking the three dots on the right side of your account row, you will be able to select the 'Set on-chain identity' option. 

<p align="center">
    <img src="https://user-images.githubusercontent.com/94878333/200794342-9f631f1b-975b-4ea7-b4d7-55c20fe7b792.png">
</p>

After clicking it, you will see a form when you can input your information:

<p align="center">
    <img src="https://user-images.githubusercontent.com/94878333/200794673-1d2e087f-c04f-470f-b058-9710ddd8b174.png">
</p>

## Making the node validate

### Syncing your node

Even though we provide database snapshots to speed up the whole process, the database of your node will need to catch up with the state of the blockchain by receiving information about new blocks. Assuming you have already started the node (run the script) and are able to view the logs, you will just need to wait for the node to become fully synced.
As mentioned above, you should be seeing an output similar to this:

<img align="center" src="https://user-images.githubusercontent.com/94878333/200795335-ba118d3b-f21d-4a8e-af9a-de354e3a3a8e.png">

### Creating the stash and bonding

You will need a stash account (holding the majority of the funds) and the controller account that makes transactions on behalf of the stash. Explaining this idea in detail is beyond the scope of this guide but you can find good resources [here](https://wiki.polkadot.network/docs/learn-staking) . One important point to make though is that it is recommended that those two accounts be distinct.

>In order to actually get the required amount of TZERO you can use the [Faucet](https://faucet.test.azero.dev/): 
>
>once you paste your account's address and solve a captcha, it will automatically transfer 25001 TZERO.

Now, let us bond some coins. You will need to navigate to the Network → Staking tab, choose the Account subtab and then select the “+ Stash” button:

<p align="center">
    <img src="https://user-images.githubusercontent.com/94878333/200797106-5054ef56-45dd-458c-9c21-9a996807f1c8.png">
</p>

Next, choose your stash and controller accounts in the appropriate fields and the amount of coins to bond not all :

<p align="center">
    <img src="https://user-images.githubusercontent.com/94878333/200797380-46e189e0-47b2-4d58-8933-6c5daa9072e6.png">
</p>

### Generate session keys

- using curl

```
curl -H "Content-Type: application/json" -d '{"id":1, "jsonrpc":"2.0", "method": "author_rotateKeys"}' http://127.0.0.1:9933
```

copy output

### Set session keys

In the Network → Staking → Accounts section you should see a ‘Set session keys’ option next to the stash you have created earlier. 
when you click it, you should see a popup asking you to paste the key you acquired in the previous step:

<p align="center">
    <img src="https://user-images.githubusercontent.com/94878333/200798356-d8dc9593-aa65-4373-aab5-e49fadb3a274.png">
</p>

### Validate

Again in the Network → Staking → Accounts section: after you have successfully set your keys, you will see the ‘Validate’ button next to your stash. Once you click it, you should see one final popup before you become a validator:

<p align="center">
    <img src="https://user-images.githubusercontent.com/94878333/200798468-ec8322bd-ce12-46d9-ab6c-19b5cacf8d4e.png">
</p>

You need to choose the commission percentage (the higher value you choose, the less incentive the nominators will have to choose you) and you are ready to validate!

### Registering as a validator on Testnet

- Go to https://validators.alephzero.org/
    and enter detail 

- How to Finding PeerId

```
cd aleph-node-runner
./signer.sh
```

output :
>PeerId: 12D3KooWFGUSW3DMq9xxxxxxxxxxxxxxx
>
>Public key: 08011220xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
>
>Signed message: 7f5c63905axxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx