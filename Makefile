.PHONY: check apply

check:
	ansible-playbook initial-config.yml --check --diff

apply:
	ansible-playbook initial-config.yml
