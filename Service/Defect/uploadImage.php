
<?php
	
header('Content-Type: application/json');

	$headers =  getallheaders();
	$db_name = $headers['db_name'];
	$un_id = $headers['un_id'];


	$uploaddir = '../images/';
	if(!file_exists($uploaddir )){
		if(mkdir($uploaddir)){
			chmod($uploaddir , 0777);
		}
	}
	if(!file_exists($uploaddir.$db_name)){
		if(mkdir($uploaddir.$db_name)){
			chmod($uploaddir.$db_name , 0777);
		}
	}
	if(!file_exists($uploaddir.$db_name."/".$un_id)){
		if(mkdir($uploaddir.$db_name."/".$un_id)){
			chmod($uploaddir.$db_name."/".$un_id , 0777);
		}
	}

	$result = FALSE;
	$files = $_FILES; 
	foreach ($files as $file) 
	{ 
	  	
	  	$folderPath = $uploaddir.$db_name."/".$un_id."/";
	  	$uploadfile = $folderPath.basename($file['name']).".jpg";

	  	if(!is_dir($folderPath)) {
   			 mkdir($folderPath);
		}

		if (move_uploaded_file($file['tmp_name'], $uploadfile)) 
		{
	   	   $result = TRUE; 
		} else {
		   $result = FALSE;
		}
	} 
	if($result == FALSE) 
	{
		$return['message'] = "Upload Fail";
		$return['status'] = "304";
	}
	else
	{
		$return['message'] = "SUCCESS";
		$return['status'] = "200";	
		
	}
	echo json_encode($return);
	

?>