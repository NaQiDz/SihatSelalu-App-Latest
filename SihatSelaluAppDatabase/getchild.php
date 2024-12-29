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
    die(json_encode(['status' => 'error', 'message' => 'Database connection failed: ' . $conn->connect_error]));
}

$userid = $_POST['user_id'] ?? ''; 

if (empty($userid)) {
    echo json_encode(['status' => 'error', 'message' => 'User ID is required']);
    $conn->close();
    exit;
}

// SQL query (using prepared statement)
$sql = "SELECT `child_id`, `child_fullname`, `child_username`, `child_gender`, `child_dateofbirth`, `child_current_weight`, `child_current_height`, `parent_id` FROM `tbl_child` WHERE `parent_id` = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $userid);
$stmt->execute();
$result = $stmt->get_result();

$children = [];
if ($result->num_rows > 0) {
    // Fetch all rows and store them in the $children array
    while ($row = $result->fetch_assoc()) {
        $children[] = [
            'child_id' => $row['child_id'],
            'child_fullname' => $row['child_fullname'],
            'child_username' => $row['child_username'],
            'child_gender' => $row['child_gender'],
            'child_dateofbirth' => $row['child_dateofbirth'],
            'child_current_weight' => $row['child_current_weight'],
            'child_current_height' => $row['child_current_height'],
        ];
    }

    // Send the response with the children data
    echo json_encode(['status' => 'success', 'data' => $children]);
} else {
    echo json_encode(['status' => 'error', 'message' => 'No children found']);
}

$stmt->close();
$conn->close();
?>
