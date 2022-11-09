
<p align="center">
  <img height="100" height="auto" src="/assets/Untitled.png">
</p>

# Running an Aleph Node on Testnet

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
