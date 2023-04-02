#!/usr/bin/bash

#Download Vault
wget https://releases.hashicorp.com/vault/${vault_version}/vault_${vault_version}_linux_386.zip

#Unzip Vault
unzip vault_${vault_version}_linux_386.zip

#Get vm ip from IMDS
export cluster_ip="$(curl -sH Metadata:true --noproxy '*' 'http://169.254.169.254/metadata/instance/network/interface/0/ipv4/ipAddress/0/privateIpAddress?api-version=2020-09-01&format=text')"

#Move vault to desired path
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

#Configure Vault service
echo '${vault_service_config}' > /lib/systemd/system/vault.service

#Configure firewall ports 
firewall-offline-cmd --add-port=8200/tcp

#Configure SELinux to allow vault service running
ausearch -c '(vault)' --raw | audit2allow -M my-vault 
semodule -i my-vault.pp
/sbin/restorecon -v /usr/bin/vault
systemctl daemon-reload

#Start Vault service
systemctl start vault
systemctl enable vault

#Set Vault Address as it uses http
export VAULT_ADDR="http://127.0.0.1:8200"