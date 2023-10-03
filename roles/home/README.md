home_config
=========

Configure user home folder without sudo privilege on Windows.

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
- name: Configure WSL
  hosts: all
  tasks:
    - name: Configure WSL home directory
      ansible.builtin.include_role:
        name: ansi_colle.windows.wsl
```
