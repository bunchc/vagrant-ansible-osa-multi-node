#!/usr/bin/env bash

# This script assumes you are using vagrant-libvirt and that the sahara plugin
# has been installed and then patched per:
# https://github.com/jedi4ever/sahara/issues/56

echo "Setting tuned profile to throughput-performance"
tuned-adm profile throughput-performance

vagrant sandbox status | grep 'is off'
rc=$?; if [[ $rc != 0 ]]; then echo "Sandbox mode already on"; exit $rc; fi

echo "Enabling sandbox mode"
vagrant sandbox on
active=$?
if [[ $active != 0 ]]; then
    echo "Unable to enable sandbox mode"
    exit $active
else
    echo "Fixing clocks"
    vagrant ssh osa-controller-01 -t -c "sudo chronyd -q 'server pool.ntp.org iburst'"
    vagrant ssh osa-comp-c1-01 -t -c "sudo chronyd -q 'server pool.ntp.org iburst'"
    vagrant ssh osa-comp-c2-01 -t -c "sudo chronyd -q 'server pool.ntp.org iburst'"

    echo "Connecing to controller"
    vagrant ssh osa-controller-01
fi
