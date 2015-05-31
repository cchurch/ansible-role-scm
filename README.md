[![Build Status](http://img.shields.io/travis/cchurch/ansible-role-scm.svg)](https://travis-ci.org/cchurch/ansible-role-scm)
[![Galaxy](http://img.shields.io/badge/galaxy-cchurch.scm-blue.svg)](https://galaxy.ansible.com/list#/roles/3985)

SCM
===

Checkout code from SCM (git/hg/svn).

Role Variables
--------------

The following variables may be defined to customize this role:

- `scm_type`: One of `git` (default), `hg` or `svn`.
- `scm_url`: URL to repository (e.g. `http://server/repo` or `ssh://server/repo`), required.
- `scm_version`: Branch, tag, revision or commit to checkout (e.g. `master` or `HEAD`).
- `scm_force`: Boolean indicating whether to pass `force` option to SCM module, default is `false`.
- `scm_delete_on_update`: Boolean indicating whether to delete `scm_target_path` before updating, default is `false`.
- `scm_username`: Username for accessing `scm_url`, only supported when `scm_type` is `svn`.
- `scm_password`: Password for accessing `scm_url`, only supported when `scm_type` is `svn`.
- `scm_accept_hostkey`: Boolean indicating whether to accept SSH host key, only supported when `scm_type` is `git`, default is `true`.
- `scm_target_user`: User to become for checkout (default is `ansible_ssh_user`), will be created if different from `ansible_ssh_user`.
- `scm_target_user_home`: Home directory to set when creating `scm_target_user`.
- `scm_target_path`: Target directory for checkout (default is `~/src`).
- `scm_notify_on_updated`: Handler name to notify when the checkout was updated.
- `scm_packages`: Normally not needed to change unless running on a system using a different `ansible_pkg_mgr`.

Example Playbook
----------------

The following example playbook checks out a public git repo and displays a
message after updating:

    - hosts: all
      roles:
        - role: cchurch.scm
          scm_type: git
          scm_url: https://github.com/cchurch/ansible-sign.git
          scm_target_path: ~/src/ansible-sign
          scm_version: master
          scm_notify_on_updated: ansible sign updated
      handlers:
        - name: ansible sign updated
          debug:
            msg: "{{scm_target_path}} was updated from {{scm_url}}."

License
-------

BSD

Author Information
------------------

Chris Church <chris@ninemoreminutes.com>
