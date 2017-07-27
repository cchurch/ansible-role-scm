[![Build Status](http://img.shields.io/travis/cchurch/ansible-role-scm.svg)](https://travis-ci.org/cchurch/ansible-role-scm)
[![Galaxy](http://img.shields.io/badge/galaxy-cchurch.scm-blue.svg)](https://galaxy.ansible.com/cchurch/scm/)

SCM
===

Checkout code from SCM (git/hg/svn).

Requirements
------------

If checking out using SSH, a deployment key must be present for use by the
`scm_target_user`.

`sudo` or similar privilege escalation is required to install the SCM package,
checkout as another user (`scm_target_user != ansible_user`), or create the
`scm_target_user` account.

Role Variables
--------------

The following variables may be defined to customize this role:

- `scm_type`: One of `git` (default), `hg` or `svn`.
- `scm_url`: URL to repository (e.g. `http://server/repo` or
  `ssh://server/repo`), required.
- `scm_version`: Branch, tag, revision or commit to checkout (e.g. `master` or
  `HEAD`).
- `scm_force`: Boolean indicating whether to pass `force` option to SCM module,
  default is `false`.
- `scm_delete_on_update`: Boolean indicating whether to delete `scm_target_path`
  before updating, default is `false`.
- `scm_username`: Username for accessing `scm_url`, only supported when
  `scm_type` is `svn`.
- `scm_password`: Password for accessing `scm_url`, only supported when
  `scm_type` is `svn`.
- `scm_accept_hostkey`: Boolean indicating whether to accept SSH host key, only
  supported when `scm_type` is `git`, default is `true`.
- `scm_target_path`: Target directory for checkout (default is `~/src`).
- `scm_target_user`: User to become for checkout (default is `ansible_user`, in
  which case no privilege escalation will be required). This user will be
  created if different from `ansible_user`, ignoring errors if `ansible_user`
  is unable to create the user.
- `scm_target_user_home`: Home directory to set if creating `scm_target_user`.
- `scm_packages`: Mapping of packages by `ansible_pkg_mgr` and `scm_type`. The
  role will attempt to install the required package, ignoring errors if the
  appropriate privilege escalation is not available. There is normally no need
  to change this variable unless running on a system using a different
  `ansible_pkg_mgr` than `yum` or `apt`.

The following variable may be defined for the play or role invocation (but not
as an inventory group or host variable):

- `scm_notify_on_updated`: Handler name to notify when the checkout was changed.

The role will also set the `scm_update_result` fact (per host) to the result of
the update task.

Dependencies
------------

None.

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
            msg: "{{scm_target_path}} was updated from {{scm_url}} to {{scm_update_result.after}}."

License
-------

BSD

Author Information
------------------

Chris Church <chris@ninemoreminutes.com>
