<?php
	
	require_once('../bridge_file.php');

	@$un_id = $_GET['un_id'];
	@$db_name = $_GET['db_name'];


	if(!isset($un_id)){

		$return['message'] = "Invalid data";
		$return['status'] = "304";
	}else{

		$result = UnitDefect::isInitial($un_id,$db_name);
		if($result == FALSE) {

			$return['message'] = "Not Found";
			$return['status'] = "404";
		}else{
			$return['message'] = "Duplicate";
			$return['status'] = "201";
			$return['unit_defect'] = $result;
		}
	}
	echo json_encode($return);
	

?>