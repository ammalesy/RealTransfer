<?php

	

	/**
	* 
	*/
	class User
	{

		function __construct()
		{
			# code...
		}

		public static function login($username, $password) {

			$conn = Database::condo_common();
			$result = mysqli_query($conn, "	SELECT user_work_position,user_work_user_id,user_pers_fname,user_pers_lname,user_id,user_permission,user_username,user_sts_active,pm_name 
										   	FROM tb_user_working_info,(SELECT user_pers_fname,user_pers_lname,user_id,user_permission,user_username,user_sts_active,pm_name  
										   							FROM tb_user_personal_info ,(SELECT user_id,user_permission,user_username,user_sts_active,pm_name 
										   														 FROM tb_user JOIN tb_permission ON (user_permission = pm_id) 
										   														 WHERE (user_username = '".$username."' 
										   														 		AND user_password = '".$password."')) tb_login

										   							WHERE  user_id = user_pers_id ) tb_login_join_info

										   	WHERE user_work_user_id = user_id
									");
			$row = mysqli_fetch_array($result,MYSQLI_ASSOC);

			if($row){

				return $row;

			}else {
				return FALSE;
			}
			mysqli_free_result($result);
			mysqli_close($conn);
		}
		public static function projects($user_id) {

			$conn = Database::condo_common();
			$result = mysqli_query($conn, "	SELECT *
		                                   	FROM tb_assign_project , tb_project
		                                   	WHERE pj_id = assign_project_id 
		                                   	AND   pj_active = 'on' 
		                                   	AND   assign_sts_active = 'on' 
		                                   	AND   assign_user_id = '".$user_id."'
										  ");
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