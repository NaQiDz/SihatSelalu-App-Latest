<?php
// Include database connection
require_once('dbconnect.php');
require_once('mailer.php'); // Include the PHPMailer setup file

// Disable direct error display
ini_set('display_errors', 0); // Show no errors to the user
ini_set('log_errors', 1); // Log errors to a file
error_reporting(E_ALL); // Report all errors

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");

// Start output buffering to prevent stray output
ob_start();

try {
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        // Retrieve email from POST data
        $email = isset($_POST['email']) ? trim($_POST['email']) : '';

        // Validate email
        if (empty($email) || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
            throw new Exception("Invalid email address.");
        }

        // Connect to the database
        $con = connectToDatabase();

        // Check if the email exists
        $query = "SELECT * FROM tbl_parent WHERE Email = ?";
        $stmt = $con->prepare($query);
        if (!$stmt) {
            throw new Exception("Database error: Unable to prepare statement.");
        }

        $stmt->bind_param('s', $email);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($result->num_rows === 0) {
            throw new Exception("Email not found.");
        }

        // Generate a verification code and expiry
        $verificationCode = mt_rand(100000, 999999);
        $expiryTime = date("Y-m-d H:i:s", strtotime("+15 minutes"));

        // Update database with the code and expiry
        $updateQuery = "UPDATE tbl_parent SET Reset_Code = ?, Reset_Expiry = ? WHERE Email = ?";
        $updateStmt = $con->prepare($updateQuery);
        if (!$updateStmt) {
            throw new Exception("Database error: Unable to prepare update statement.");
        }

        $updateStmt->bind_param('sss', $verificationCode, $expiryTime, $email);
        if (!$updateStmt->execute()) {
            throw new Exception("Failed to update verification code in the database.");
        }

        // Send the email using PHPMailer
        $subject = "Password Reset Verification Code";
        $message = "Your password reset verification code is: $verificationCode\nThis code will expire in 15 minutes.";

        // Dynamically set the recipient email (fetched from database)
        $mail->addAddress($email); // Send to the email retrieved from tbl_parent

        $mail->Subject = $subject;
        $mail->Body = $message;
        $mail->AltBody = strip_tags($message); // Plain text version for non-HTML email clients

        if (!$mail->send()) {
            throw new Exception("Failed to send the email: " . $mail->ErrorInfo);
        }

        // Success response
        echo json_encode([
            "status" => "success",
            "message" => "Verification email sent successfully."
        ]);
    } else {
        throw new Exception("Invalid request method.");
    }
} catch (Exception $e) {
    // Return error as JSON
    echo json_encode([
        "status" => "error",
        "message" => $e->getMessage()
    ]);
}

// Clean output buffer and send the response
ob_end_flush();
exit();
?> 
