# Welcome to the PROTON MainNet [manual node installation]

Chain ID:  384da888112027f0321850a169f737c33e53b388aad48b5adace4bab97f437e0  
Based on tag: 3.2.3

Please join out PROTON MainNet <a target="_blank" href="https://t.me/">Telegram channel</a>  
Network Monitor: https://monitor.protonchain.com/  


! This repo is for binary installation.  

**Proton is a protocol built on top of the Antelope (EOSIO) consensus layer that allows verified user identity and applications to generate signature requests (transactions) that can be pushed to signers (wallets) for authentication and signature creation. These signature requests can be used today to authenticate and sign cryptographic payments. The same architecture will be used in future version to initiate and track pending fiat transactions**

To start a Proton node you need install Leap software. You can compile from sources or install from precompiled binaries:  

## Important Update

Proton Consortium is requesting all Block Producers to update their nodes to the latest version of Leap (3.2.3) by 30 June 2023. This update is required to ensure the stability of the Proton Mainnet.

Please contact us on Telegram if you have any questions: https://t.me/ProtonTestnet


# 1. Installing
---------------------------------------------------  

# 1.1 Installing from precompiled binaries  

A. Download the latest version of EOSIO for your OS from:  
https://github.com/AntelopeIO/leap/releases/tag/v3.2.3
For example, for ubuntu 22.04 you need to download deb leap_3.2.3-ubuntu22.04_amd64.deb


To install it you can use apt:  
```
sudo apt-get update
sudo apt install ./leap_3.2.3-ubuntu22.04_amd64.deb
```
It will download all dependencies and install Leap  

---------------------------------------------------------  
# 2. Update software to new version  

If upgrading from old 2.X or 3.X versions please see this important guide 
https://eosnetwork.com/blog/leap-3-1-upgrade-guide/

# 2.2 Update binaries  

To upgrade precompiled installation pleasse folow the same steps as in 1.1 (Installation from precompiled)  

------------------------------------------------------------------  

# 3. Install PROTON MainNet node [manual]  
    
```
    mkdir /opt/ProtonMainNet
    cd /opt/ProtonMainNet
    git clone https://github.com/ProtonProtocol/proton.start.git ./

```

- In case you use a different data-dir folders -> edit all paths in files cleos.sh, start.sh, stop.sh, config.ini, Wallet/start_wallet.sh, Wallet/stop_wallet.sh  

- NODEOSBINDIR="/usr/bin"

- The first thing you will need to do is download the Wallet (the link will be soon) and create a new PROTON mainnet account.

- To register as Block Producer you should go to the <a target="_blank" href="https://permission.protonchain.com/">Permission Portal</a> login and request permission to regproduse  
  when you got this permission and you finish prepare node you can run command 
  ```
  ./cleos.sh system regproducer YOU_ACCOUNT PUBKEY "URL" LOCATION -p YOU_ACCOUNT
  ```

- If non BP node: use the same config, just comment out rows with producer-name and signature-provider  
  
- Edit config.ini:  
  - server address: p2p-server-address = ENRT_YOUR_NODE_EXTERNAL_IP_ADDRESS:9876  

  - if BP: your producer name: producer-name = YOUR_BP_NAME  
  - if BP: add producer keypair for signing blocks (this pub key should be used in regproducer action):  
  signature-provider = YOUR_PUB_KEY_HERE=KEY:YOUR_PRIV_KEY_HERE  
  - replace p2p-peer-address list with fresh generated on monitor site: https://monitor.protonchain.com/#p2p  
  - Check chain-state-db-size-mb value in config, it should be not bigger than you have RAM:  
    chain-state-db-size-mb = 16384  
  
- Open TCP Ports (8888, 9876) on your firewall/router  


- Start wallet, run  
```
cd /opt/ProtonMainNet
./Wallet/start_wallet.sh
```

**First run should be with --delete-all-blocks and --genesis-json**  
```
cd /opt/ProtonMainNet/protonNode
./start.sh --delete-all-blocks --genesis-json genesis.json
```  
Check logs stderr.txt if node is running ok. 


- Create your wallet file  
```
./cleos.sh wallet create --to-file pass.tx
```
Your password will be in pass.txt it will be used when unlock wallet  


- Unlock your wallet  
```
./cleos.sh wallet unlock
```
enter the wallet password.  


- Import your key  
```
./cleos.sh wallet import
```
Enter your private key  



- Check if you can access you node using link http://you_server:8888/v1/chain/get_info (<a href="https://proton.cryptolions.io/v1/chain/get_info" target="_blank">Example</a>)  


==============================================================================================  

