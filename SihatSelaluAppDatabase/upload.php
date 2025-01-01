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

// Get the username from the Flutter request (sent via POST)
$username_from_flutter = $_POST['username'] ?? '';

if (empty($username_from_flutter)) {
    echo json_encode(['error' => 'Username is required']);
    $conn->close();
    exit;
}

if (isset($_FILES['file'])) {
    $fileName = $_FILES['file']['name'];
    $fileTmpName = $_FILES['file']['tmp_name'];
    $fileSize = $_FILES['file']['size'];
    $fileError = $_FILES['file']['error'];
    $fileType = $_FILES['file']['type'];

    if ($fileError === 0) {
        $fileDestination = 'images/' . $fileName;
        move_uploaded_file($fileTmpName, $fileDestination);

        // Update the Icon field in tbl_parent for the specified user
        $sql = "UPDATE `tbl_parent` SET `Icon` = ? WHERE `Username` = ?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("ss", $fileDestination, $username_from_flutter);

        if ($stmt->execute()) {
            echo json_encode(["status" => "success", "url" => $fileDestination]);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Failed to update database']);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "File upload failed."]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "No file uploaded."]);
}

$conn->close();
?>
