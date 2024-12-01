<?php

header("Content-Type: application/json");

function connectToDatabase() {
    // Database credentials
    $host = "localhost";
    $username = "root";
    $password = "";
    $database = "db_sihatselalu";

    // Create connection
    $con = mysqli_connect($host, $username, $password, $database);

    // Check connection
    if (!$con) {
        // Log error (optional)
        error_log("Database connection error: " . mysqli_connect_error());

        // Return error response
        echo json_encode([
            "status" => "error",
            "message" => "Failed to connect to the database: " . mysqli_connect_error()
        ]);
        exit();
    }

    return $con;
}

?>
