
class module_exam {

	# HOSTS

	# Miscellaneous packages.
	#$misc_packages = [
	#	'sendmail','vim-enhanced','telnet','zip','unzip','screen',
	#	'libssh2','libssh2-devel','gcc','gcc-c++','autoconf','automake','postgresql-libs'
	#]

	#package { $misc_packages: ensure => latest }

	# APACHE

	class { 'apache':  }

	apache::vhost { 'myMpwar.prod':
	  port    => '80',
	  docroot => '/var/www/myproject',
	}

	apache::vhost { 'myMpwar.dev':
	  port    => '80',
	  docroot => '/var/www/myproject',
	}

	# MYSQL

	class { '::mysql::server':

	}

	mysql::db { 'mpwar_test':
	  user     => 'user1',
	  password => 'mpwardb',
	  host     => 'localhost',
	  grant    => ['SELECT', 'INSERT', 'UPDATE', 'DELETE'],
	}

	mysql::db { 'mympwar':
	  user     => 'user2',
	  password => 'mpwardb',
	  host     => 'localhost',
	  grant    => ['SELECT', 'INSERT', 'UPDATE', 'DELETE'],
	}

	# PHP

	$php_version = '56'

	include ::yum::repo::remi


	if $php_version == '55' {
		include ::yum::repo::remi_php55
	}
	elsif $php_version == '56'{
		::yum::managed_yumrepo { 'remi-php56':
		  descr          => 'Les RPM de remi pour Enterpise Linux $releasever - $basearch - PHP 5.6',
		  mirrorlist     => 'http://rpms.famillecollet.com/enterprise/$releasever/php56/mirror',
		  enabled        => 1,
		  gpgcheck       => 1,
		  gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-remi',
		  gpgkey_source  => 'puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-remi',
		  priority       => 1,
		}
	}

	class { 'php': 
		version => 'latest',
		require => Yumrepo['remi-php56']
	}


	#php::module { [ 'devel', 'pear', 'xml', 'mbstring', 'pecl-memcache', 'soap' ]: }

	#MONGODB

	class {'::mongodb::server':
	}

	# Files

	file { '/var/www/myproject/index.php':
	    ensure  => 'present',
	    content => "Hello World. Sistema operativo ${operatingsystem} ${operatingsystemrelease}",
	    mode    => '0644',
	}

	file { '/var/www/myproject/info.php':
		ensure  => 'present',
		content => "<?php phpinfo();",
		mode    => '0644',
	}

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
