## Become a Lite Node

### 1. Configure IP

```
cd inery-node/inery.setup/tools
```

```
nano config.json
```

Added your ip in "LITE_NODE"

```
    "LITE_NODE" : {
        "PEER_ADDRESS" : "<YOUR-IP>:9010",
        "HTTP_ADDRESS": "0.0.0.0:8888",
        "HOST_ADDRESS": "0.0.0.0:9010"
    },
```

Save it (ctrl+S), Type "Y" and exit (ctrl+X)

### 2. Start blockchain protocol

```
cd inery-node/inery.setup
```

```
./ine.py --lite
```

---

*Wait until SYNC*

if you see changes in node it means success

Start Node

```
cd /inery-node/inery.setup/lite.node
```

```
./start.sh
```











