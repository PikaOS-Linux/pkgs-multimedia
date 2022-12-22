#! /bin/bash

# Check system for NVIDIA card and set vaapi env vars

nvgpu=$(lspci | grep -iE 'VGA|3D' | grep -i nvidia | cut -d ":" -f 3)
nvkernmod=$(lspci -k | grep -iEA3 '^[[:alnum:]]{2}:[[:alnum:]]{2}.*VGA|3D' | grep -iA3 nvidia | grep -i 'kernel driver' | grep -iE 'vfio-pci|nvidia')

apply_env() {
if [[ ! -z $nvkernmod ]]
then
echo "NVIDIA Driver detected. setting env-v vars for va-api."
export LIBVA_DRIVER_NAME=nvidia
export MOZ_DISABLE_RDD_SANDBOX=1
export NVD_BACKEND=direct
export EGL_PLATFORM=$XDG_SESSION_TYPE
else
echo "No NVIDIA Driver detected. No env vars set for va-api."
fi
}


if [[ ! -z $nvgpu ]]
then
echo "NVIDIA GPU detected. Checking for NVIDIA Driver."
apply_env
else
echo "No NVIDIA GPU detected. No env vars set for va-api."
fi
