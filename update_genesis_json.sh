#!/bin/bash

CHAIN_ID=$1
ACCOUNT_PASSWORD=$2
ACCOUNT_BALANCE=$3
GAS_LIMIT=$4

# Run geth account new and store the output in a variable
echo "$ACCOUNT_PASSWORD" > password.txt
output=$(geth account new --password password.txt)

account_address=$(echo "$output" | grep -oE '0x[0-9a-fA-F]+')
echo "$account_address" > account_address.txt
secret_key_path=$(echo "$output" | grep -o 'Path of the secret key file: .*' | cut -d ':' -f 2- | tr -d '[:space:]')

# Check if the account address is captured successfully
if [ -z "$account_address" ]; then
  echo "Failed to capture the account address from output:"
  echo "$output"
  exit 1
fi

# Check if the account address is captured successfully
if [ -z "$secret_key_path" ]; then
  echo "Failed to capture the secret key path from output:"
  echo "$output"
  exit 1
fi

account_address_hex=${account_address:2} # Remove the '0x' prefix

# Generate the JSON object for the new account and balance
new_account_json="{\"$account_address_hex\":{\"balance\":\"$ACCOUNT_BALANCE\"}}"

# Generate the extraData field
extra_data="0x$(printf '%064d' 0)$account_address_hex$(printf '%0130d' 0)"

# Update the genesis.json file using Python
python3 -c "
import json

with open('genesis.json', 'r') as f:
    data = json.load(f)

# Set the Chain ID
data['config']['chainId'] = $CHAIN_ID

# Update the alloc field
data['alloc'].update($new_account_json)

# Set the gasLimit
data['gasLimit'] = '$GAS_LIMIT'

# Set the extraData field
data['extradata'] = '$extra_data'

with open('genesis.json', 'w') as f:
    json.dump(data, f, indent=2)
"

echo "Successfully added account balance to genesis.json"
echo "==============================================================================================================="
echo "==============================================================================================================="
echo "==============================================================================================================="
echo "Primary Account Address: $account_address"
echo "Primary Account Secret Key: \"$(cat "$secret_key_path")\""
echo "==============================================================================================================="
echo "==============================================================================================================="
echo "==============================================================================================================="
