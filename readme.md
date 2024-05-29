# Description

This guide will help you set up an Ethereum private network using the Geth client in Docker. The network uses the Proof-of-Authority (PoA) consensus algorithm, specifically Clique, which is suitable for testing as it consumes minimal processor power.

We will use the `ethereum/client-go:v1.10.7-arm64` image. If you need a different architecture, you can find other images [here](https://hub.docker.com/r/ethereum/client-go/tags). Note that later versions may require Proof-of-Stake (PoS) consensus, which is not covered in this guide.

## Configuring the Network
in the [.env file](.env) you can configure certain networks settings

> `CHAIN_ID` - the Ethereum network ID  
> `ACCOUNT_PASSWORD` - the primary account password  
> `ACCOUNT_BALANCE` - initial balance for the primary account  
> `GAS_LIMIT` - initial gas limit for the network

## Building the Docker Image and Running the Network
To build the Docker image and spin the network, run the following command:

```shell
docker-compose down && docker-compose build --no-cache --progress plain && docker-compose up -d
```

## Decrypting the Private Key with Python
First, copy the Secret Key from the build output. It should look like this:
```text
{"address":"604cb59fcce79e73e20c7a3066bff64d63bdf06a","crypto":{"cipher":"aes-128-ctr","ciphertext":"f4b0b223795c3e7cce2b8b6880bb547f5dd54f7311674159bec58c0311cf0d30","cipherparams":{"iv":"6d017530295fdc478ad83721415e2f3a"},"kdf":"scrypt","kdfparams":{"dklen":32,"n":262144,"p":1,"r":8,"salt":"5e57b9f32a6898396a8b6a4080d1494b43d9cd0d231d3b14c744a6e738b4ee81"},"mac":"eed84d637fa9f67060c8b4c5e9f87837cedbe1d79c2278907376eea994c6a78b"},"id":"85d1f152-a487-4aaf-bea7-ef5cda01438c","version":3}

```

Then, install the necessary Python package:
```shell
pip install web3
```  

Then, use the following Python script to decrypt the private key:
```python
from web3.auto import w3

encrypted_key = '<secret key from the build output>'
password = '5uper53cr3t'  # must match the ACCOUNT_PASSWORD in the .env file
private_key = w3.eth.account.decrypt(encrypted_key, password)
print(private_key.hex())
```