include '::ruby'
include '::passenger'

# Make sure the public directory exists.
file { "${installpath}/public":
    ensure => "directory",
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
