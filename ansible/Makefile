.PHONY: check apply vault-init vault-unseal vault-configure

check:
	ansible-playbook initial-config.yml --check --diff

apply:
	ansible-playbook initial-config.yml

vault-init:
	ansible-playbook vault.yml --tags init

vault-unseal:
	ansible-playbook vault.yml --tags unseal \
		--extra-vars "vault_unseal_keys=$(KEYS)"

vault-configure:
	ansible-playbook vault.yml --tags configure \
		--extra-vars "vault_root_token=$(TOKEN) authentik_secret_key=$(SECRET_KEY) postgresql_password=$(PG_PASS)"
