<?php

require_once '../includes/dbOperations.php';

$response = array();

if (isset($_POST['username']) and isset($_POST['password'])) {

    $username = $_POST['username'];
    $password = $_POST['password'];

    // db object
    $db = new DbOperations();

    if ($db->userLogin($username, $password)) {

        // getting user data
        $user = $db->getUserByUsername($username);

        // super user
        if ($user['Issuper'] == 1) {

            $response['error'] = false;
            $response['super_user'] = true;
            $response['user_id'] = $user['ID'];
            $response['username'] = $user['User_Name'];
            $response['email'] = $user['Email'];

            // normal user
        } elseif ($user['Issuper'] == 0) {

            $response['error'] = false;
            $response['super_user'] = false;
            $response['user_id'] = $user['ID'];
            $response['username'] = $user['User_Name'];
            $response['email'] = $user['Email'];

        }

    } else {

        // incorrect username or password
        $response['error'] = true;
        $response['message'] = "The username or password you entered is incorrect. Please check again.";

    }
} else {

    // missing fields
    $response['error'] = true;
    $response['message'] = "Required fields are missing";

}

// json output
echo json_encode($response);