# 4.1 Restore/Start from Backup
   Download latest block and state archive for your OS from http://backup.cryptolions.io/ProtonMainNet/
   
   ```
   wget http://backup.cryptolions.io/ProtonMainNet/ubuntu18/latest-blocks.tar.gz
   wget http://backup.cryptolions.io/ProtonMainNet/ubuntu18/latest-state.tar.gz
   ```
   After downloaded extract their
   ```
   tar xzvf blocks-latest.tar.gz -C .
   tar xzvf state-latest.tar.gz -C .
   ```
   You got two folders block and state.  
   Ater that go to **NODE** folder, and remove files from folder blocks and state
   ```
   cd /opt/ProtonMainNet/protonNode
   rm blocks/*
   rm state/*
   ```
   After that go where you extracted archive and move file from folder 
   ```
   mv ~/blocks/* /opt/ProtonMainNet/protonNode/blocks/
   mv ~/state/* /opt/ProtonMainNet/protonNode/state/
   ```
   After files moved start your NODE
   ```
   ./start.sh
   ```
# 4.2 Restore/Start from Snapshots
   Download latest snapshot from http://backup.cryptolions.io/ProtonMainNet/snapshots/ to snapshots folder in your **NODE** directory
   ```
   mkdir /opt/protonMainNet/protonNode/snapshots
   cd /opt/protonMainNet/protonNode/snapshots/
   wget http://backup.cryptolions.io/ProtonMainNet/snapshots/latest-snapshot.bin.zst
   ```
   after it downloaded, extract and copy to /snapshots then run `start.sh` script with option `--snapshot` and snapshot file path
   ```
   sudo apt-get install zstd
   unzstd latest-snapshot.zst
   cd /opt/ProtonMainNet/protonNode
   ./start.sh --snapshot /opt/ProtonMainNet/protonNode/snapshots/latest-snapshot.bin
   ```
 ---

# Other Tools/Examples  

- Cleos commands:  

Send XPR
```
./cleos.sh transfer <your account> <receiver account> "1.0000 XPR" "test memo text"
```
Get Balance  
```
./cleos.sh get currency balance eosio.token <account name>
```
Create account  
```
./cleos.sh system newaccount --stake-net "10.0000 XPR" --stake-cpu "10.0000 XPR" --buy-ram-bytes 4096 <your accountr> <new account> <pkey1> <pkey2>
```  
List registered producers (-l <limit>)  
```
./cleos.sh get table eosio eosio producers -l 100
```
List your last action (use -h to get help, do not work now, works with history node only)  
```
./cleos.sh get actions <account name>
```
  
List staked/delegated  
```
./cleos.sh system listbw <account>
```
## PROTON MAINNET P2P

```
api.protonnz.com:9876
proton.protonuk.io:9876
proton.p2p.eosusa.io:9879
proton.cryptolions.io:9876
main.proton.kiwi:9786
protonp2p.eoscafeblock.com:9130
p2p.alvosec.com:9876
p2p.protonmt.com:9876
p2p.totalproton.tech:9831
mainnet.brotonbp.com:9876
p2p.proton.bountyblok.io:29876
proton.eu.eosamsterdam.net:9103
protonp2p.blocksindia.com:9876
p2p-protonmain.saltant.io:9876
protonp2p.ledgerwise.io:23877
peer1.proton.pink.gg:48011
peer2.proton.pink.gg:48011
proton-seed.eosiomadrid.io:9876
proton.edenia.cloud:9879
proton.genereos.io:9876
p2p.proton.detroitledger.tech:1337
p2p.proton.eosargentina.io:9877
peer-proton.nodeone.network:9870
p2p.proton.eoseoul.io:39876
proton-public.neftyblocks.com:19876
p2p-proton.eosarabia.net:9876
```


## PROTON MAINNET API
```
https://api.protonnz.com
https://proton.protonuk.io
https://proton.eosusa.io
https://proton.cryptolions.io
https://main.proton.kiwi
https://proton.eoscafeblock.com
https://proton-api.alvosec.com
https://api.protonmt.com
https://api.totalproton.tech
https://mainnet.brotonbp.com
https://api.proton.bountyblok.io
https://proton.eu.eosamsterdam.net
https://protonapi.blocksindia.com/
https://aa-proton.saltant.io
https://protonapi.ledgerwise.io
https://proton.api.atomicassets.io
https://proton.pink.gg
https://proton-api.eosiomadrid.io
https://proton.edenia.cloud
https://proton.genereos.io
https://api.proton.detroitledger.tech
https://proton.eosargentina.io
https://api-proton.nodeone.network:8344
https://proton.eoseoul.io
https://proton-public.neftyblocks.com
https://api-proton.eosarabia.net
```

**Network Monitor**  
https://monitor.protonchain.com/
 
**Hyperion History**  
https://proton.cryptolions.io/v2/docs  
https://proton.eosusa.news/v2/docs/index.html  
https://proton-hyperion.eoscafeblock.com/v2/docs/index.html

**Block Explorers**   
https://proton.bloks.io/  

**Permissions**    
https://permission.protonchain.com

--------------  

# Backups
### Full(blocks and states):
  * [Ubuntu 18](http://backup.cryptolions.io/ProtonMainNet/ubuntu18/)  
  
### Snapshot:
  * [Snapshots](http://backup.cryptolions.io/ProtonMainNet/snapshots/)

--------------
