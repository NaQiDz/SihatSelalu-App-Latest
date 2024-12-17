<?php
require_once('dbconnect.php');
header('Content-Type: application/json');

// Retrieve the verification code and new password from the client
$code = isset($_POST['code']) ? trim($_POST['code']) : '';
$newPassword = isset($_POST['new_password']) ? trim($_POST['new_password']) : '';

// Check for empty inputs
if (empty($code) || empty($newPassword)) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Verification code and new password are required.'
    ]);
    exit();
}

// Check if the password meets the minimum length requirement
if (strlen($newPassword) < 8) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Password must be at least 8 characters long.'
    ]);
    exit();
}

// Connect to the database
$con = connectToDatabase();

// Prepare a query to check if the Reset_Code exists and is valid
$query = "SELECT * FROM tbl_parent WHERE Reset_Code = ?";
$stmt = $con->prepare($query);

if (!$stmt) {
    error_log("Database error: Unable to prepare statement. Error: " . $con->error);
    echo json_encode([
        'status' => 'error',
        'message' => 'Internal server error.'
    ]);
    exit();
}

$stmt->bind_param('s', $code);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Invalid verification code. Please try again.'
    ]);
    exit();
}

$row = $result->fetch_assoc();
$expiry = $row['Reset_Expiry'];
$currentDateTime = date('Y-m-d H:i:s');

// Check if the verification code has expired
if ($currentDateTime > $expiry) {
    echo json_encode([
        'status' => 'error',
        'message' => 'The verification code has expired.'
    ]);
    exit();
}

// If the code is valid, update the password
$hashedPassword = password_hash($newPassword, PASSWORD_BCRYPT);
$updateQuery = "UPDATE tbl_parent SET Password = ? WHERE Reset_Code = ?";
$updateStmt = $con->prepare($updateQuery);

if (!$updateStmt) {
    error_log("Database error: Unable to prepare update statement. Error: " . $con->error);
    echo json_encode([
        'status' => 'error',
        'message' => 'Internal server error.'
    ]);
    exit();
}

$updateStmt->bind_param('ss', $hashedPassword, $code);
$updateSuccess = $updateStmt->execute();

if ($updateSuccess) {
    echo json_encode([
        'status' => 'success',
        'message' => 'Password has been reset successfully.'
    ]);
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Failed to reset the password. Please try again later.'
    ]);
}

// Close statements and connection
$stmt->close();
$updateStmt->close();
$con->close();
?>
