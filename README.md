# MikroTik SSTP VPN Configurator

## Overview

This script automates the configuration of SSTP (Secure Socket Tunneling Protocol) VPN on MikroTik RouterOS devices. SSTP VPN provides a secure encrypted connection for remote access to your network, making it ideal for remote workers or secure communication between branch offices.

## Usage

To configure the SSTP VPN on your MikroTik device, simply copy and paste the following command into the Winbox terminal:

```plaintext
/tool fetch url="https://raw.githubusercontent.com/cattalurdai/MikroTik-SSTP-VPN-Configurator/main/configurator.rsc" mode=http dst-path=configurator.rsc; /import file-name=configurator.rsc;
```

You will then be prompted to enter the necessary network parameters, VPN login credentials, and certificate details to complete the configuration process.

## Contributions

Contributions, bug reports, and feature requests are welcome! Feel free to fork the repository, make improvements, and submit pull requests.

## Acknowledgements

- This script was created by Cattalurdai.
- Inspired by the need for a simple and secure way to configure SSTP VPN on MikroTik routers.

