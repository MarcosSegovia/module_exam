
class module_exam {
	
	include module_exam::secure_time_and_iptables
	include module_exam::set_apache_php_files
	include module_exam::set_mysql
	module_exam::set_mongodb
}
