<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

$host = "your-rds-endpoint";
$user = "admin";
$password = "yourpassword";
$database = "snake_game";

$conn = new mysqli($host, $user, $password, $database);
if ($conn->connect_error) {
    die(json_encode(["error" => "Database connection failed"]));
}

$result = $conn->query("SELECT username, score FROM scores ORDER BY score DESC LIMIT 10");
$scores = [];

while ($row = $result->fetch_assoc()) {
    $scores[] = $row;
}

echo json_encode($scores);

$conn->close();
?>
