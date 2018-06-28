#!/bin/bash

# Start a timer
ts=$(date +%s%3N)

export ANSIBLE_FORCE_COLOR=true

# Stop the running VMs
echo -e "\n************************"
echo    "* Stopping running vms *"
echo -e "************************\n"

vagrant destroy -f openstack-ansible-01

# Sometimes ZFS holds a bit too much memory
echo -e "\n**********************"
echo    "* Flushing ZFS cache *"
echo -e "**********************\n"

sync; echo 2 | tee /proc/sys/vm/drop_caches

# Let's dial the CPU's up to 11
echo -e "\n******************************"
echo    "* Setting CPU to performance *"
echo -e "******************************\n"

for i in {0..15}; do cpufreq-set -c $i -g performance; done

# Builds or rebuilds the environment

echo -e "\n******************"
echo    "* Starting build *"
echo -e "*******************\n"

vagrant up openstack-ansible-01 --no-provision && vagrant provision | tee build.log

# Turn the CPUs back down
echo -e "\n****************************"
echo    "* Setting CPU to powersave *"
echo -e "****************************\n"

for i in {0..15}; do cpufreq-set -c $i -g powersave; done

# End the timer and record our data
te=$(date +%s%3N)
tt=$(($te - $ts))
echo "Time taken: $tt milliseconds"

curl -i -XPOST http://black-pearl.local:8086/write?db=monitorsrackbuild --data-binary "
osa_build_time_start,host=lab-c.local value=${ts}
osa_build_time_stop,host=lab-c.local value=${te}
osa_build_time_total,host=lab-c.local value=${tt}"
