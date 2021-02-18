<?php

require_once '../includes/dbOperations.php';

$response = array();

if (isset($_POST['id']) && isset($_POST['details']) && isset($_POST['date']) && isset($_POST['cost'])) {

    $repair_id = $_POST['id'];
    $details = trim($_POST['details']);
    $date = trim($_POST['date']);
    $cost = trim($_POST['cost']);

    // we can operate the data further
    $db = new DbOperations();

    $result = $db->updateRepairs($repair_id, $details, $date, $cost);

    if ($result == 0) {

        // success
        $response['error'] = false;
        $response['message'] = "Repair details updated successfully!";

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
