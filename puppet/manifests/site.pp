include '::firewall'
include '::ruby'
include '::passenger'

# Make sure the public directory exists.
file { "${setuppath}/../public":
    ensure => "directory",
}

# Do some virtual host thing here.
class { '::apache':
  default_mods => true,
}
