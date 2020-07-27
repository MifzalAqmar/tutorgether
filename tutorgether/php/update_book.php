<?php
error_reporting(0);
include_once("dbconnect.php");

$email = $_POST['email'];
$bkid = $_POST['bkid'];
$quantity = $_POST['quantity'];

$sqlupdate = "UPDATE BOOK SET QUANTITY = '$quantity' WHERE ID = '$bkid'";

if ($conn->query($sqlupdate) === true)
{
    echo "success";
}
else
{
    echo "failed";
}
    
$conn->close();
?>