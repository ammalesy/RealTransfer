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
		public static function getUserByRole($role) {

			$conn = Database::condo_common();
			$result = mysqli_query($conn, "	SELECT pm_id, pm_name,user_id, user_permission, user_pers_fname, user_pers_lname,user_pers_user_id
											FROM tb_permission JOIN
												(SELECT user_id, user_permission, user_pers_fname, user_pers_lname,user_pers_user_id
												 FROM tb_user JOIN tb_user_personal_info ON (user_id = user_pers_user_id)) tb_user_join
												 ON (pm_id = user_permission)
											WHERE pm_name = '".$role."'
									");
			$return = array();
			while ($row = mysqli_fetch_array($result,MYSQLI_ASSOC)) {
				array_push($return, $row);
			}

			return $return;

			mysqli_free_result($result);
			mysqli_close($conn);
		}
		public static function getUserByID($user_id) {

			$conn = Database::condo_common();
			$result = mysqli_query($conn, "	SELECT * FROM tb_user JOIN tb_user_personal_info ON (user_pers_user_id = user_id) WHERE user_id = ".$user_id."
									");
			$return = array();
			while ($row = mysqli_fetch_array($result,MYSQLI_ASSOC)) {
				array_push($return, $row);
			}

			if(count($return) == 1){

				$user = $return[0];

				return $user;
			}else{
				return array();
			}

			mysqli_free_result($result);
			mysqli_close($conn);
		}
		public static function getUserByUnitID($un_id, $db_name) {

			$conn = Database::connect_db_by_dbName($db_name);
			$result = mysqli_query($conn, "SELECT qt_unit_number_id,pers_prefix, pers_fname, pers_lname, pers_sex, pers_card_id, pers_mobile, pers_tel, pers_email
																		 FROM condo_common.tb_customer_personal_info JOIN
																		 						(SELECT qt_unit_number_id,cus_id,ct_cus_id, cus_pers_id
																								 FROM condo_common.tb_customer JOIN
																								 								(SELECT qt_unit_number_id,ct_cus_id
																																 FROM ".$db_name.".tb_quotation JOIN
																																 						(SELECT ct_code, ct_booking_code, ct_cus_id, bk_quotation_code, bk_booking_code
																																						 FROM ".$db_name.".tb_contract JOIN ".$db_name.".tb_booking
																																						 ON (ct_booking_code = bk_booking_code) ) tb_booking_join
																																 ON (qt_code = bk_quotation_code)) tb_quotation_join
																								ON (cus_id = ct_cus_id)) tb_customer_join
																			ON (pers_id = cus_pers_id)
																			WHERE qt_unit_number_id = '".$un_id."'");
			$return = array();
			while ($row = mysqli_fetch_array($result,MYSQLI_ASSOC)) {
				array_push($return, $row);
			}

			if(count($return) == 1){

				$user = $return[0];

				return $user;
			}else{

				$data['qt_unit_number_id'] = "N/A";
				$data['pers_sex'] = "N/A";
				$data['pers_card_id'] = "N/A";
				$data['pers_mobile'] = "N/A";
				$data['pers_prefix'] = "";
				$data['pers_fname'] = "N/A";
				$data['pers_lname'] = "N/A";
				$data['pers_email'] = "N/A";
				$data['pers_tel'] = "N/A";
				return $data;
			}

			mysqli_free_result($result);
			mysqli_close($conn);
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
			while ($row = mysqli_fetch_array($result,MYSQLI_ASSOC)) {
				array_push($return, $row);
			}

			return $return;

			mysqli_free_result($result);
			mysqli_close($conn);
		}

	}

?>
