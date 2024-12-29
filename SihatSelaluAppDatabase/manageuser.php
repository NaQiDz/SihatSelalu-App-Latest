<?php
header("Access-Control-Allow-Origin: *"); // For testing only - REMOVE IN PRODUCTION
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

// Database credentials (CHANGE THESE TO YOUR ACTUAL CREDENTIALS)
$servername = "localhost";
$username = "root"; // Default XAMPP username
$password = ""; // Default XAMPP password (empty)
$dbname = "db_sihatselalu";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode(['error' => 'Database connection failed: ' . $conn->connect_error]));
}

$username_from_flutter = $_POST['username'] ?? ''; 

if (empty($username_from_flutter)) {
    echo json_encode(['error' => 'Username is required']);
    $conn->close();
    exit;
}

// SQL query (using prepared statement)
$sql = "SELECT `User_ID`, `token`, `Username`, `Email`, `PhoneNum`, `Age`, `Gender`, `Password`, `Icon` FROM `tbl_parent` WHERE `Username` = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $username_from_flutter);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();
    echo json_encode($user);
} else {
    echo json_encode(['message' => 'User not found']);
}

$stmt->close();
$conn->close();
?>