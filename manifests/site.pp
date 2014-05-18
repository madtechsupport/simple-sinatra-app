include '::ruby'
include '::passenger'

# Get the repository.
vcsrepo { "${installpath}":
    require => Class['::apache'],
    ensure => present,
    provider => git,
    source => "${gitrepository}"
}

# Make sure the public directory exists.
file { "${installpath}/public":
    ensure => 'directory',
    require => File["${installpath}"],
}

# Make sure Gemfile.lock exists.
file { "${installpath}/Gemfile.lock":
    ensure => "file",
    mode   => "0666",
    require => File["${installpath}"],
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
class { '::firewall' :
  ensure  => 'stopped',
}

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
