<?php

	require_once('../bridge_file.php');

	@$un_id = $_GET['un_id'];
	@$db_name = $_GET['db_name'];
	@$csIDNeedUpdate = $_GET['csIDNeedUpdate'];

	if(!isset($un_id)){

		$return['message'] = "Invalid data";
		$return['status'] = "304";
	}else{

		$result = UnitDefect::isInitial($un_id,$db_name);

		if($result == FALSE) {

			$return['message'] = "Not Found";
			$return['status'] = "404";
		}else{
			if (isset($csIDNeedUpdate)) {
					$df_user_id_cs_before = $result['df_user_id_cs'];
					if ($df_user_id_cs_before != NULL && $df_user_id_cs_before != "") {

							$newUserID = "";
							$shouldBeConcat = TRUE;
						  $listUserID = explode(",",$df_user_id_cs_before);
							foreach ($listUserID as $userID) {
									if ($userID == $csIDNeedUpdate) {
										$shouldBeConcat = FALSE;
										break;
									}
							}

							if ($shouldBeConcat) {
								$newUserID = $df_user_id_cs_before.",".$csIDNeedUpdate;
								$df_room_id = $result['df_room_id'];
								UnitDefect::updateCSID($newUserID,$df_room_id,$db_name);
								$result['df_user_id_cs'] = $newUserID;
							}
					}
			}

			$return['message'] = "Duplicate";
			$return['status'] = "201";
			$return['unit_defect'] = $result;
		}
	}
	echo json_encode($return);


?>
