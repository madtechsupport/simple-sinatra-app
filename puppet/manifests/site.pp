include '::firewall'
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
}
