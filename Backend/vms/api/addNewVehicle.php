<?php

require_once '../includes/dbOperations.php';

$response = array();

// check the method request
if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    // checking if all the values are being sent
    if (isset($_POST['vehicleNumber']) && isset($_POST['vehicleType']) && isset($_POST['capacity'])
        && isset($_POST['gasType']) && isset($_POST['chassisNumber']) && isset($_POST['engineNumber'])
        && isset($_POST['ownership']) && isset($_POST['maintenance'])) {

        // getting the values to the variables
        $vehicleNumber = $_POST['vehicleNumber'];
        $vehicleType = $_POST['vehicleType'];
        $capacity = $_POST['capacity'];
        $gasType = $_POST['gasType'];
        $chassisNumber = $_POST['chassisNumber'];
        $engineNumber = $_POST['engineNumber'];
        $ownership = $_POST['ownership'];
        $maintenance = $_POST['maintenance'];

        // db instance
        $db = new DbOperations();

        // inserting to the vehicles table
        $result = $db->createVehicle($vehicleNumber, $vehicleType, $capacity, $gasType, $chassisNumber, $engineNumber, $ownership, $maintenance);

        if ($result == 0) {

            // successfully uploaded to the db
            $response['error'] = false;
            $response['message'] = "New vehicle added successfully!";

        } elseif ($result == 1) {
            // couldn't upload to the db
            $response['error'] = true;
            $response['message'] = "Something went wrong. Couldn't add the new vehicle.";

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
