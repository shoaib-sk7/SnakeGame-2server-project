<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

$host = "your-rds-endpoint";
$user = "admin";
$password = "yourpassword";
$database = "snake_game";

$conn = new mysqli($host, $user, $password, $database);
if ($conn->connect_error) {
    die("Database connection failed: " . $conn->connect_error);
}

$username = $_POST['username'] ?? '';
$score = $_POST['score'] ?? 0;

if (!empty($username) && is_numeric($score)) {
    $stmt = $conn->prepare("INSERT INTO scores (username, score) VALUES (?, ?)");
    $stmt->bind_param("si", $username, $score);
    $stmt->execute();
    echo "Score submitted!";
    $stmt->close();
} else {
    echo "Invalid data!";
}

$conn->close();
?>
