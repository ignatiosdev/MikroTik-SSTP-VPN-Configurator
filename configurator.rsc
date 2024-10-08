{
    :put ""
    :put "- Welcome to SSTP VPN CONFIGURATOR -"
    :put ""

    :local defaultRemoteNetwork "192.168.150.0/24";
    :put "Enter the network assigned to VPN clients (press enter to use default: $defaultRemoteNetwork): ";
    :local input1 do={:return};
    :local remoteNetwork [$input1];
    :if ([:len $remoteNetwork] = 0) do={
        :set remoteNetwork $defaultRemoteNetwork;
    }

    :local defaultVpnPort "443";
    :put "Enter the VPN port (press enter to use default: $defaultVpnPort): ";
    :local input2 do={:return};
    :local vpnPort [$input2];
    :if ([:len $vpnPort] = 0) do={
        :set vpnPort $defaultVpnPort;
    }

    :local vpnUsername;
    :while ([:typeof $vpnUsername] = "nothing" || [:len $vpnUsername] = 0) do={
        :put "Enter the VPN username: ";
        :local input3 do={:return};
        :set vpnUsername [$input3];
    }

    :local vpnPassword;
    :while ([:typeof $vpnPassword] = "nothing" || [:len $vpnPassword] = 0) do={
        :put "Enter the VPN password: ";
        :local input4 do={:return};
        :set vpnPassword [$input4];
    }

    :local country;
    :while ([:typeof $country] = "nothing" || [:len $country] = 0) do={
        :put "Enter the country for SSL certificate (e.g., US): ";
        :local input5 do={:return};
        :set country [$input5];
    }

    :local state;
    :while ([:typeof $state] = "nothing" || [:len $state] = 0) do={
        :put "Enter the state for SSL certificate (e.g., California): ";
        :local input6 do={:return};
        :set state [$input6];
    }

    :local locality;
    :while ([:typeof $locality] = "nothing" || [:len $locality] = 0) do={
        :put "Enter the locality for SSL certificate (e.g., San Francisco): ";
        :local input7 do={:return};
        :set locality [$input7];
    }

    :local organization;
    :while ([:typeof $organization] = "nothing" || [:len $organization] = 0) do={
        :put "Enter the organization for SSL certificate (e.g., Github): ";
        :local input8 do={:return};
        :set organization [$input8];
    }

    #### SCRIPT ###
    :put ""
    :put "--- STARTING CONFIGURATOR ---"

    :local backupName ("before-vpn-configurator")
    :put "Creating backup..." 
    /system backup save name=$backupName
    :put "[BACKUP] Backup created with name: $backupName, use it to revert this script"
    :put ""
    :put ""

    # Enable DDNS
    :if ( [/ip cloud get ddns-enabled] = true ) do={
        :put "DDNS already enabled"
    } else={
        :put "DDNS is not enabled, enabling..."
        /ip cloud set ddns-enabled=yes
        # Wait for cloud to be enabled
        :delay 10s
    }
    :put ""

    # Get Cloud Address
    :local cloudAddress [/ip cloud get dns-name]
    :put "Cloud DNS Name: $cloudAddress"
    :put ""
    
        # CREATE SSL CERTIFICATE
    :put "Checking for existing certificates..."

    # Check if client and server certificates already exist
    :local clientCert [/certificate find where name="SSTPCONFIGURATOR_CLIENTCA"]
    :local serverCert [/certificate find where name="SSTPCONFIGURATOR_SERVERCA"]

    # If no client certificate exists, it returns an empty array (no ID)
    :if ([:len $clientCert] = 0) do={
        :put "Client certificate does not exist. Creating new client certificate..."
        /certificate 
        add name=SSTPCONFIGURATOR_CLIENTCA common-name=$cloudAddress country=$country state=$state locality=$locality organization=$organization key-usage=key-cert-sign,crl-sign
        sign SSTPCONFIGURATOR_CLIENTCA
    } else={
        :put "Client certificate already exists."
    }

    :delay 2s

    # If no server certificate exists, it returns an empty array (no ID)
    :if ([:len $serverCert] = 0) do={
        :put "Server certificate does not exist. Creating new server certificate..."
        /certificate 
        add name=SSTPCONFIGURATOR_SERVERCA common-name=$cloudAddress country=$country state=$state locality=$locality organization=$organization key-usage=digital-signature,key-encipherment,tls-server
        sign SSTPCONFIGURATOR_SERVERCA ca=SSTPCONFIGURATOR_CLIENTCA
    } else={
        :put "Server certificate already exists."
    }

    :delay 10s
    :put "SSL Certificates check complete."
    :put ""


    
    # CREATE IP POOL
    :local ipBase [:pick $remoteNetwork 0 ([:find $remoteNetwork "/"] - 1)]
    :local ipRange ($ipBase . "2-" . $ipBase . "254")
    /ip pool add name=vpn-pool ranges=$ipRange
    :put "VPN IP Pool created successfully"
    :put ""

    # CREATE VPN PROFILE
    /ppp profile add name=vpn-profile local-address=($ipBase . "1") remote-address=vpn-pool
    :put "VPN Profile created successfully"
    :put ""

    # ENABLE SSTP VPN
    /interface sstp-server server set enabled=yes certificate=SSTPCONFIGURATOR_SERVERCA default-profile=vpn-profile tls-version=only-1.2 port=$vpnPort
    :put "SSTP VPN enabled successfully on port $vpnPort"
    :put ""

    # CREATE VPN USER
    /ppp secret add name=$vpnUsername password=$vpnPassword profile=vpn-profile
    :put "VPN User created successfully"
    :put ""

    # CREATE MASQUERADE RULE FOR VPN
    /ip firewall nat add chain=srcnat action=masquerade src-address=$remoteNetwork
    :put "Masquerade rule for VPN created successfully"
    :put ""

    # CREATE FIREWALL FILTER INPUT RULE
    /ip firewall filter add chain=input action=accept protocol=tcp dst-port=$vpnPort place-before=3
    :put ""

    # EXPORT CLIENT CERTIFICATE
    /certificate export-certificate SSTPCONFIGURATOR_CLIENTCA
    :put "Exported client certificate"
    :put ""

    :put ""
    :put ""
    :put ""
    :put ""
    :put ""
    :put ""
    :put "[SUCCESS] SSTP VPN CONFIGURED"
    :put "The client certificate is waiting in the files section for you to download"
    :put ""
    :put "- github.com/ignatiosdev -"
}
