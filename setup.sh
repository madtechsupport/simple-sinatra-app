#!/bin/bash

# This script bootstraps Puppet on CentOS 6.x Ubuntu LTS...
# Tested on Centos 6.5 (32 bit).

set -e

# Define environment variables.
arg1=$1
setuppath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
installpath="${arg1:=/var/www/simple-sinatra-app}"
gitrepository="https://github.com/tnh/simple-sinatra-app"
selinuxcreatepolicy="${setuppath}/selinux_create_policy.sh"
exfactdir="/etc/facter/facts.d"
exfactfile="facts.txt"
platform=$(uname -i)
release=$(cat /etc/*-release)
repo_url_el_6="https://yum.puppetlabs.com/el/6/products/${platform}/puppetlabs-release-6-7.noarch.rpm"
repo_url_apt="https://apt.puppetlabs.com/puppetlabs-release-${codename}.deb"

# Need to be root.
if [[ ${EUID} -ne 0 ]]; then
  echo "This script must be run as root." 1>&2
  exit 1
fi

# Don't do anything if puppet is already installed.
if type -P puppet >/dev/null 2>&1; then
  echo "Puppet is already installed."
  exit 1
fi

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

# Work out the Linux distribution and install puppet.
if grep "release 6" /etc/*-release >/dev/null 2>&1; then
  # This is Centos or Redhat 6.
  # Check the architecture is supported.
  if [[ ${platform} != "i386" && ${platform} != "x86_64" ]]; then
    echo "Puppet Labs Enterprise Linux 6 yum repositories available for i386 and x86_64 hardware platforms only."
    exit 1
  fi
  # Install puppet
  printf "Getting the puppet .rpm now.\n"
  rpm_path="$(mktemp -d)/puppetlabs_release.rpm"
  repo_url=${repo_url_el_6}
  curl -L -o "${rpm_path}" "${repo_url}" 2>/dev/null
  yum localinstall "${rpm_path}" -y >/dev/null
  yum install -y puppet > /dev/null
elif grep "wheezy" /etc/*-release >/dev/null 2>&1; then
  # This is Debian 7.
  codename="wheezy"
  # Install puppet.
  printf "Getting the puppet .deb now.\n"
  deb_path="$(mktemp -d)/puppetlabs_release.deb"
   wget -O "${deb_path}" "${repo_url_apt}" 2>/dev/null
  dpkg -i ${deb_path}
  apt-get update -y
else
  printf "Sorry, I don't know this operating system.\n"
  exit 1
fi

# Next save some things as external facts.
if [[ -d ${exfactdir} ]]; then
  printf "Strange, ${exfactdir} is alread present.\n"
  if [[ -f ${exfactdir}/${exfactfile} ]]; then
    printf "And the custom external fact file already exists.\n"
    exit 1
  else
    printf "installpath=${installpath}\n" > ${exfactdir}/${exfactfile}
    printf "gitrepository=${gitrepository}\n" >> ${exfactdir}/${exfactfile}
    printf "selinuxcreatepolicy=${selinuxcreatepolicy}\n" >> ${exfactdir}/${exfactfile}
  fi
else
  mkdir -p ${exfactdir}
  printf "installpath=${installpath}\n" > ${exfactdir}/${exfactfile}
  printf "gitrepository=${gitrepository}\n" >> ${exfactdir}/${exfactfile}
  printf "selinuxcreatepolicy=${selinuxcreatepolicy}\n" >> ${exfactdir}/${exfactfile}
fi

# Next install the required modules.
puppet module install puppetlabs/apache
puppet module install puppetlabs/firewall
puppet module install puppetlabs/ruby
puppet module install puppetlabs/vcsrepo

# Run puppet.
puppet apply ${setuppath}/manifests/site.pp --modulepath '$basemodulepath':${setuppath}/modules/

# We made it!
printf "Installation completed. Please test by pointing your browser to port 80 of the host\'s IP address and checking for the welcome message."
