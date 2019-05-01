#!/bin/bash

export ANSIBLE_FORCE_COLOR=true

# Stop the running VMs
echo -e "\n************************"
echo    "* Stopping running vms *"
echo -e "************************\n"

vagrant destroy -f

# Nuke host_vars
echo -e "\n*******************"
echo    "* Nuke host varss *"
echo -e "*******************\n"

rm -rf host_vars/

# Sometimes ZFS holds a bit too much memory
echo -e "\n**********************"
echo    "* Flushing ZFS cache *"
echo -e "**********************\n"

#sync; echo 2 | tee /proc/sys/vm/drop_caches

# Let's dial the CPU's up to 11
echo -e "\n******************************"
echo    "* Setting CPU to performance *"
echo -e "******************************\n"

tuned-adm profile throughput-performance

# Turn disk to 11 also
echo -e "\n**********************"
echo    "* Setting disk to bfq *"
echo -e "***********************\n"

modprobe bfq
echo "bfq" | tee /sys/block/sd*/queue/scheduler

# Builds or rebuilds the environment

echo -e "\n******************"
echo    "* Starting build *"
echo -e "*******************\n"

vagrant pristine -f --no-provision | tee build.log
vagrant provision | tee -a build.log

# Turn the CPUs back down
echo -e "\n****************************"
echo    "* Setting CPU to powersave *"
echo -e "****************************\n"

tuned-adm profile server-powersave

