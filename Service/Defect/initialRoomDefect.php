<?php
	

	require_once('../bridge_file.php');

	@$un_id = $_GET['un_id'];
	@$user_id = $_GET['user_id'];
	@$user_id_cs = $_GET['user_id_cs'];
	@$db_name = $_GET['db_name'];
	@$df_check_date = $_GET['df_check_date'];


	if(!isset($un_id) || !isset($user_id) || !isset($db_name)){

		$return['message'] = "Invalid data";
		$return['status'] = "304";
	}else{

		$result = UnitDefect::add($un_id,$user_id,$db_name,$user_id_cs,$df_check_date);
		if($result == FALSE) {

			$return['message'] = "Add Fail";
			$return['status'] = "304";
		}else{

			$return['message'] = "SUCCESS";
			$return['status'] = "200";	
		}
	}
	echo json_encode($return);
	

?>