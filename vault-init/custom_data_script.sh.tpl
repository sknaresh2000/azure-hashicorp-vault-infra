#!/usr/bin/bash
wget https://releases.hashicorp.com/vault/${vault_version}/vault_${vault_version}_linux_386.zip
unzip vault_${vault_version}_linux_386.zip
export cluster_ip="$(curl -sH Metadata:true --noproxy '*' 'http://169.254.169.254/metadata/instance/network/interface/0/ipv4/ipAddress/0/privateIpAddress?api-version=2020-09-01&format=text')"
mv vault /usr/bin/vault
mkdir /etc/vault.d
echo '${vault_config}' | sed \
-e "s/sa_account_name/${sa_account_name}/g" \
-e "s/sa_container_name/${sa_container_name}/g" \
-e "s/vault_tenant_id/${tenant_id}/g" \
-e "s/kv_name/${kv_name}/g" \
-e "s/kv_key_name/${kv_key_name}/g" \
-e "s/vault_cluster_name/${cluster_name}/g" \
-e "s/vault_cluster_ip/$cluster_ip/g" > /etc/vault.d/vault.hcl
echo '${vault_service_config}' > /lib/systemd/system/vault.service
firewall-cmd --add-port=8200/tcp
ausearch -c '(vault)' --raw | audit2allow -M my-vault 
semodule -i my-vault.pp
/sbin/restorecon -v /usr/bin/vault
systemctl daemon-reload
systemctl start vault
systemctl status vault
export VAULT_ADDR="http://127.0.0.1:8200"