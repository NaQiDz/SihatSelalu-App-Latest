<?php
$servername = "localhost";
$username = "root"; // Default XAMPP username
$password = ""; // Default XAMPP password (empty)
$dbname = "db_sihatselalu";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $child_id = $_POST['child_id']; // The child ID
    $fullname = isset($_POST['fullname']) ? $_POST['fullname'] : null;
    $name = isset($_POST['name']) ? $_POST['name'] : null;
    $gender = isset($_POST['gender']) ? $_POST['gender'] : null;
    $birthday = isset($_POST['birthday']) ? $_POST['birthday'] : null;

    $updates = [];
    if ($fullname) $updates[] = "child_fullname = '$fullname'";
    if ($name) $updates[] = "child_username = '$name'";
    if ($gender) $updates[] = "child_gender = '$gender'";
    if ($birthday) $updates[] = "child_dateofbirth = '$birthday'";

    if (count($updates) > 0) {
        $query = "UPDATE tbl_child SET " . implode(", ", $updates) . " WHERE child_id = '$child_id'";

        if (mysqli_query($conn, $query)) {
            echo json_encode(['success' => true, 'message' => 'Child information updated successfully']);
        } else {
            echo json_encode(['success' => false, 'message' => 'Error updating child']);
        }
    } else {
        echo json_encode(['success' => false, 'message' => 'No data to update']);
    }
}
?>
