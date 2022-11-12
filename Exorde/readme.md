
<p align="center">
    <img src="https://user-images.githubusercontent.com/94878333/201456741-83102140-4c54-417e-82e1-098011777def.jpg">
</p>


# Joined Exorde  INCENTIVIZED

- update 

```
sudo apt update && sudo apt upgrade -y
```

- install docker && dependencies

```
apt install git libssl-dev clang cmake make curl automake autoconf libncurses5-dev -y
```

```
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update && sudo apt install docker-ce docker-ce-cli docker.io
```

```
docker --version
```

## build  node and run

- clone 

```
git clone https://github.com/exorde-labs/ExordeModuleCLI.git
```

```
cd ExordeModuleCLI
```

- build 

```
docker build -t exorde-cli . 
```

wait ...

and 
- run 

```
docker run -d -e PYTHONUNBUFFERED=1 exorde-cli -m `wallet 0x` -l 2
```

## commads 

- check container

```
docker ps
```

- check logs 

```
docker logs -f (container ID)
```

- cloce 

```
CTRL + C
```

