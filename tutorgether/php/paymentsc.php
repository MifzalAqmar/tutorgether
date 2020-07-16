<?php
error_reporting(0);
include_once("dbconnect.php");
$userid = $_POST['userid'];
$amount = $_POST['amount'];
$orderid = $_POST['orderid'];
$newcr = $_POST['newcr'];
$receiptid ="storecr";

 $sqlcart ="SELECT CART.BKID, CART.CQUANTITY, BOOK.PRICE FROM CART INNER JOIN BOOK ON CART.BKID = BOOK.ID WHERE CART.EMAIL = '$userid'";
        $cartresult = $conn->query($sqlcart);
        if ($cartresult->num_rows > 0)
        {
        while ($row = $cartresult->fetch_assoc())
        {
            $bkid = $row["BKID"];
            $cq = $row["CQUANTITY"]; //cart qty
            $pr = $row["PRICE"];
            $sqlinsertcarthistory = "INSERT INTO CARTHISTORY(EMAIL,ORDERID,BILLID,BKID,CQUANTITY,PRICE) VALUES ('$userid','$orderid','$receiptid','$bkid','$cq','$pr')";
            $conn->query($sqlinsertcarthistory);
            
            $selectproduct = "SELECT * FROM BOOK WHERE ID = '$bkid'";
            $productresult = $conn->query($selectproduct);
             if ($productresult->num_rows > 0){
                  while ($rowp = $productresult->fetch_assoc()){
                    $prquantity = $rowp["QUANTITY"];
                    $prevsold = $rowp["SOLD"];
                    $newquantity = $prquantity - $cq; //quantity in store - quantity ordered by user
                    $newsold = $prevsold + $cq;
                    $sqlupdatequantity = "UPDATE BOOK SET QUANTITY = '$newquantity', SOLD = '$newsold' WHERE ID = '$bkid'";
                    $conn->query($sqlupdatequantity);
                  }
             }
        }
        
       $sqldeletecart = "DELETE FROM CART WHERE EMAIL = '$userid'";
       $sqlinsert = "INSERT INTO PAYMENT(ORDERID,BILLID,USERID,TOTAL) VALUES ('$orderid','$receiptid','$userid','$amount')";
        $sqlupdatecredit = "UPDATE USER SET CREDIT = '$newcr' WHERE EMAIL = '$userid'";
        
       $conn->query($sqldeletecart);
       $conn->query($sqlinsert);
       $conn->query($sqlupdatecredit);
       echo "success";
        }else{
            echo "failed";
        }

?>