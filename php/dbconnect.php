<?php
$servername = "localhost";
$username   = "id12930486_tutorgether";
$password   = "TutorGether123";
$dbname     = "id12930486_tutorgether";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 
?> 