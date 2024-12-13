# MikroTik SSTP VPN Configurator

## Overview

This script automates the configuration of SSTP (Secure Socket Tunneling Protocol) VPN on MikroTik RouterOS devices. SSTP VPN provides a secure encrypted connection for remote access to your network, making it ideal for remote workers or secure communication between branch offices.

## Usage

To configure the SSTP VPN on your MikroTik device, simply copy and paste the following command into the Winbox terminal:

```plaintext
/tool fetch url="https://raw.githubusercontent.com/cattalurdai/MikroTik-SSTP-VPN-Configurator/main/configurator.rsc" mode=http dst-path=configurator.rsc; /import file-name=configurator.rsc;
```

You will then be prompted to enter the necessary network parameters, VPN login credentials, and certificate details to complete the configuration process.

## Parameters explained

`[REMOTE_NETWORK]:` Specifies the IP address range for VPN clients (the part of the connection which connects to the server). This is important because it determines the virtual network assigned to VPN clients for communication within your network. If unsure, you can accept the default value, but make sure it does not conflict with your local network.

`[VPN_PORT]:` Defines the port through which the SSTP VPN will operate (default is 443). This is crucial for setting up secure communication between the VPN server and clients. The default port is typically used for HTTPS traffic, ensuring compatibility and security. If you have another service or a NAT rule already using this port, the SSTP tunnel will not work.

`[VPN_USERNAME]:` The username required to log into the VPN. This is essential for authenticating users, ensuring that only authorized individuals can access the VPN service. Choose a strong, secure username to enhance security.

`[VPN_PASSWORD]:` The password associated with the VPN username. It is necessary for securing the VPN account and protecting access. Use a strong password to ensure only authorized users can connect.

`[SSL_COUNTRY]:` The country code used for the SSL certificate. This is important for the identity verification of the VPN server during the connection process and for ensuring secure encrypted communication.

`[SSL_STATE]:` The state or province associated with the SSL certificate. It helps further identify the geographical origin of the certificate, providing additional trust and security.

`[SSL_LOCALITY]:` The city or locality for the SSL certificate. This provides more precise location details for the certificate, helping to identify the VPN server’s physical location.

`[SSL_ORG]:` The organization name for the SSL certificate (optional). If used, it identifies the organization behind the SSL certificate, which can increase trustworthiness. You can leave this blank if not applicable.

## Contributions

Contributions, bug reports, and feature requests are welcome! Feel free to fork the repository, make improvements, and submit pull requests.

## Acknowledgements

- This script was created by `ignatiosdev`.
- Inspired by the need for a simple and secure way to configure SSTP VPN on MikroTik routers.

