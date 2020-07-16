<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$bkid = $_POST['bkid'];
$userquantity = $_POST['quantity'];

$sqlsearch = "SELECT * FROM CART WHERE EMAIL = '$email' AND BKID= '$bkid'";

$result = $conn->query($sqlsearch);
if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        $bquantity = $row["CQUANTITY"];
    }
    $bquantity = $bquantity + $userquantity;
    $sqlinsert = "UPDATE CART SET CQUANTITY = '$bquantity' WHERE BKID = '$bkid' AND EMAIL = '$email'";
    
}else{
    $sqlinsert = "INSERT INTO CART(EMAIL,BKID,CQUANTITY) VALUES ('$email','$bkid',$userquantity)";
}

if ($conn->query($sqlinsert) === true)
{
    $sqlquantity = "SELECT * FROM CART WHERE EMAIL = '$email'";

    $resultq = $conn->query($sqlquantity);
    if ($resultq->num_rows > 0) {
        $quantity = 0;
        while ($row = $resultq ->fetch_assoc()){
            $quantity = $row["CQUANTITY"] + $quantity;
        }
    }

    $quantity = $quantity;
    echo "success,".$quantity;
}
else
{
    echo "failed";
}

?>