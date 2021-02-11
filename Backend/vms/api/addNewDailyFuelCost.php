<?php

require_once '../includes/dbOperations.php';

$response = array();

// check the method request
if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    // checking if all the values are being sent
    if (isset($_POST['addedBy']) && isset($_POST['vehicleNumber']) && isset($_POST['date']) && isset($_POST['gasType']) && isset($_POST['fuelPrice']) && isset($_POST['fuelCost'])) {

        // getting the values to the variables
        $addedBy = $_POST['addedBy'];
        $vehicleNumber = $_POST['vehicleNumber'];
        $date = $_POST['date'];
        $gasType = $_POST['gasType'];
        $fuelPrice = $_POST['fuelPrice'];
        $fuelCost = $_POST['fuelCost'];

        // db instance
        $db = new DbOperations();

        // inserting to the fuel_cost table
        $result = $db->createDailyFuelCost($addedBy, $vehicleNumber, $date, $gasType, $fuelPrice, $fuelCost);

        if ($result == 0) {

            // successfully uploaded to the db
            $response['error'] = false;
            $response['message'] = "New fuel cost added successfully!";

        } elseif ($result == 1) {
            // couldn't upload to the db
            $response['error'] = true;
            $response['message'] = "Something went wrong. Couldn't add the new fuel cost, please try again later!";

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
