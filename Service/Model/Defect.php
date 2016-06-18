<?php

	

	/**
	* 
	*/
	class Defect
	{

		function __construct()
		{
			# code...
		}
		
		public static function getDefects($df_room_id, $db_name) {

			$conn = Database::connect_db_by_dbName($db_name);
			$result = mysqli_query($conn, "	SELECT *
		                                   	FROM tb_defect 
		                                   	WHERE df_room_id_ref = ".$df_room_id."");
			$return = array();
			while ($row = mysqli_fetch_array($result,MYSQLI_ASSOC)) {
				array_push($return, $row);
			}

			return $return;

			mysqli_free_result($result);
			mysqli_close($conn);

		}
	}

?>