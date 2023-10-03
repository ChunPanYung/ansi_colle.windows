scoop
=========

Install packages using scoop.

Requirements
------------

NONE

Role Variables
--------------

NONE

Dependencies
------------

`ansi_colle.windows.install`

Example Playbook
----------------
```
- name: Example Playbook
  hosts: servers
  tasks:
    - name: Using this role
      ansible.builtin.include_role:
        name: ansi_colle.windows.scoop
```
