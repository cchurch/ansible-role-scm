.PHONY: core-requirements requirements syntax-check setup test cleanup tox \
	bump-major bump-minor bump-patch

core-requirements:
	pip install "pip>=8,<8.1.2" "setuptools>=20"

requirements: core-requirements
	pip install -r requirements.txt

syntax-check: requirements
	ANSIBLE_CONFIG=tests/ansible.cfg ansible-playbook -i tests/inventory tests/main.yml --syntax-check

setup: requirements
	ANSIBLE_CONFIG=tests/ansible.cfg ansible-playbook -i tests/inventory -vv tests/setup.yml

test: requirements
	ANSIBLE_CONFIG=tests/ansible.cfg ansible-playbook -i tests/inventory -vvvv tests/main.yml

cleanup: requirements
	ANSIBLE_CONFIG=tests/ansible.cfg ansible-playbook -i tests/inventory -vv tests/cleanup.yml

tox: requirements
	tox

bump-major:
	bumpversion major

bump-minor:
	bumpversion minor

bump-patch:
	bumpversion patch
