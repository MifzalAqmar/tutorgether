<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$bkid = $_POST['bkid'];


if (isset($_POST['bkid'])){
    $sqldelete = "DELETE FROM CART WHERE EMAIL = '$email' AND BKID='$bkid'";
}else{
    $sqldelete = "DELETE FROM CART WHERE EMAIL = '$email'";
}
    
    if ($conn->query($sqldelete) === TRUE){
       echo "success";
    }else {
        echo "failed";
    }
?>