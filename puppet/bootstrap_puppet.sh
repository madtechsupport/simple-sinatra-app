#!/bin/bash

# For the purposes of this script I expect to find bash in the standard
# location for a Linux server. Hence no "#!/usr/bin/env bash", this script
# is not meant to be so portable.

# This script bootstraps Puppet on CentOS 6.x Ubuntu LTS...
# Tested on Centos 6.5 (32 bit).

set -e
# Using set -e to keep the code short. I can think of situations where I would
# prefer to not use set -e and instead check the return codes and act
# accordingly. But this is not one of them.

# Define environment variables.

installpath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
platform=$(uname -i)
repo_url_el_6="https://yum.puppetlabs.com/el/6/products/${platform}/puppetlabs-release-6-7.noarch.rpm"
repo_url_apt="https://apt.puppetlabs.com/puppetlabs-release-${code_name}.deb"

# Work out the Linux distribution and code name.
distribution() { 
if grep "^CentOS release 6" /etc/centos-release >/dev/null 2>&1; then
  # This is Centos 6.
  if [[ ${platform} != "i386" && ${platform} != "x86_64" ]]; then
    echo "Puppet Labs Enterprise Linux 6 yum repositories available for i386 and x86_64 hardware platforms only."
    exit 1
  else
    rpm_path=$(mktemp -d)/puppetlabs_release.rpm
    repo_url=${repo_url_el_6}
  fi
else
  printf "I don't know this operating system.\n"
  exit 1
fi 
}

# main()
# Install puppet labs repo

if [[ ${EUID} -ne 0 ]]; then
  echo "This script must be run as root." 1>&2
  exit 1
fi

if type -P puppet >/dev/null 2>&1; then
  echo "Puppet is already installed."
  exit 1
fi

distribution
printf "Configuring PuppetLabs repo...\n"
curl -L -o "${rpm_path}" "${repo_url}" 2>/dev/null
yum localinstall "${rpm_path}" -y >/dev/null

# Install Puppet...
echo "Installing puppet"
yum install -y puppet > /dev/null

echo "Puppet installed!"

# Next make sure this module (experimental but I'm hoping it is going to save me some time) is installed.
puppet module install rcoleman/puppet_module && puppet apply ${installpath}/manifests/modules.pp --modulepath ${installpath}/modules/:'$basemodulepath'
