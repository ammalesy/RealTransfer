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

			return mysqli_connect("localhost","root","","condo_common");
		}
	}

?>