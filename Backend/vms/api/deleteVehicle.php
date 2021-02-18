<?php

require_once '../includes/dbOperations.php';

$response = array();

// check the method request
if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    // checking if all the values are being sent
    if (isset($_POST['id'])) {

        // getting the values to the variables
        $vehicle_id = $_POST['id'];

        // db instance
        $db = new DbOperations();

        $result = $db->deleteVehicle($vehicle_id);

        if ($result == 0) {

            // vehicle deleted
            $response['error'] = false;
            $response['message'] = "Vehicle deleted successfully!";

        } elseif ($result == 1) {

            // couldn't delete
            $response['error'] = true;
            $response['message'] = "Something went wrong. Couldn't delete the vehicle.";

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
