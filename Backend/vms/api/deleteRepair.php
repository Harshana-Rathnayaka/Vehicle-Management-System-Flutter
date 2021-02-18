<?php

require_once '../includes/dbOperations.php';

$response = array();

// check the method request
if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    // checking if all the values are being sent
    if (isset($_POST['id'])) {

        // getting the values to the variables
        $repair_id = $_POST['id'];

        // db instance
        $db = new DbOperations();

        // inserting to the vehicles table
        $result = $db->deleteRepair($repair_id);

        if ($result == 0) {

            // driver deleted
            $response['error'] = false;
            $response['message'] = "Repair deleted successfully!";

        } elseif ($result == 1) {

            // couldn't delete
            $response['error'] = true;
            $response['message'] = "Something went wrong. Couldn't delete the repair.";

        }

    } else {

        // some fields are missing
        $response['error'] = true;
        $response['message'] = "Some fields are missing.";

    }

} else {
    // wrong method
    $response['error'] = true;
    $response['message'] = "Invalid Request";
}

// json output
echo json_encode($response);
