class module_exam::set_mysql {

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

}