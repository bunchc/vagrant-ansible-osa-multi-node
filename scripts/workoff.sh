#!/usr/bin/env bash

# This script assumes you are using vagrant-libvirt and that the sahara plugin
# has been installed and then patched per:
# https://github.com/jedi4ever/sahara/issues/56

vagrant sandbox status | grep 'is on'
rc=$?; if [[ $rc != 0 ]]; then echo "Sandbox mode already on"; exit $rc; fi

echo "Rolling back"
vagrant sandbox rollback
active=$?
if [[ $active != 0 ]]; then
    echo "Unable to rollback"
    exit $active
else
    echo "Fixing the clock"
    vagrant ssh osa-controller-01 -t -c "sudo chronyc -a makestep"
    vagrant ssh osa-comp-c1-01 -t -c "sudo chronyc -a makestep"
    vagrant ssh osa-comp-c2-01 -t -c "sudo chronyc -a makestep"
fi

echo "Disabling sandbox"
vagrant sandbox off
active=$?
if [[ $active != 0 ]]; then
    echo "Unable to disable sandbox"
    exit $active
else
    echo "Fixing the clock"
    vagrant ssh osa-controller-01 -t -c "sudo chronyc -a makestep"
    vagrant ssh osa-comp-c1-01 -t -c "sudo chronyc -a makestep"
    vagrant ssh osa-comp-c2-01 -t -c "sudo chronyc -a makestep"
fi

echo "Setting tuned profile to server-powersave"
tuned-adm profile throughput-performance