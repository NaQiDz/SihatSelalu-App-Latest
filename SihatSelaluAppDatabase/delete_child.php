<?php
// Database configuration
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "db_sihatselalu";

// Create a connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check the connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get the child_id from the POST request
if (isset($_POST['child_id'])) {
    $child_id = $_POST['child_id'];

    // Prepare the SQL query to delete the child by child_id
    $sql = "DELETE FROM `tbl_child` WHERE child_id  = ?";

    if ($stmt = $conn->prepare($sql)) {
        // Bind the parameter to the query
        $stmt->bind_param("i", $child_id); // "i" for integer

        // Execute the query
        if ($stmt->execute()) {
            // Return success response
            echo json_encode(["success" => true, "message" => "Child deleted successfully"]);
        } else {
            // Return failure response if query execution failed
            echo json_encode(["success" => false, "message" => "Failed to delete child"]);
        }

        // Close the prepared statement
        $stmt->close();
    } else {
        // Return error response if the SQL query is invalid
        echo json_encode(["success" => false, "message" => "Failed to prepare the SQL query"]);
    }
} else {
    // Return error response if no child_id is provided
    echo json_encode(["success" => false, "message" => "Child ID is required"]);
}

// Close the connection
$conn->close();
?>
