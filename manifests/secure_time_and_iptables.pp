class module_exam::secure_time_and_iptables {
	
	# Ensure Time Zone and Region.
	class { 'timezone':
		timezone => 'Europe/Madrid',
	}

	#NTP
	class { '::ntp':
		server => [ '1.es.pool.ntp.org', '2.europe.pool.ntp.org', '3.europe.pool.ntp.org' ],
	}

	# Ip Tables.
	if $operatingsystemrelease == '7.0.1406'
	{
		# firewalld - Centos 7
		firewalld_rich_rule { 'Accept HTTP':
		  ensure  => present,
		  zone    => 'public',
		  service => 'http',
		  action  => 'accept',
		}
	}
	else
	{
		package { 'iptables':
		  ensure => present,
		  before => File['/etc/sysconfig/iptables'],
		}
		file { '/etc/sysconfig/iptables':
		  ensure  => file,
		  owner   => "root",
		  group   => "root",
		  mode    => 600,
		  replace => true,
		  source  => "puppet:///modules/my_module/iptables.txt",
		}
		service { 'iptables':
		  ensure     => running,
		  enable     => true,
		  subscribe  => File['/etc/sysconfig/iptables'],
		}
	}
}