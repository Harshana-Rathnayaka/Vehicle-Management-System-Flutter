<?php

require_once '../includes/dbOperations.php';
$response = array();

if (isset($_POST['list_type'])) {
    $list_type = $_POST['list_type'];

    // db object
    $db = new DbOperations();

    if ($list_type == 'gas') {
        // gas prices
        $prices = $db->getGasPrices();
        if ($prices->num_rows > 0) {
            while ($row = $prices->fetch_assoc()) {
                $response['petrolPrice'] = $row['Petrol'];
                $response['dieselPrice'] = $row['Diesel'];
            }
        } else {
            $response['repairsList'] = [];
        }
    } elseif ($list_type == 'vehicles') {
        // vehicles table
        $vehicles = $db->getVehicles();
        $vehicleList = array();
        if ($vehicles->num_rows > 0) {
            while ($row = $vehicles->fetch_assoc()) {
                $vehicleList[] = $row;
                $response['vehicleList'] = $vehicleList;
            }
        } else {
            $response['repairsList'] = [];
        }
    } elseif ($list_type == 'drivers') {
        // drivers table
        $drivers = $db->getDrivers();
        $driverList = array();
        if ($drivers->num_rows > 0) {
            while ($row = $drivers->fetch_assoc()) {
                $driverList[] = $row;
                $response['driverList'] = $driverList;
            }
        } else {
            $response['repairsList'] = [];
        }
    } elseif ($list_type == 'repairs') {
        // repairs table
        $repairs = $db->getRepairs();
        $repairsList = array();
        if ($repairs->num_rows > 0) {
            while ($row = $repairs->fetch_assoc()) {
                $repairsList[] = $row;
                $response['repairsList'] = $repairsList;
            }
        } else {
            $response['repairsList'] = [];
        }
    }
}

echo json_encode($response);
