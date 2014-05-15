include passenger

module { 'puppetlabs/apache': ensure => present, }
module { 'puppetlabs/firewall': ensure => present, }
module { 'puppetlabs/ruby': ensure => present, }

class { 'apache':  }

class { 'firewall': }

class { 'ruby':
  gems_version  => 'latest'
}

package {'ruby-devel': ensure => 'installed', }
package {'gcc-c++': ensure => 'installed', }
package { 'builder':
    ensure   => 'installed',
    provider => 'gem',
}

class {'passenger': 
	require => Package['builder'],
	passenger_version      => '4.0.42',
    	passenger_provider     => 'gem', }

package { 'sinatra':
    ensure   => 'installed',
    provider => 'gem',
}

