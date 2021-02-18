<?php

require_once '../includes/dbOperations.php';

$response = array();

if (isset($_POST['id']) && isset($_POST['name']) && isset($_POST['licenseNumber']) && isset($_POST['contact'])) {

    $driver_id = $_POST['id'];
    $name = trim($_POST['name']);
    $licenseNumber = trim($_POST['licenseNumber']);
    $contact = trim($_POST['contact']);

    // we can operate the data further
    $db = new DbOperations();

    $result = $db->updateDrivers($driver_id, $name, $licenseNumber, $contact);

    if ($result == 0) {

        // success
        $response['error'] = false;
        $response['message'] = "Driver details updated successfully!";

    } elseif ($result == 1) {

        // some error
        $response['error'] = true;
        $response['message'] = "Some error occured, please try again!";

    }
} else {

    // missing fields
    $response['error'] = true;
    $response['message'] = "Required fields are missing";

}

// json output
echo json_encode($response);
