.PHONY: core-requirements
core-requirements:
	pip install setuptools pip-tools

.PHONY: update-pip-requirements
update-pip-requirements: core-requirements
	pip install -U pip setuptools pip-tools
	pip-compile -U requirements.in

.PHONY: requirements
requirements: core-requirements
	pip-sync requirements.txt

.PHONY: galaxy-requirements
galaxy-requirements: requirements
	ansible-galaxy install -f -p tests/roles -r tests/roles/requirements.yml

.PHONY: syntax-check
syntax-check: requirements galaxy-requirements
	ANSIBLE_CONFIG=tests/ansible.cfg ansible-playbook -i tests/inventory tests/main.yml --syntax-check

.PHONY: setup
setup: requirements galaxy-requirements
	ANSIBLE_CONFIG=tests/ansible.cfg ansible-playbook -i tests/inventory -vv tests/setup.yml

.PHONY: test
test: requirements galaxy-requirements
	ANSIBLE_CONFIG=tests/ansible.cfg ansible-playbook -i tests/inventory -vv tests/main.yml

.PHONY: test-only
test-only: requirements galaxy-requirements
	ANSIBLE_CONFIG=tests/ansible.cfg ansible-playbook -i tests/inventory -vv tests/test.yml

.PHONY: cleanup
cleanup: requirements galaxy-requirements
	ANSIBLE_CONFIG=tests/ansible.cfg ansible-playbook -i tests/inventory -vv tests/cleanup.yml

.PHONY: clean-tox
clean-tox:
	rm -rf .tox

.PHONY: tox
tox: requirements galaxy-requirements
	tox

.PHONY: lint
lint: requirements galaxy-requirements
	ansible-lint tests/main.yml

.PHONY: bump-major
bump-major: requirements
	bump2version major

.PHONY: bump-minor
bump-minor: requirements
	bump2version minor

.PHONY: bump-patch
bump-patch: requirements
	bump2version patch
