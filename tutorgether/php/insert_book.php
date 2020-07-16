<?php
error_reporting(0);
include_once ("dbconnect.php");
$bkid = $_POST['bkid'];
$bname  = ucwords($_POST['bname']);
$quantity  = $_POST['quantity'];
$price  = $_POST['price'];
$type  = $_POST['type'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$sold = '0';
$path = '../bookimage/'.$bkid.'.jpg';

$sqlinsert = "INSERT INTO BOOK(ID,NAME,PRICE,QUANTITY,TYPE,SOLD) VALUES ('$bkid','$bname','$price','$quantity','$type','$sold')";
$sqlsearch = "SELECT * FROM BOOK WHERE ID='$bkid'";
$resultsearch = $conn->query($sqlsearch);
if ($resultsearch->num_rows > 0)
{
    echo 'found';
}else{
if ($conn->query($sqlinsert) === true)
{
    if (file_put_contents($path, $decoded_string)){
        echo 'success';
    }else{
        echo 'failed';
    }
}
else
{
    echo "failed";
}    
}


?>