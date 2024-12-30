#!/bin/bash

# Ensure script is executed with root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root using sudo."
  exit
fi

# Update package lists
sudo apt update

# Install required packages
sudo apt install -y build-essential git screen

# Start a new screen session
screen -dmS t3rn

# Navigate to screen session and execute commands
screen -S t3rn -X stuff "
# Download executor release
wget https://github.com/t3rn/executor-release/releases/download/v0.31.0/executor-linux-v0.31.0.tar.gz

# Extract the downloaded archive
tar -xvzf executor-linux-v0.31.0.tar.gz

# Navigate to the executor directory
cd executor/executor/bin

# Prompt the user to enter their API keys
echo 'Please enter your RPC_ENDPOINTS_ARBT API Key:'
read -r RPC_ENDPOINTS_ARBT_KEY
echo 'Please enter your RPC_ENDPOINTS_OPSP API Key:'
read -r RPC_ENDPOINTS_OPSP_KEY

# Export environment variables
export NODE_ENV=testnet
export LOG_LEVEL=debug
export LOG_PRETTY=false
export EXECUTOR_PROCESS_ORDERS=true
export EXECUTOR_PROCESS_CLAIMS=true
export EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API=false
export RPC_ENDPOINTS_ARBT="$RPC_ENDPOINTS_ARBT_KEY"
export RPC_ENDPOINTS_OPSP="$RPC_ENDPOINTS_OPSP_KEY"
export RPC_ENDPOINTS_L1RN='https://brn.rpc.caldera.xyz'
export PRIVATE_KEY_LOCAL='ENTER YOUR_PRIVATE_KEY'
export ENABLED_NETWORKS='base-sepolia,arbitrum-sepolia,optimism-sepolia,blast-sepolia,l1rn'
export EXECUTOR_MAX_L3_GAS_PRICE=300

# Run the executor
./executor
"
