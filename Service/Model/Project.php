<?php

	

	/**
	* 
	*/
	class Project
	{

		function __construct()
		{
			# code...
		}

		public static function buildings($dbName){

			$conn = Database::connect_db_by_dbName($dbName);
			$result = mysqli_query($conn, "	SELECT * FROM tb_building");
			$return = array();
			while (@$row = mysqli_fetch_array($result,MYSQLI_ASSOC)) {
				array_push($return, $row);
			}

			return $return;

			mysqli_free_result($result);
			mysqli_close($conn);
		}

		public static function rooms($building_id, $dbName){

			$conn = Database::connect_db_by_dbName($dbName);
			$result = mysqli_query($conn, "	SELECT * FROM tb_unit_number WHERE un_build_id = '".$building_id."'");
			$return = array();
			while (@$row = mysqli_fetch_array($result,MYSQLI_ASSOC)) {
				array_push($return, $row);
			}

			return $return;

			mysqli_free_result($result);
			mysqli_close($conn);
		}
		

	}

?>