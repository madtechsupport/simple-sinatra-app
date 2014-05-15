include passenger

module { 'puppetlabs/apache': ensure => present, }
module { 'puppetlabs/firewall': ensure => present, }
module { 'puppetlabs/ruby': ensure => present, }

class { 'apache':
	require => Module['puppetlabs/apache'],
}

class { 'firewall': 
	require => Module['puppetlabs/firewall'],
}

class { 'ruby':
	require => Module['puppetlabs/ruby'],
	gems_version  => 'latest',
}

class {'passenger': 
	require => Package['builder'],
	passenger_version      => '4.0.42',
    	passenger_provider     => 'gem', }

package { 'builder':
	require => Class['ruby'],
	ensure   => 'installed',
	provider => 'gem',
}

package { 'sinatra':
	require => Class['ruby'],
	ensure   => 'installed',
	provider => 'gem',
}
