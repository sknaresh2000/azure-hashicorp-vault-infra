#!/usr/bin/bash

# Download Vault
wget https://releases.hashicorp.com/vault/${vault_version}/vault_${vault_version}_linux_386.zip

# Unzip Vault
unzip vault_${vault_version}_linux_386.zip

# Get vm ip from IMDS
export cluster_ip="$(curl -sH Metadata:true --noproxy '*' 'http://169.254.169.254/metadata/instance/network/interface/0/ipv4/ipAddress/0/privateIpAddress?api-version=2020-09-01&format=text')"

# Move vault to desired path
mv vault /usr/bin/vault

#Configure Vault config file
mkdir /etc/vault.d
echo '${vault_config}' | sed \
-e "s/sa_account_name/${sa_account_name}/g" \
-e "s/sa_container_name/${sa_container_name}/g" \
-e "s/vault_tenant_id/${tenant_id}/g" \
-e "s/kv_name/${kv_name}/g" \
-e "s/kv_key_name/${kv_key_name}/g" \
-e "s/vault_cluster_name/${cluster_name}/g" \
-e "s/vault_cluster_ip/$cluster_ip/g" > /etc/vault.d/vault.hcl

# Configure Vault service
echo '${vault_service_config}' > /lib/systemd/system/vault.service

# Configure firewall ports 
firewall-offline-cmd --add-port=8200/tcp

# Create vault user and group to run the service
groupadd vault
useradd -g vault vault

# Set vault.hcl to be readable by the vault group
chown root:root /etc/vault.d
chown root:vault /etc/vault.d/vault.hcl
chmod 640 /etc/vault.d/vault.hcl

# Configure SELinux to allow vault service running
/sbin/restorecon -v /usr/bin/vault

# Start Vault service
systemctl start vault
systemctl enable vault