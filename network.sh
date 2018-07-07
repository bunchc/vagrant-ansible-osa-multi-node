#!/bin/bash

# Down the interfaces
ifdown eth1
ifdown eth2
ifdown eth3
ifdown eth4

# Bring them up
ifup br-mgmt
ifup br-vlan
ifup br-flat
ifup br-vxlan
ifup eth1
ifup eth2
ifup eth3
ifup eth4

# Flush them
ip addr flush dev eth1
ip addr flush dev eth2
ip addr flush dev eth3
ip addr flush dev eth4
