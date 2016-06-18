<?php
	
	require_once('../bridge_file.php');

	@$df_room_id = $_POST['df_room_id'];
	@$db_name = $_POST['db_name'];
	@$time_stamp = $_POST['time_stamp'];


	if(!isset($df_room_id) || !isset($db_name) || !isset($time_stamp)){

		$return['message'] = "Invalid data";
		$return['status'] = "304";
	}else{

		$result = UnitDefect::isSync($df_room_id,$db_name,$time_stamp);
		if($result == FALSE) {
			$return['message'] = "Modify";
			$return['status'] = "200";
		}else{
			$return['message'] = "Not Modify";
			$return['status'] = "304";
		}
	}
	echo json_encode($return);
	

?>