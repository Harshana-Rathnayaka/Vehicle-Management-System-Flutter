<?php

session_start();
require_once '../includes/dbOperations.php';

$response = array();

if (
    isset($_POST['username']) && isset($_POST['email']) && isset($_POST['password'])
) {

    $username = $_POST['username'];
    $email = $_POST['email'];
    $password = $_POST['password'];

    // we can operate the data further
    $db = new DbOperations();

    $result = $db->registerUser($username, $email, $password);

    if ($result == 1) {

        // success
        $response['error'] = false;
        $response['message'] = "You have registered successfully, Please log in!";

    } elseif ($result == 2) {

        // some error
        $response['error'] = true;
        $response['message'] = "Something went wrong, please try again!";

    } elseif ($result == 0) {

        // user exists
        $response['error'] = true;
        $response['message'] = "It seems that this user already exists, please choose a different email and username.";

    }
} else {

    // missing fields
    $_SESSION['missing'] = "Required fields are missing.";
    $response['error'] = true;
    $response['message'] = "Required fields are missing";

}

// json output
echo json_encode($response);
