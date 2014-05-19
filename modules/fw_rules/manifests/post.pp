class fw_rules::post {
  firewall { '999 drop all':
    proto   => 'all',
    action  => 'reject',
    before  => undef,
    reject => 'icmp-host-prohibited',
  }
}
