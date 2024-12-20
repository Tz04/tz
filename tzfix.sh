#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to check if command executed successfully
check_status() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[+] Success${NC}"
    else
        echo -e "${RED}[-] Failed${NC}"
        exit 1
    fi
}

# Function to prompt for private key
get_private_key() {
    read -p "Enter your EVM Private Key: " PRIVATE_KEY
    if [ -z "$PRIVATE_KEY" ]; then
        echo -e "${RED}Error: Private key cannot be empty${NC}"
        exit 1
    fi
}

# Fixed port configuration
PORT=10880

# Main installation process
echo -e "\n${YELLOW}[1/4] Installing Prerequisites...${NC}"
sudo ufw allow ${PORT}/tcp
check_status

echo -e "\n${YELLOW}Updating system packages...${NC}"
sudo apt update && sudo apt upgrade -y
check_status

echo -e "\n${YELLOW}Installing required packages...${NC}"
sudo apt install curl tar wget aria2 clang pkg-config libssl-dev jq build-essential -y
check_status

echo -e "\n${YELLOW}[2/4] Installing Docker...${NC}"
if command -v docker &> /dev/null; then
    echo -e "${GREEN}Docker already installed${NC}"
else
    sudo apt install docker.io -y
    sudo systemctl start docker
    sudo systemctl enable docker
    check_status
fi

echo -e "\n${YELLOW}Installing Docker Compose...${NC}"
sudo curl -L "https://github.com/docker/compose/releases/download/v2.30.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
check_status

echo -e "\n${YELLOW}Checking Docker version...${NC}"
docker --version
check_status

echo -e "\n${YELLOW}[3/4] Setting up Glacier Node...${NC}"
mkdir -p glacier && cd glacier
git clone https://github.com/Glacier-Labs/node-bootstrap
cd node-bootstrap
check_status

# Get user input
get_private_key

# Create config.yaml
echo -e "\n${YELLOW}Creating config.yaml...${NC}"
cat > config.yaml << EOF
Http:
  Listen: "127.0.0.1:${PORT}"
Network: "testnet"
RemoteBootstrap: "https://glacier-labs.github.io/node-bootstrap/"
Keystore:
  PrivateKey: "${PRIVATE_KEY}"
TEE:
  IpfsURL: "https://greenfield.onebitdev.com/ipfs/"
EOF
chmod 600 config.yaml
check_status

# Create testnet.yaml
echo -e "\n${YELLOW}Creating testnet.yaml...${NC}"
cat > testnet.yaml << EOF
Network: "testnet"
Bootstrap:
  ...
EOF
chmod 600 testnet.yaml
check_status

echo -e "\n${YELLOW}[4/4] Running Glacier Verifier...${NC}"
docker run -d \
  --name glacier-verifier \
  -e PRIVATE_KEY="${PRIVATE_KEY}" \
  -v $(pwd)/config.yaml:/app/config.yaml \
  -v $(pwd)/testnet.yaml:/app/testnet.yaml \
  -p ${PORT}:${PORT} \
  docker.io/glaciernetwork/glacier-verifier:v0.0.2
check_status

echo -e "\n${YELLOW}Checking logs...${NC}"
docker logs -f glacier-verifier

echo -e "\n${GREEN}Installation Complete!${NC}"
echo "============== Mua Vps Lien He @Tz2fa Thanks! ========================"
