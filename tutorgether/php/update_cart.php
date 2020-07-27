<?php
error_reporting(0);
include_once("dbconnect.php");

$email = $_POST['email'];
$bkid = $_POST['bkid'];
$quantity = $_POST['quantity'];

$sqlupdate = "UPDATE CART SET CQUANTITY = '$quantity' WHERE EMAIL = '$email' AND BKID = '$bkid'";

if ($conn->query($sqlupdate) === true)
{
    echo "success,".$quantity;;
}
else
{
    echo "failed";
}
    
$conn->close();
?>