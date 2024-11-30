Glacier Node Auto Installation Script
This script automates the installation process of the Glacier Verifier Node, making it easy to set up and configure your node with minimal manual intervention.

Prerequisites
Ubuntu 20.04 LTS or higher
Sudo privileges
EVM Private Key
BNB Testnet Token (for gas fees)
Registration
Before installing, make sure to register Glacier

Get Testnet BNB
Before running the node, you need to get some testnet BNB for gas fees:

Visit BNB Chain Testnet Faucet
Connect your wallet
Request testnet BNB tokens
Wait for the tokens to appear in your wallet
Quick Installation
Choose one of these methods to download and run the installation script:

Using wget:

wget https://raw.githubusercontent.com/Galkurta/Glacier/refs/heads/main/glacier.sh && chmod +x glacier.sh && sudo ./glacier.sh
Using curl:

curl -fsSL https://raw.githubusercontent.com/Galkurta/Glacier/refs/heads/main/glacier.sh -o glacier.sh && chmod +x glacier.sh && sudo ./glacier.sh
What the Script Does
Installs Prerequisites:

Updates system packages
Configures firewall
Installs required dependencies
Installs Docker:

Docker Engine
Docker Compose
Checks Docker version
Sets up Glacier Node:

Creates necessary directories
Clones node bootstrap repository
Configures node settings
Runs Glacier Verifier:

Starts Docker container
Sets up configuration files
Initiates the verifier node
Configuration
During installation, you'll be prompted to enter:

Your EVM Private Key
Custom port (default: 10801)
Logs
To view the node logs after installation:

docker logs -f glacier-verifier
Security Notice
Keep your private key secure and never share it
Ensure your server has proper security measures in place
Regularly update your system and the node software
Links
Official Documentation
GitHub Repository
Registration Link
BNB Testnet Faucet
License
This project is licensed under the MIT License - see the LICENSE file for details.

Support
If you find this script helpful, please consider giving it a star on GitHub!

Contact
For support and updates, follow @tz2fa
