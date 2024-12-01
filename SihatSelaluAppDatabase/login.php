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
    	isset($data['password'])
    ) {
        $username = mysqli_real_escape_string($con, $data['username']);
        $password = $data['password'];

        // Query to fetch user details
        $query = "SELECT * FROM `tbl_parent` WHERE `Username` = '$username'";
        $result = mysqli_query($con, $query);

        if ($result && mysqli_num_rows($result) > 0) {
            $user = mysqli_fetch_assoc($result);

            // Verify password
            if (password_verify($password, $user['Password'])){
                echo json_encode([
                    "success" => "true",
                    "message" => "Login successful",
                    "data" => [
                        "username" => $user['Username'],
                        "email" => $user['Email'],
                        "age" => $user['Age'],
                        "gender" => $user['Gender']
                    ]
                ]);
            } else {
                echo json_encode(["success" => "false", "message" => "Incorrect password"]);
            }
        } else {
            echo json_encode(["success" => "false", "message" => "User not found"]);
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
