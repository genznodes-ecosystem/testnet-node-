
<p align="center">
  <img height="200px" widht="auto" src="https://user-images.githubusercontent.com/94878333/198862408-531040d6-e50e-4419-94f2-bd8bcf026e3e.jpg">
</p>  


# Tutorial / guide Berpartisipasi di DeInfra Testnet 

**INTRO** 

Awalnya, kami berencana melakukan seleksi awal. Tapi kami mendapat begitu banyak aplikasi sehingga ternyata di Tahap I saat ini untuk setiap node lebih dari 20 orang telah mendaftar ‼️ Selain itu, kami tidak menyangka akan ada begitu banyak testneter yang benar-benar berpengalaman yang mendatangi kami 🫶

Jadi kami memutuskan untuk membuatnya seperti ini: semua pelamar akan memiliki kesempatan yang sama. Anda masing-masing akan memiliki kesempatan untuk lulus verifikasi melalui Power Rover dan kemudian menantang diri Anda sendiri dalam tugas ujian 👊

Hal yang paling penting. Ini adalah alamat rumah Rover: https://t.me/thepowerio_bot

Temukan detail lebih lanjut di blog di Medium

https://medium.com/the-power-official-blog/deinfra-testnet-verification-and-test-assignment-in-the-community-bot-are-launched-today-b253f397b1fa Semoga Anda semua beruntung , orang-orang! 👐

## Phase 1 DeInfra Testnet

>[OFFICIAL DOCS](https://doc.thepower.io/docs/Community/phase-1/testnet-flow)

**Prasyarat untuk sebuah node :**


- hardware

| CPU cores	| Memory	Hard disk |	Jaringan |
| -- | -- | -- |
| 4	| 4 GB or more	Minimum: 40 GB, SSD preferred	| 100 Mbit/s |

- software 

| OS	| Erlang version	| Eshell version| Docker version	| Server |
| -- | -- | -- | -- | -- |
| Ubuntu 22.04 |	24.3 |	10.4 |	latest (20.10.18 as of September 2022) |	Virtual machine |

### Masuk waitlist

#### 1.selesaika tugas media sosial

- silahkan menyelesaikan tugas di : https://t.me/thepowerio_bot
- klik testnet campaign 
- kerjain task
- done

#### 2.jalankan node lokal

- download and run automatis

```
wget -O start-node.sh https://raw.githubusercontent.com/Genz22/Testnet-node/main/Power-Ecosystem/start-node.sh && chmod +x start-node.sh && ./start-node.sh
```

- cek docker 

```
docker ps -a
```

- cek node 

```
curl http://localhost:44000/api/node/status | jq
```

- kirimkan di bot pastikan dengan format yang di minta rover bot

```
http://YourIP:44000/api/node/status
```

anda bisa mematikan node jika sudah masuk dalam waitlist

### Tea Ceremony client and token | jalankan tea-client

pastikan anda mendapat token yang dikirim oleh **rover bot**

#### 1. Jalanlan tea-client

- Install screen

```
sudo apt install screen
```

- download teaclient

```
wget https://tea.thepower.io/teaclient
```

- Berikan permisi

```
chmod +x teaclient
```

- jalankan tea-client

```
screen -R client
```

```
./teaclient -n <nama node> <token anda>
```

lalu biarkan berjalan sampai semua peserta menjalankan tea-client mungkin 24 jam +-

`CTRL A + D` untuk menutup screen dan berjalan di backgroud

- cek logs tea-client

```
screen -rd client
```

jika semua peserta sudah menjalankan tea-client anda akan mendapat dua file :

1 . node.config

2 . genesis.txt


### Build thepower node dan menjalankannya

**Penting:**

1. pastikan anda mempunya node.config dan genesis.txt
2. menyelsaikan perintah bot rover

Ada dua cara untuk menjalankan thepower:

1. **docker** -- rekomendasi untuk anda bisa lihat di official dockument 👉👉 [LINK](https://doc.thepower.io/docs/Community/phase-1/download-build-run-docker)
2. source code

#### 1 . VIA DOCKER 

>[OFFICIAL](https://doc.thepower.io/docs/Community/phase-1/download-build-run-docker)


#### 2 . VIA SOURCE CODE

##### syarat

1 . pastikan anda menggunakan UBUNTU OS 22.04 
2 . Erl 24

- Download script dan jalankan otomatis

```
wget -O thepower.sh https://raw.githubusercontent.com/Genz22/Testnet-node/main/Power-Ecosystem/thepower.sh && chmod +x thepower.sh && ./thepower.sh
```

- buat direktori db dan log

```
cd /opt/thepower
```

```
mkdir {db.log}
```

- salin node.config dan genesis

```
cp ~/node.config /opt/thepower/node.config
cp ~/genesis.txt /opt/thepower/genesis.txt
```

- edit node.config

```
nano /opt/thepower/node.config
```

seperi contoh dibawah ini anda bisa merubah seusai kebutuhan :

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

##### Mendapatkan sertifikat 

- download acme.sh

```
cd $HOME
apt-get install socat
curl https://get.acme.sh | sh -s email=my@example.com
```

- keluar terminal
- login lagi

dan reload bashrc

```
source ~/.bashrc
```

- obtain sertifikat

```
acme.sh --server letsencrypt --issue --standalone -d <name host> \
--renew-hook "cd /opt/thepower; ./stop.sh; ./start.sh"
```

- Install sertifikat

```
acme.sh --install-cert -d <host name> \
--fullchain-file /opt/thepower/db/cert/<host name>.crt \
--key-file /opt/thepower/db/cert/<host name>.key
```

- dapatkan sertifikat 

```
acme.sh --info -d <host name>
```

##### Jalankan node 

- jalankan node

```
systemctl restart powerd
journalctl -fu powerd -o cat
```

- cek status sistem

```
systemctl status powerd
```

- cek node

```
curl http://localhost:1080/api/node/status | jq
```

- cek sertifikat ssl jika berfungsi

```
https://<host name>:1443/api/node/status
``` 

dan buka di browser anda 

akan seperti ini :

<img src="https://user-images.githubusercontent.com/94878333/201460184-6bc4877f-1486-439b-a3cc-51c543c539a8.png">

Explore :

https://zabbix.thepower.io/zabbix.php?action=dashboard.view


- selesaikan task bot

<img src="https://user-images.githubusercontent.com/94878333/201459717-a973bac9-5ffc-4848-b40f-6fd16afd7474.png">

====== DONE ======
