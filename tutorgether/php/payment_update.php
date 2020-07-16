<?php
error_reporting(0);
include_once("dbconnect.php");
$userid = $_GET['userid'];
$mobile = $_GET['mobile'];
$amount = $_GET['amount'];
$orderid = $_GET['orderid'];

$data = array(
    'id' =>  $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'] ,
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$paidstatus = $_GET['billplz']['paid'];
if ($paidstatus=="true"){
    $paidstatus = "Success";
}else{
    $paidstatus = "Failed";
}
$receiptid = $_GET['billplz']['id'];
$signing = '';
foreach ($data as $key => $value) {
    $signing.= 'billplz'.$key . $value;
    if ($key === 'paid') {
        break;
    } else {
        $signing .= '|';
    }
}
 
 
$signed= hash_hmac('sha256', $signing, 'S-aTQIRy1BnAKAnYiNdynzRQ');
if ($signed === $data['x_signature']) {

    if ($paidstatus == "Success"){
        
        $sqlcart = "SELECT BKID,CQUANTITY FROM CART WHERE EMAIL = '$userid'";
        $cartresult = $conn->query($sqlcart);
        if ($cartresult->num_rows > 0)
        {
        while ($row = $cartresult->fetch_assoc())
        {
            $bkid = $row["BKID"];
            $cq = $row["CQUANTITY"];
            $sqlinsertcarthistory = "INSERT INTO CARTHISTORY(EMAIL,ORDERID,BILLID,BKID,CQUANTITY) VALUES ('$userid','$orderid','$receiptid','$bkid','$cq')";
            $conn->query($sqlinsertcarthistory);
            
            $selectbook = "SELECT * FROM BOOK WHERE ID = '$bkid'";
            $bookresult = $conn->query($selectbook);
             if ($bookresult->num_rows > 0){
                  while ($rowp = $bookresult->fetch_assoc()){
                    $bquantity = $rowp["QUANTITY"];
                    $newquantity = $bquantity - $cq;
                    $sqlupdatequantity = "UPDATE BOOK SET QUANTITY = '$newquantity' WHERE ID = '$bkid'";
                    $conn->query($sqlupdatequantity);
                  }
             }
        }
        
       $sqldeletecart = "DELETE FROM CART WHERE EMAIL = '$userid'";
       $sqlinsert = "INSERT INTO PAYMENT(ORDERID,BILLID,USERID,TOTAL) VALUES ('$orderid','$receiptid','$userid','$amount')";
       
       $conn->query($sqldeletecart);
       $conn->query($sqlinsert);
    }
        echo '<br><br><body><div><h2><br><br><center>Receipt</center></h1><table border=1 width=80% align=center><tr><td>Order id</td><td>'.$orderid.'</td></tr><tr><td>Receipt ID</td><td>'.$receiptid.'</td></tr><tr><td>Email to </td><td>'.$userid. ' </td></tr><td>Amount </td><td>RM '.$amount.'</td></tr><tr><td>Payment Status </td><td>'.$paidstatus.'</td></tr><tr><td>Date </td><td>'.date("d/m/Y").'</td></tr><tr><td>Time </td><td>'.date("h:i a").'</td></tr></table><br><p><center>Press back button to return to TutorGether</center></p></div></body>';
        //echo $sqlinsertcarthistory;
    } 
        else 
    {
    echo 'Not Match!';
    }
}

?>