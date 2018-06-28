# ansible-monitorstack

An [Ansible](https://www.ansible.com/) role to install/configure [Monitorstack](https://github.com/openstack/monitorstack)

## Requirememnts

* Ansible 2.4 (and above)

## LICENSE

MIT

## Role Variables

## Example Playbook

```
---
- hosts: compute_hosts
  become: true
  vars:
  roles:
    - role: ansible-monitorstack
```