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

		public static function update($db_name,$data) {

			$conn = Database::connect_db_by_dbName($db_name);
			$result = mysqli_query($conn, "UPDATE `".$db_name."`.`tb_defect`
																		SET `complete_status` = '".$data->complete_status."'
																		WHERE `tb_defect`.`df_id` = ".$data->df_id.";");
			return $result;

			mysqli_free_result($result);
			mysqli_close($conn);

		}

		public static function sync($db_name,$data) {

			$conn = Database::connect_db_by_dbName($db_name);
			$result = mysqli_query($conn, "
				INSERT INTO `".$db_name."`.`tb_defect` (`df_id`, `df_category`, `df_sub_category`, `df_detail`, `df_room_id_ref`, `df_date`, `df_image_path`, `df_status`,`df_type`)
				VALUES (NULL,
					'".$data->categoryName."',
					'".$data->subCategoryName."',
					'".$data->listSubCategory."',
					'".$data->df_room_id_ref."',
					'".$data->df_date."',
					'".$data->df_image_path."',
					'1',
					'".$data->df_type."');");
			return $result;

			mysqli_free_result($result);
			mysqli_close($conn);

		}
	}

?>
