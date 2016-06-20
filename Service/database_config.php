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
			$connect = mysqli_connect("localhost","ammales","9B215ffa","condo_common");
			mysqli_set_charset($connect ,"utf8");
			return $connect;
		}
		public static function connect_db_by_dbName($dbName) {

			$connect = mysqli_connect("localhost","ammales","9B215ffa",$dbName);
			mysqli_set_charset($connect ,"utf8");
			return $connect;
		}
	}

?>