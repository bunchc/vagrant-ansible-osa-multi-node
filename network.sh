#!/bin/bash

echo "
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto ens3
iface ens3 inet dhcp
pre-up sleep 2" | tee /etc/network/interfaces

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
