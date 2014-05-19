class fw_rules::pre {
  Firewall {
    require => undef,
  }

  # Default firewall rules
  firewall { '000 existing access':
    proto   => 'all',
    state => ['RELATED', 'ESTABLISHED'],
    action  => 'accept',
  }->
  firewall { '001 ping access':
    proto   => 'icmp',
    action  => 'accept',
  }->
  firewall { '002 localhost access':
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
  }->
  firewall { '003 ssh access':
    proto   => 'tcp',
    dport    => '22',
    action  => 'accept',
    state   => 'NEW',
  }->
  firewall { '003 http access':
    proto   => 'tcp',
    dport    => '80',
    action  => 'accept',
    state   => 'NEW',
  }
}
