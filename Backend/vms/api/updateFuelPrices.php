<?php

session_start();
require_once '../includes/dbOperations.php';

$response = array();

if (isset($_POST['gasType']) && isset($_POST['price'])) {

    $gasType = $_POST['gasType'];
    $price = trim($_POST['price']);

    // we can operate the data further
    $db = new DbOperations();

    $result = $db->updateFuelPrice($gasType, $price);

    if ($result == 0) {

        // success
        $response['error'] = false;
        $response['message'] = "Fuel price updated successfully!";

    } elseif ($result == 1) {

        // some error
        $response['error'] = true;
        $response['message'] = "Some error occured, please try again";

    }
} else {

    // missing fields
    $response['error'] = true;
    $response['message'] = "Required fields are missing";

}

// json output
echo json_encode($response);
