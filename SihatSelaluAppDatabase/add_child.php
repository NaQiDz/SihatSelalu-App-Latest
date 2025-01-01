<?php
header('Content-Type: application/json');
// Database credentials (CHANGE THESE TO YOUR ACTUAL CREDENTIALS)
$servername = "localhost";
$username = "root"; // Default XAMPP username
$password = ""; // Default XAMPP password (empty)
$dbname = "db_sihatselalu";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $name = $_POST['name'] ?? null;
    $fullname = $_POST['fullname'] ?? null;
    $gender = $_POST['gender'] ?? null;
    $birthdate = $_POST['birthdate'] ?? null;
    $parentid = $_POST['parentid'] ?? null;

    if ($name && $fullname && $gender && $birthdate && $parentid) {
        include("dbconnect.php");

        if ($conn->connect_error) {
            echo json_encode(['success' => false, 'message' => 'Database connection failed']);
            exit;
        }

        $stmt = $conn->prepare("INSERT INTO `tbl_child`(`child_fullname`, `child_username`, `child_gender`, `child_dateofbirth`, `parent_id`) VALUES (?, ?, ?, ?, ?)");
        $stmt->bind_param('sssss', $fullname, $name, $gender, $birthdate, $parentid);

        if ($stmt->execute()) {
            echo json_encode(['success' => true, 'message' => 'Child added successfully']);

        } else {
            echo json_encode(['success' => false, 'message' => 'Failed to insert data']);
        }

        $stmt->close();
        $conn->close();
    } else {
        echo json_encode(['success' => false, 'message' => 'Invalid input']);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Invalid request method']);
}

?>
