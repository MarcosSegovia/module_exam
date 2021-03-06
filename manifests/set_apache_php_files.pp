class module_exam::set_apache_php_files {

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

}