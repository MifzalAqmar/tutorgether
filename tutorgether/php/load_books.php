<?php
error_reporting(0);
include_once ("dbconnect.php");
$type = $_POST['type'];
$name = $_POST['name'];

if (isset($type)){
    if ($type == "Recent"){
        $sql = "SELECT * FROM BOOK ORDER BY DATE DESC lIMIT 20";    
    }else{
        $sql = "SELECT * FROM BOOK WHERE TYPE = '$type'";    
    }
}else{
    $sql = "SELECT * FROM BOOK ORDER BY DATE DESC lIMIT 20";    
}
if (isset($name)){
   $sql = "SELECT * FROM BOOK WHERE NAME LIKE  '%$name%'";
}


$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["books"] = array();
    while ($row = $result->fetch_assoc())
    {
        $booklist = array();
        $booklist["id"] = $row["ID"];
        $booklist["name"] = $row["NAME"];
        $booklist["price"] = $row["PRICE"];
        $booklist["quantity"] = $row["QUANTITY"];
        $booklist["type"] = $row["TYPE"];
        array_push($response["books"], $booklist);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>
