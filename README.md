[![Build Status](http://img.shields.io/travis/cchurch/ansible-role-scm.svg)](https://travis-ci.org/cchurch/ansible-role-scm)
[![Galaxy](http://img.shields.io/badge/galaxy-cchurch.scm-blue.svg)](https://galaxy.ansible.com/cchurch/scm/)

SCM
===

Checkout code from SCM (git/hg/svn).

Requirements
------------

If checking out using SSH, a deployment key must be present for use by the
`scm_target_user` or SSH agent forwarding must be enabled for the Ansible SSH
connection.

`sudo` or similar privilege escalation is required to install the SCM package,
checkout as another user (i.e. `scm_target_user != ansible_user`), or create the
`scm_target_user` account.

Role Variables
--------------

Refer to the documentation for the `git`, `hg` or `svn` Ansible modules for more
specifics regarding parameters passed directly to the underlying modules.

The following variables are typically defined to use this role:

- `scm_type`: One of `git` (default), `hg` or `svn`.
- `scm_url`: URL to repository (e.g. `http://server/repo` or
  `ssh://server/repo`), required.
- `scm_version`: Branch, tag, revision or commit to checkout (e.g. `master` or
  `HEAD`).
- `scm_force`: Boolean indicating whether to pass `force` option to SCM module,
  which will discard any modified files in an existing working directory;
  default is `false`.
- `scm_delete_on_update`: Boolean indicating whether to delete `scm_target_path`
  before updating, default is `false`.
- `scm_username`: Username for accessing `scm_url`, only supported when
  `scm_type` is `svn`.
- `scm_password`: Password for accessing `scm_url`, only supported when
  `scm_type` is `svn`.
- `scm_target_path`: Target directory for checkout (default is `"~/src"`).
- `scm_target_user`: User to become for checkout (default is `ansible_user`, in
  which case no privilege escalation will be required). This user will be
  created if different from `ansible_user`, ignoring errors if `ansible_user`
  is unable to create the user.
- `scm_target_user_home`: Home directory to set if creating `scm_target_user`.

The following variables may also be used to customize this role, though are not
likely needed in most situations:

- `scm_accept_hostkey`: Boolean indicating whether to accept SSH host key, only
  supported when `scm_type` is `git`, role default is `true`.
- `scm_depth`: Create a shallow clone, minimum value is `1`; only supported when
  `scm_type` is `git`; role default is unspecified.
- `scm_executable`: Path to `git`, `hg` or `svn` binary; default is unspecified,
  which searches system binary paths.
- `scm_export`: Export instead of checkout/update; only supported when
  `scm_type` is `svn`; role default is unspecified, but the `svn` module default
  is `false`.
- `scm_key_file`: Path to private key file on the target to use for checkout;
  default is unspecified; only supported when `scm_type` is `git`.
- `scm_purge`: Delete untracked files when updating; only supported when
  `scm_type` is `hg`; role default is unspecified, but the `hg` module default
  is `false`.
- `scm_recursive`: Boolean indicating whether to clone respotitory recursively,
  including submodules; only supported when `scm_type` is `git`; role default is
  unspecified, but the `git` module default is `true`.
- `scm_remote`: Name of the remote; only supported when `scm_type` is `git`;
  role default is unspecified, but the `git` module default is `"origin"`.
- `scm_switch`: Call `svn switch` before update; only supported when `scm_type`
  is `svn`; role default is unspecified, but the `svn` module default is `true`.
- `scm_track_submodules`: Boolean indicating whether submodules track the
  latest commits; only supported when `scm_type` is `git`; role default is
  unspecified, but the `git` module default is `false`.
- `scm_update`: Boolean indicating whether to receive new revisions from the
  origin repository; role default is unspecified, but modules default to `true`.
- `scm_verify_commit`: Boolean indicating whether to validate GPG signed
  commits; only supported when `scm_type` is `git`; role default is unspecified
  but the `git` module default is `false`.
- `scm_packages`: Mapping of packages by `ansible_pkg_mgr` and `scm_type`. The
  role will attempt to install the required package, ignoring errors if the
  appropriate privilege escalation is not available. There is normally no need
  to change this variable unless running on a system using a different
  `ansible_pkg_mgr` than `yum`, `apt`, `pacman` or `macports`.

The following variable may be defined for the play or role invocation (but will
not work if defined as an inventory group or host variable):

- `scm_notify_on_updated`: Handler name to notify when the checkout was changed.
  The default is `"scm updated"`; it is generally recommended for custom
  handlers to listen for `"scm updated"` instead of changing the notification
  name.

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
          vars:
            scm_type: git
            scm_url: https://github.com/cchurch/ansible-sign.git
            scm_target_path: ~/src/ansible-sign
            scm_version: master
      handlers:
        - name: ansible sign updated
          debug:
            msg: "{{ scm_target_path }} was updated from {{ scm_url }} to {{ scm_update_result.after }}."
          listen: scm updated

License
-------

BSD

Author Information
------------------

Chris Church ([cchurch](https://github.com/cchurch))
