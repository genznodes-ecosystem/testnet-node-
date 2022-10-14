<p style="font-size:14px" align="right">
<a href="https://t.me/GenzDrops" target="_blank">Join our telegram <img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/></a>

# HOW TO RUN NODE

Official guide : https://docs.inery.io/docs/category/introduction

## Node Requirements

### Hardware Requirements

<table class="table">
  <thead>
    <tr>
        <th>~</th>  
        <th rowspan>Minimum Requirement</th>
        <th rowspan>Recommended Requirement</th>
    </tr>
   </thead>
   <tbody>
    <tr>
       <td>CPU</td>
       <td>Intel Core i3 or i5</td>
       <td>Intel Core i7-8700 Hexa-Core</td>
    </tr>
    <tr>
       <td>RAM</td>
       <td>4 GB DDR4 RAM</td>
       <td>64 GB DDR4 RAM</td>
    <tr>
       <td>STORAGE</td>
       <td>500 GB HDD</td>
       <td>2 x 1 TB NVMe SSD</td>
    </tr>
    <tr>
       <td>CONNECTION</td>
       <td>100 Mbit/s port</td>
       <td>1 Gbit/s port</td>
    </tr>
</table>

### Software Requirements

<table class="table">
  <thead>
     <tr>
       <th>Minimum Requirement</th>
       <th>Recommended Requirement</th>
     </tr>
  </thead>
  <tbody>
      <tr>
        <td>OS : Ubuntu 16.04</td>
        <td>OS : Ubuntu 18.04 or higher</td>
      </tr>
  </tbody>
</table>

### Required Dependendencies

For building Inery binaries, blockchain requires some software dependencies. The main dependencies are :

* Clang
* CMake
* Boost
* OpenSSL
* LLVM

### Installing Dependencies

To install all required dependencies on ubuntu distribution open terminal and execute the following command:

```
sudo apt-get install -y make bzip2 automake libbz2-dev libssl-dev doxygen graphviz libgmp3-dev \
autotools-dev libicu-dev python2.7 python2.7-dev python3 python3-dev \
autoconf libtool curl zlib1g-dev sudo ruby libusb-1.0-0-dev \
libcurl4-gnutls-dev pkg-config patch llvm-7-dev clang-7 vim-common jq libncurses5
```

---

## Starting a Node

Register account inery :
> [SIGN UP](https://testnet.inery.io/)

Explorer :
> [Explorer Inary](https://explorer.inery.io/ "Explorer Inary")

###  1. Download Node package

```
git clone  https://github.com/inery-blockchain/inery-node
```

### 2. Export bin path

```
cd inery-node
```

### 3.Perms

```
cd inery.setup
```
```
chmod +x ine.py
```
```
./ine.py --export
```
```
cd; source .bashrc; cd -
```

## CHOOSE 1 

RUN LITE NODE :
>[RUN LITE](https://github.com/Genz22/node_run_with_genz/blob/main/INERY-BLOCKCHAIN/Lite%20Node.md)

RUN MASTER NODE :
>[RUN MASTER NODE](https://github.com/Genz22/node_run_with_genz/blob/main/INERY-BLOCKCHAIN/master%20node.md)

## TASK INERY | MASTER NODE

TASK 1 : Master Approval
>[GUIDE TASK 1](https://github.com/Genz22/node-note/blob/main/INERY-BLOCKCHAIN/task-1-inery.md)

TASK 2 : Make urrency and transfer to someone 
>[GUIDE TASK 2](https://github.com/Genz22/Testnet-node/blob/main/INERY-BLOCKCHAIN/task-2-inery.md)




