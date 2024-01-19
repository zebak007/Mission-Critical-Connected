# To be improved...
# inspired by https://techcommunity.microsoft.com/t5/fasttrack-for-azure/accessing-aks-private-clusters-with-azure-bastion-and-vs-code/ba-p/358136
# Need to check/upgrade bastion from basic to standard and Native Client must be enabled

# ssh connection
az network bastion ssh -n lde001buildinfra-bastionhost -g lde001-buildinfra-rg --auth-type password --username alwayson --target-resource-id /subscriptions/65a2fddb-c61b-4be6-b286-360915c0f1fe/resourceGroups/lde001-buildinfra-rg/providers/Microsoft.Compute/virtualMachineScaleSets/lde001buildinfra-jumpboxes-vmss/virtualMachines/0

# enabling remote vs
az network bastion tunnel -n lde001buildinfra-bastionhost -g lde001-buildinfra-rg --target-resource-id /subscriptions/65a2fddb-c61b-4be6-b286-360915c0f1fe/resourceGroups/lde001-buildinfra-rg/providers/Microsoft.Compute/virtualMachineScaleSets/lde001buildinfra-jumpboxes-vmss/virtualMachines/0 --resource-port 22 --port 2022
