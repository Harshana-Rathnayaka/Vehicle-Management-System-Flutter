<?php

require_once '../includes/dbOperations.php';

$response = array();

// check the method request
if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    // checking if all the values are being sent
    if (isset($_POST['vehicleNumber']) && isset($_POST['repairDetails']) && isset($_POST['date']) && isset($_POST['repairCost'])) {

        // getting the values to the variables
        $vehicleNumber = $_POST['vehicleNumber'];
        $repairDetails = $_POST['repairDetails'];
        $date = $_POST['date'];
        $repairCost = $_POST['repairCost'];


        // db instance
        $db = new DbOperations();

        // inserting to the vehicles table
        $result = $db->createRepair($vehicleNumber, $repairDetails, $date, $repairCost);

        if ($result == 0) {

            // successfully uploaded to the db
            $response['error'] = false;
            $response['message'] = "New repair added successfully!";

        } elseif ($result == 1) {
            // couldn't upload to the db
            $response['error'] = true;
            $response['message'] = "Something went wrong. Couldn't add the new repair, please try again later!";

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

