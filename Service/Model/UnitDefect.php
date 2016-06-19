<?php

	

	/**
	* 
	*/
	class UnitDefect
	{

		function __construct()
		{
			# code...
		}
		public static function updateSyncDate($db_name,$df_room_id,$timestamp) {

			$conn = Database::connect_db_by_dbName($db_name);
			$result = mysqli_query($conn, "
											UPDATE `".$db_name."`.`tb_unit_defect` 
											SET `df_check_date` = '".$timestamp."' 
											WHERE `tb_unit_defect`.`df_room_id` = ".$df_room_id.";");
			return $result;
			mysqli_free_result($result);
			mysqli_close($conn);

		}
		public static function isSync($df_room_id,$db_name,$time_stamp){

			$conn = Database::connect_db_by_dbName($db_name);
			$result = mysqli_query($conn, "SELECT * FROM tb_unit_defect WHERE df_check_date = '".$time_stamp."' AND df_room_id = ".$df_room_id."");
			$return = array();
			while ($row = mysqli_fetch_array($result,MYSQLI_ASSOC)) {
				array_push($return, $row);
			}

			if(count($return) == 1){

				$defect = $return[0];

				return $defect;
			}else{
				return FALSE;
			}

		}
		public static function isInitial($un_id,$db_name) {

			$conn = Database::connect_db_by_dbName($db_name);
			$result = mysqli_query($conn, "SELECT * FROM tb_unit_defect WHERE df_un_id = ".$un_id."");
			
			$return = array();
			while ($row = mysqli_fetch_array($result,MYSQLI_ASSOC)) {
				array_push($return, $row);
			}

			if(count($return) == 1){

				$defect = $return[0];

				return $defect;
			}else{
				return FALSE;
			}

			mysqli_free_result($result);
			mysqli_close($conn);
		}

		public static function add($un_id,$user_id,$db_name,$user_id_cs,$df_check_date) {

			$conn = Database::condo_common();
			$result = mysqli_query($conn, "INSERT INTO `".$db_name."`.`tb_unit_defect` (`df_room_id`, `df_un_id`, `df_check_date`, `df_user_id`, `df_user_id_cs`) 
										   VALUES (NULL, '".$un_id."', '".$df_check_date."', '".$user_id."', '".$user_id_cs."');");
			return $result;

			mysqli_free_result($result);
			mysqli_close($conn);
		}

		public static function getInfo($un_id, $db_name) {

			$roomInfo = UnitDefect::getRoomInfo($un_id, $db_name);
			$defectInfo = UnitDefect::getDefectInfo($un_id, $db_name);
			if(count($defectInfo) > 0){

				$qcCheckerInfo = User::getUserByID($defectInfo['df_user_id']);
				$csInfo = User::getUserByID($defectInfo['df_user_id_cs']);
				$returnArray['defectInfo'] = $defectInfo;
				$returnArray['qcCheckerInfo'] = $qcCheckerInfo;
				$returnArray['csInfo'] = $csInfo;

			}
			
			$returnArray['userInfo'] = array('name'=>'test', 'email'=>'test', 'tel'=>'test');
			$returnArray['roomInfo'] = $roomInfo;
			
			

			return $returnArray;
		}
		public static function getDefectInfo($un_id, $db_name){
			$conn = Database::connect_db_by_dbName($db_name);
			$sql = "SELECT * FROM `tb_unit_defect` WHERE df_un_id = ".$un_id."";
			$result = mysqli_query($conn, $sql);
			//echo $sql;
			$return = array();
			while ($row = mysqli_fetch_array($result,MYSQLI_ASSOC)) {
				array_push($return, $row);
			}

			if(count($return) == 1){

				$defect = $return[0];

				return $defect;
			}else{
				return array();
			}

			mysqli_free_result($result);
			mysqli_close($conn);
		}
		public static function getCustomerByUn_id($un_id, $db_name) {
			$conn = Database::condo_common();
			$sql = "SELECT un_id,unit_type_id,room_type_id, room_type_info, unit_type_name 
											FROM condo_common.tb_room_type JOIN (
																				 SELECT un_id, un_unit_type_id, unit_type_name,unit_type_id,unit_type_room_type_id 
																				 FROM ".$db_name.".tb_unit_number JOIN ".$db_name.".tb_unit_type ON (un_unit_type_id = unit_Type_id) 
																				 WHERE un_id = ".$un_id.") tb_room 
																			ON (room_type_id = unit_type_room_type_id)";
			$result = mysqli_query($conn, $sql);
			//echo $sql;
			$return = array();
			while ($row = mysqli_fetch_array($result,MYSQLI_ASSOC)) {
				array_push($return, $row);
			}

			return $return;

			mysqli_free_result($result);
			mysqli_close($conn);
		}
		public static function getRoomInfo($un_id, $db_name) {
			$conn = Database::condo_common();
			$sql = "SELECT un_id,unit_type_id,room_type_id, room_type_info, unit_type_name 
											FROM condo_common.tb_room_type JOIN (
																				 SELECT un_id, un_unit_type_id, unit_type_name,unit_type_id,unit_type_room_type_id 
																				 FROM ".$db_name.".tb_unit_number JOIN ".$db_name.".tb_unit_type ON (un_unit_type_id = unit_Type_id) 
																				 WHERE un_id = ".$un_id.") tb_room 
																			ON (room_type_id = unit_type_room_type_id)";
			$result = mysqli_query($conn, $sql);
			//echo $sql;
			$return = array();
			while ($row = mysqli_fetch_array($result,MYSQLI_ASSOC)) {
				array_push($return, $row);
			}

			if(count($return) == 1){

				$room = $return[0];

				return $room;
			}else{
				return array();
			}

			mysqli_free_result($result);
			mysqli_close($conn);
		}
	}

?>