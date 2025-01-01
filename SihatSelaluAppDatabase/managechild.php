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

$childid_from_flutter = $_POST['childid'] ?? ''; 

if (empty($childid_from_flutter)) {
    echo json_encode(['error' => 'User id is required']);
    $conn->close();
    exit;
}

// SQL query (using prepared statement)
$sql = "SELECT `child_id`, `child_fullname`, `child_username`, `child_gender`, `child_dateofbirth`, `child_current_weight`, `child_current_height`, `parent_id` FROM `tbl_child` WHERE `child_id` = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $childid_from_flutter);
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