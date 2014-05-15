module { 'puppetlabs/apache': 
	ensure => present, 
	modulepath => $basemodulepath,
}
module { 'puppetlabs/firewall': 
	ensure => present, 
	modulepath => $basemodulepath,
}
module { 'puppetlabs/ruby': 
	ensure => present, 
	modulepath => $basemodulepath,
}
