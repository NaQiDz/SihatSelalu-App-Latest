<?php

include("dbconnect.php");

header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $data = json_decode(file_get_contents("php://input"), true);

    // Validate database connection
    $con = connectToDatabase();
    if (!$con) {
        echo json_encode(["status" => "error", "message" => "Database connection failed"]);
        exit();
    }

    // Validate input
    if (
        isset($data['username']) &&
        isset($data['email']) &&
        isset($data['age']) &&
        isset($data['gender']) &&
        isset($data['password'])
    ) {
        $username = mysqli_real_escape_string($con, $data['username']);
        $email = mysqli_real_escape_string($con, $data['email']);
        $age = intval($data['age']);
        $gender = mysqli_real_escape_string($con, $data['gender']);
        $password = password_hash($data['password'], PASSWORD_BCRYPT); // Encrypt the password

        // Insert query
        $query = "INSERT INTO `tbl_parent`(`Username`, `Email`, `Age`, `Gender`, `Password`) 
        		  VALUES ('$username', '$email', '$age', '$gender', '$password')";

        if (mysqli_query($con, $query)) {
            echo json_encode(["success" => "true", "message" => "User registered successfully"]);
        } else {
            echo json_encode(["success" => "false", "message" => "Failed to register user"]);
        }

        // Close the database connection
        mysqli_close($con);
    } else {
        echo json_encode(["success" => "false", "message" => "Invalid input"]);
    }
} else {
    echo json_encode(["success" => "false", "message" => "Invalid request method"]);
}

?>
