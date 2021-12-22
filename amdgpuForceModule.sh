#! /bin/bash
################################################################################
#       amdgpu kernel driver selector
################################################################################
#       Author:
#               Luca Lombardini
#       Contacts:
#               s277972@studenti.polito.it
#               lombamari2@gmail.com
################################################################################
#       Purpose:
#		Force the loading of the amdgpu kernel driver instead of the 
#		usual radeon driver for AMD GPUs.
#		The reason for that is because of Vulkan API uses only amdgpu.
#		Vulkan is useful for gaming purposes thanks to its performance.
################################################################################
#       Year:   2019-2021
################################################################################
#       License: GPL-2.0
################################################################################
#	NOTE: this script must be run with super-user privilege.
################################################################################
sudo echo -e "# Custom module configuration to force the amdgpu kernel driver\n# Note: only amdgpu supports Vulkan\noptions radeon cik_support=0\noptions amdgpu cik_support=1" > /etc/modprobe.d/amdgpu.conf
