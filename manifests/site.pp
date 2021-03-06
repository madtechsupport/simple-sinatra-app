include '::passenger'
include '::ruby'

# Get the repository.
vcsrepo { "${installpath}":
  before => File["${installpath}/public"],
  require => Class['::apache'],
  ensure => present,
  provider => git,
  source => "${gitrepository}"
}

# Make sure the public directory exists.
file { "${installpath}/public":
  ensure => 'directory',
}

# Make sure Gemfile.lock exists.
file { "${installpath}/Gemfile.lock":
  ensure => "file",
  mode   => "0666",
  require => File["${installpath}/public"],
}

# Do some virtual host thing here.
class { '::apache':
  default_mods        => false,
  default_confd_files => false,
  default_vhost       => false,
}

::apache::vhost { 'sinatra_default':
  port    => '80',
  docroot => "${installpath}/public",
  directories => [
    { 'path'           => "${installpath}/public", 
      'allow_override' => ['all'],
      'options'        => ['-MultiViews'],
    },
  ],
}

# Begin firewall config
resources { 'firewall':
  purge => true
}

# Edit modules/fw_rules/pre to allow ssh access only from known IP addresses.
Firewall {
  before  => Class['::fw_rules::post'],
  require => Class['::fw_rules::pre'],
}

class { ['::fw_rules::pre', '::fw_rules::post']: }

class { '::firewall': }

# gem install bundler
package { 'bundler':
  ensure   => 'installed',
  provider => 'gem',
}

# gem install bundler
package { 'sinatra':
  ensure   => 'installed',
  provider => 'gem',
}

# Do some Debian and Red Hat specific things.
case $osfamily {
  'redhat': {
    package { 'policycoreutils-python':
      require  => Class['::passenger'],
      ensure   => 'installed',
      provider => 'yum',
    }
    exec { 'selinux-create-policy':
      require  => Package['policycoreutils-python'],
      command  => "${selinuxcreatepolicy} >/dev/null 2>&1",
      creates  => '/tmp/passenger.pp',
      timeout  => '0',
    }
  }
  'debian': {
    # Here we can install SELinux or AppArmor
    # for Debian.
  }
  default: {
    # ...
  }
}

# Here we can provide a custom sshd_config file
# that does not permit root login and requires login
# to be authenticated with a certificate and not password.
package { 'openssh-server':
  ensure => present,
  before => File['/etc/ssh/sshd_config'],
}
file { '/etc/ssh/sshd_config':
  ensure => file,
  mode   => 600,
  source => "${setuppath}/files/sshd_config_${osfamily}",
}
service { 'sshd':
  ensure     => running,
  enable     => true,
  subscribe  => File['/etc/ssh/sshd_config'],
}
