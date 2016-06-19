
<?php
	
header('Content-Type: application/json');
	require_once('../bridge_file.php');

	$data_back = json_decode(file_get_contents('php://input'));
	@$db_name = $data_back->{'db_name'};
	@$timestamp = $data_back->{'timestamp'};	
	@$data = $data_back->{'data'};
	@$df_room_id = $data_back->{'df_room_id'};

	if(!isset($db_name) || !isset($timestamp)){
		$return['message'] = "Invalid data";
		$return['status'] = "304";
	}else{

		$flagResult = TRUE;
	
		$i = 0;
		foreach ($data as $obj) {
			$flag = Defect::sync($db_name,$obj);
			if($flag == FALSE){
				$flagResult = FALSE;
				break;
			}
			$i++;
		}

		UnitDefect::updateSyncDate($db_name,$df_room_id,$timestamp);

		if($flagResult == FALSE) {

			$return['message'] = "Sync Fail";
			$return['status'] = "304";
		}else{
			$return['message'] = "SUCCESS";
			$return['status'] = "200";	
		}
	}
	echo json_encode($return);
	

?>