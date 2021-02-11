<?php

require_once '../includes/dbOperations.php';

$response = array();

// check the method request
if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    // checking if all the values are being sent
    if (isset($_POST['vehicleNumber']) && isset($_POST['selectedMonth']) && isset($_POST['startReadingValue']) && isset($_POST['endReadingValue']) && isset($_POST['totalDistance']) && isset($_POST['totalCost']) && isset($_POST['totalLiters']) && isset($_POST['average'])) {

        // getting the values to the variables
        $vehicleNumber = $_POST['vehicleNumber'];
        $selectedMonth = $_POST['selectedMonth'];
        $startReadingValue = $_POST['startReadingValue'];
        $endReadingValue = $_POST['endReadingValue'];
        $totalDistance = $_POST['totalDistance'];
        $totalCost = $_POST['totalCost'];
        $totalLiters = $_POST['totalLiters'];
        $average = $_POST['average'];

        // db instance
        $db = new DbOperations();

        // inserting to the monthly_countdown table
        $result = $db->createMonthlyFuelCost($vehicleNumber, $selectedMonth, $startReadingValue, $endReadingValue, $totalDistance, $totalCost, $totalLiters, $average);

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
