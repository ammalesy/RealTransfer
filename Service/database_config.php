<?php

	/**
	* 
	*/
	class Database
	{
		function __construct()
		{
			# code...
		}

		public static function condo_common() {

			return mysqli_connect("localhost","root","","condo_common_real_transfer");
		}
		public static function connect_db_by_dbName($dbName) {

			return mysqli_connect("localhost","root","",$dbName);
		}
	}

?>