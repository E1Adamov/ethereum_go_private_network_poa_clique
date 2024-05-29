#!/bin/bash

account_address=$(cat account_address.txt)
# Build the geth ... command by expanding argvs passed to this script and adding --unlock ... --password ...
geth_command="geth ${*} --unlock $account_address --password password.txt"

# Run the command
eval "${geth_command}"
