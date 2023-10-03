ansi_colle.windows.install
=========

Install software without the use of package manager.

Requirements
------------

NONE

Role Variables
--------------

NONE

Dependencies
------------

NONE

Example Playbook
----------------

```
- name: Example Playbook
  hosts: servers
  tasks:
    - name: Using this role
      ansible.builtin.include_role:
        name: ansi_colle.windows.install
```
