module { 'puppetlabs/apache': 
	ensure => present, 
}
module { 'puppetlabs/firewall': 
	ensure => present, 
}
module { 'puppetlabs/ruby': 
	ensure => present, 
}
