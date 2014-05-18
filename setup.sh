#!/bin/bash

# This script bootstraps Puppet on CentOS 6.x Ubuntu LTS...
# Tested on Centos 6.5 (32 bit).

set -e

# Define environment variables.

setuppath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
installpath="/var/www/simple-sinatra-app"
gitrepository="https://github.com/tnh/simple-sinatra-app"
exfactdir="/etc/facter/facts.d"
exfactfile="facts.txt"
platform=$(uname -i)
repo_url_el_6="https://yum.puppetlabs.com/el/6/products/${platform}/puppetlabs-release-6-7.noarch.rpm"
repo_url_apt="https://apt.puppetlabs.com/puppetlabs-release-${code_name}.deb"

# Check to see if the submodule is present.
if [[ ! -f ${setuppath}/modules/passenger/README.md ]]; then
  printf "The passenger submodule appears to be missing.\nWill try and fix that now.\n"
  cd ${setuppath}
  git submodule init
  git submodule update
  if [[ ! -f ${setuppath}/modules/passenger/README.md ]]; then
    printf "That didn't work. The passenger submodule is missing.\nExiting..."
    exit 1
  fi
fi

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

# Next save some things as external facts.
if [[ -d ${exfactdir} ]]; then
  printf "Strange, ${exfactdir} is alread present.\n"
  if [[ -f ${exfactdir}/${exfactfile} ]]; then
    printf "And the custom external fact file already exists.\n"
    exit 1
  else
    printf "installpath=${installpath}\n" > ${exfactdir}/${exfactfile}
    printf "gitrepository=${gitrepository}\n" >> ${exfactdir}/${exfactfile}
  fi
else
  mkdir -p ${exfactdir}
  printf "installpath=${installpath}\n" > ${exfactdir}/${exfactfile}
  printf "gitrepository=${gitrepository}\n" >> ${exfactdir}/${exfactfile}
fi

# Next install the required modules.
puppet module install puppetlabs/apache
puppet module install puppetlabs/firewall
puppet module install puppetlabs/ruby
puppet module install puppetlabs/vcsrepo

# Run puppet.
puppet apply ${setuppath}/manifests/site.pp --modulepath '$basemodulepath':${setuppath}/modules/
