<?php
	
/*
row4.detailInfo1 = "Kaniga Mingsong"
        row4.detailInfo2 = "phuncharat@mintedimages.com"
        row4.detailInfo3 = "080-123-4567"
        row4.detailInfo4 = "1 Bedroom"
        row4.detailInfo5 = "1A-M"
        row4.detailInfo6 = "25/4/2016"
        row4.detailInfo7 = "01/2016"
        row4.detailInfo8 = "Ammales Yamsompong"
*/
	require_once('../bridge_file.php');

	@$un_id = $_GET['un_id'];
	@$db_name = $_GET['db_name'];


	if(!isset($un_id)){

		$return['message'] = "Invalid data";
		$return['status'] = "304";
	}else{

		$result = UnitDefect::getInfo($un_id, $db_name);
		if(count($result) == 0) {

			$return['message'] = "Empty";
			$return['status'] = "999";
		}else{

			$return = $result;
			$return['message'] = "SUCCESS";
			$return['status'] = "200";	
		}
	}
	echo json_encode($return);
	

?>