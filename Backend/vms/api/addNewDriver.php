<?php

require_once '../includes/dbOperations.php';

$response = array();

// check the method request
if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    // checking if all the values are being sent
    if (isset($_POST['name']) && isset($_POST['licenseNumber']) && isset($_POST['contact'])) {

        // getting the values to the variables
        $name = $_POST['name'];
        $licenseNumber = $_POST['licenseNumber'];
        $contact = $_POST['contact'];


        // db instance
        $db = new DbOperations();

        // inserting to the vehicles table
        $result = $db->createDriver($name, $licenseNumber, $contact);

        if ($result == 0) {

            // successfully uploaded to the db
            $response['error'] = false;
            $response['message'] = "New driver added successfully!";

        } elseif ($result == 1) {
            // couldn't upload to the db
            $response['error'] = true;
            $response['message'] = "Something went wrong. Couldn't add the new driver.";

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

