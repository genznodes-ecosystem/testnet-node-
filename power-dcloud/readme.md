![photo_2022-10-30_11-19-09](https://user-images.githubusercontent.com/94878333/198862408-531040d6-e50e-4419-94f2-bd8bcf026e3e.jpg)





# Participant in DeInfra Testnet

Powerians 🖐

Today we’re launching our Community bot who called itself Power Rover and putting you in its hands 🚀

Initially, we planned to do a pre-selection. 
But we got so many applications that it turned out that in the Phase I at the moment for each node more than 20 people have applied ‼️
Furthermore, we did not expect that so many really experienced testneters would come to us 🫶

So we decided to make it this way: all applicants will have an equal opportunity. 
Each of you will have the opportunity to pass the verification via Power Rover and then challenge yourself in the test assignment 👊

The most important thing. This is Rover’s home address: https://t.me/thepowerio_bot 

Find more details in blog on Medium

https://medium.com/the-power-official-blog/deinfra-testnet-verification-and-test-assignment-in-the-community-bot-are-launched-today-b253f397b1fa We wish each of you good luck, folks! 👐

-------------------------

guide in INDONESIAN 👇👇
>[INDONESIAN](https://github.com/Genz22/Testnet-node/blob/main/Power-Ecosystem/IDreadme.md)


# First need go to bot and complete task

- bot : https://t.me/thepowerio_bot
- click : testnet campaign
- complete task 

## phase waitlist

**Rules for DeInfra Testnet participants:**

1. Use virtual servers instead of local PC to be sure it will be working and online all the time
2. Check our prerequisites for hardware, software and environment
3. Pass our test assignment to validate your tech skills
4. Important: DO NOT change the IP address of your server throughout the testnet campaign
5. You have to maintain a minimum of 50% of node uptime on a monthly basis to be awarded with points (minimum for 3 months from the start of their specific Chain)
6. Follow our Telegram chat, Twitter and GitHub for the entire period of DeInfra Testnet

### Run local node to enter waitlist 

- Download and run ( automatic ) 

```
wget -O start-local-node.sh https://raw.githubusercontent.com/Genz22/Testnet-node/main/Power-Ecosystem/start-local-node.sh && chmod +x start-local-node.sh && ./start-local-node.sh
```

- check docker 

```
docker ps
```

- Check node

```
curl http://<YOUR IP>:44000/api/node/status | jq
```

- send to bot

```
http://YourIP:44000/api/node/status
```

bot will confirm and added you in testnet waitlist so waiting for tea-client token form bot 
to proceed to the next step


you can stop node

----------------------------------------------

### Get the Tea Ceremony client and token | start tea-client

- install screen 

```
sudo apt install screen 
```

- Get the Tea Ceremony client

```
wget https://tea.thepower.io/teaclient
```

- Give perms

```
chmod +x teaclient
```

- Start client

if u get token from bot 


**example :** 

![Screenshot (269)](https://user-images.githubusercontent.com/94878333/198863606-4f532a1c-699c-43d2-83df-edbac2056827.jpg)

next ..

You can run teaclient 

```
screen -R client
```

```
./teaclient -n <node name> <token>
```

- close 

`CTRL A + D`

If using Ubuntu 20 and an error occurs when running the script then you need to install erlang with:

```
sudo apt update && sudo apt upgrade -y
sudo apt install curl wget gnupg apt-transport-https -y
curl -fsSL https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc | sudo gpg --dearmor -o /usr/share/keyrings/erlang.gpg
echo "deb [signed-by=/usr/share/keyrings/erlang.gpg] https://packages.erlang-solutions.com/ubuntu $(lsb_release -cs) contrib" | sudo tee /etc/apt/sources.list.d/erlang.list && sudo apt update
sudo apt install erlang -y
```

check erlang with

```
erl
```

waiting for all participants to finish teaclient

- check logs teaclient

```
screen -rd client
```

close `CTRL A + D`

and you got :
- node.config 
- genesis.txt

save file nad backup

---------------------------------------

## Build thepower node and run

>**important before building node** 🧨 :
>
>- you already have node.config and genesis
>
>- follow rover bot

Here you have two options:

- Download ThePower node using the Docker (recommended for most users),
>[OFFICIAL DOCS](https://doc.thepower.io/docs/Community/phase-1/download-build-run-docker)


- Download the source code and build it (only for advanced users). Recommended to use Ubuntu 22
>[OFFICIAL DOCS](https://doc.thepower.io/docs/Community/phase-1/download-build-run-source)

-------------------------------------------------------------------------------------

### Build from docker

>[docker (recommended)](https://doc.thepower.io/docs/Community/phase-1/download-build-run-docker)

### Build from source code

Pre-requiretments :

1. Erlang 24 or more
2. Node.config and genesis.txt

#### automatic build node

```
wget -O thepower.sh https://raw.githubusercontent.com/Genz22/Testnet-node/main/Power-Ecosystem/thepower.sh && chmod +x thepower.sh && ./thepower.sh
```

#### create directory and edit node.config

```
cd /opt/thepower
```

```
mkdir {db.log}
```

copy genesis and node.config to thepower

```
cp ~/node.config /opt/thepower/node.config
cp ~/genesis.txt /opt/thepower/genesis.txt
```

edit node.config

```
nano /opt/thepower/node.config
```

save your private_key

edit with example :

```
{tpic, #{
    peers => [
        {"<host members>", <port>},
        {"<host members>", <port>},
        {"<host members>", <port>},
        {"<host members>", <port>},
        {"<host members>", <port>},
        {"<host members>", <port>},
        {"<host members>", <port>},
        {"<host members>", <port>},
        {"<host members>", <port>},
        {"<host members>", <port>}
        ],
    allow_rfc1918 => true,
    port => <port chain use>} }.
{discovery,
    #{
        addresses => [
            #{address => "<HOST_NAME>", port => <port>, proto => tpic},
            #{address => "<HOST_NAME>", port => 1080, proto => api},
            #{address => "<HOST_NAME>", port => 1443, proto => apis}
        ]
    }
}.

{hostname, "<HOST_NAME>"}.
{dbsuffix,""}.
{loglevel, info}.
{info_log, "log/info.log"}.
{error_log, "log/error.log"}.
{debug_log, "log/debug.log"}.
{rpcsport, 1443}.
{rpcport, 1080}.

{privkey, "<PRIVATE_KEY>"}.
```

#### Get ssl

- get acme.sh

```
cd
apt-get install socat
curl https://get.acme.sh | sh -s email=my@example.com
```

- close terminal 

- login again

```
source ~/.bashrc
```

- Obtain the certificate

```
acme.sh --server letsencrypt --issue --standalone -d <name host> \
--renew-hook "cd /opt/thepower; ./stop.sh; ./start.sh"
```

- Install the certificate

```
acme.sh --install-cert -d <host name> \
--fullchain-file /opt/thepower/db/cert/<host name>.crt \
--key-file /opt/thepower/db/cert/<host name>.key
```

- get certificate

```
acme.sh --info -d <your node.example.com>
```

#### run node

```
systemctl restart powerd
journalctl -fu powerd -o cat
```

#### check node

```
curl http://localhost:1080/api/node/status | jq
```

#### check ssl 

- open your browser

```
https://<host name>:1443/api/node/status
```

>example : https://c1026n3.thepower.io:1443/api/node/status
<img height="auto" width="auto" src="https://user-images.githubusercontent.com/94878333/201460184-6bc4877f-1486-439b-a3cc-51c543c539a8.png">

Explore :
https://zabbix.thepower.io/zabbix.php?action=dashboard.view

find your host ..

#### complete rover bot

<img src="https://user-images.githubusercontent.com/94878333/201459717-a973bac9-5ffc-4848-b40f-6fd16afd7474.png">

