<?php

class DbOperations
{

    private $con;

    public function __construct()
    {

        require_once dirname(__FILE__) . '/dbConnection.php';

        $db = new DbConnect();

        $this->con = $db->connect();
    }

    /* CRUD  -> C -> CREATE */

    // user registration
    public function registerUser($username, $email, $password)
    {
        if ($this->isUserExist($username, $email)) {
            // user exists
            return 0;
        } else {
            $stmt = $this->con->prepare("INSERT INTO `login` (`ID`, `User_Name`, `Password`, `Email`, `Issuper`) VALUES (NULL, ?, ?, ?, 0);");
            $stmt->bind_param("sss", $username, $password, $email);

            if ($stmt->execute()) {
                // user registered
                return 1;
            } else {
                // some error
                return 2;
            }
        }
    }

    // user login
    public function userLogin($username, $password)
    {
        $stmt = $this->con->prepare("SELECT * FROM `login` WHERE `User_Name` = ? AND `Password` = ?");
        $stmt->bind_param("ss", $username, $password);
        $stmt->execute();
        $stmt->store_result();
        return $stmt->num_rows > 0;
    }

    // adding new vehicle
    public function createVehicle($vehicleNumber, $vehicleType, $capacity, $gasType, $chassisNumber, $engineNumber, $ownership, $maintenance)
    {

        $stmt = $this->con->prepare("INSERT INTO `vehicletable`(`ID`, `Vehicle_No`, `Vehicle_Type`, `Capacity`, `Fuel_Type`, `Chassis_Number`, `Engine_Number`, `Ownership`, `Maintenance`) VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?);");
        $stmt->bind_param("ssssssss", $vehicleNumber, $vehicleType, $capacity, $gasType, $chassisNumber, $engineNumber, $ownership, $maintenance);

        if ($stmt->execute()) {
            // vehicle created
            return 0;
        } else {
            // some error
            return 1;
        }
    }

    // adding new driver
    public function createDriver($name, $licenseNumber, $contact)
    {

        $stmt = $this->con->prepare("INSERT INTO `drivers_reg`(`ID`, `Name`, `Licen_No`, `Contact`) VALUES (NULL, ?, ?, ?);");
        $stmt->bind_param("sss", $name, $licenseNumber, $contact);

        if ($stmt->execute()) {
            // driver created
            return 0;
        } else {
            // some error
            return 1;
        }
    }

    // adding new repair
    public function createRepair($vehicleNumber, $repairDetails, $date, $repairCost)
    {

        $stmt = $this->con->prepare("INSERT INTO `running_repair`(`ID`, `Vehicle_No`, `Repair`, `Date`, `Cost(Rs)`) VALUES (NULL, ?, ?, ?, ?);");
        $stmt->bind_param("ssss", $vehicleNumber, $repairDetails, $date, $repairCost);

        if ($stmt->execute()) {
            // repair created
            return 0;
        } else {
            // some error
            return 1;
        }
    }

    // adding new daily fuel cost
    public function createDailyFuelCost($addedBy, $vehicleNumber, $date, $gasType, $fuelPrice, $fuelCost)
    {

        $stmt = $this->con->prepare("INSERT INTO `fuel_cost`(`ID`, `Add_By`, `Vehicle_No`, `Date`, `Fuel_Type`, `Fuel_Price`, `Cost`) VALUES (NULL, ?, ?, ?, ?, ?, ?);");
        $stmt->bind_param("ssssss", $addedBy, $vehicleNumber, $date, $gasType, $fuelPrice, $fuelCost);

        if ($stmt->execute()) {
            // fuel cost created
            return 0;
        } else {
            // some error
            return 1;
        }
    }

    // adding new monthly fuel cost
    public function createMonthlyFuelCost($vehicleNumber, $selectedMonth, $startReadingValue, $endReadingValue, $totalDistance, $totalCost, $totalLiters, $average)
    {

        $stmt = $this->con->prepare("INSERT INTO `monthly_countdown`(`ID`, `Vehicle_No`, `Date`, `Start_of_Month`, `End_of_Month`, `Total Km`, `Amount`, `Liters`, `Average`) VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?);");
        $stmt->bind_param("ssssssss", $vehicleNumber, $selectedMonth, $startReadingValue, $endReadingValue, $totalDistance, $totalCost, $totalLiters, $average);

        if ($stmt->execute()) {
            // fuel cost created
            return 0;
        } else {
            // some error
            return 1;
        }
    }

    /* CRUD  -> r -> RETRIEVE */

    // retreiving user data by username
    public function getUserByUsername($username)
    {
        $stmt = $this->con->prepare("SELECT * FROM `login` WHERE `User_Name` = ?");
        $stmt->bind_param("s", $username);
        $stmt->execute();
        return $stmt->get_result()->fetch_assoc();
    }

    // checking if the user exists
    private function isUserExist($username, $email)
    {
        $stmt = $this->con->prepare("SELECT `ID` FROM `login` WHERE `User_Name` = ? OR Email = ?");
        $stmt->bind_param("ss", $username, $email);
        $stmt->execute();
        $stmt->store_result();
        return $stmt->num_rows > 0;
    }

    // retrieving vehicles table
    public function getVehicles()
    {
        $stmt = $this->con->prepare("SELECT * FROM `vehicletable`");
        $stmt->execute();
        return $stmt->get_result();
    }

    // retrieving drivers table
    public function getDrivers()
    {
        $stmt = $this->con->prepare("SELECT * FROM `drivers_reg`");
        $stmt->execute();
        return $stmt->get_result();
    }

    // retrieving repairs table
    public function getRepairs()
    {
        $stmt = $this->con->prepare("SELECT * FROM `running_repair`");
        $stmt->execute();
        return $stmt->get_result();
    }

    // retrieving daily fuel costs table
    public function getDailyFuelCosts()
    {
        $stmt = $this->con->prepare("SELECT * FROM `fuel_cost` ORDER BY `Date` DESC");
        $stmt->execute();
        return $stmt->get_result();
    }

    // retrieving monthly fuel costs table
    public function getMonthlyFuelCosts()
    {
        $stmt = $this->con->prepare("SELECT * FROM `monthly_countdown` ORDER BY `Date` ASC");
        $stmt->execute();
        return $stmt->get_result();
    }

    // retrieving the settings table
    public function getGasPrices()
    {
        $stmt = $this->con->prepare("SELECT * FROM `settings`");
        $stmt->execute();
        return $stmt->get_result();
    }

    /* CRUD  -> U -> UPDATE */

    // update fuel prices
    public function updateFuelPrice($gasType, $price)
    {
        if ($gasType == 'Petrol') {
            $stmt = $this->con->prepare("UPDATE `settings` SET `Petrol` = ? WHERE `ID` = 1");
        } else {
            $stmt = $this->con->prepare("UPDATE `settings` SET `Diesel` = ? WHERE `ID` = 1");
        }
        $stmt->bind_param("s", $price);

        if ($stmt->execute()) {
            // fuel price updated
            return 0;
        } else {
            // some error
            return 1;
        }
    }

    // updating driver details
    public function updateDrivers($driver_id, $name, $licenseNumber, $contact)
    {
        $stmt = $this->con->prepare("UPDATE `drivers_reg` SET `Name` = ?, `Licen_No` = ?, `Contact` = ? WHERE `ID` = ?");
        $stmt->bind_param("sssi", $name, $licenseNumber, $contact, $driver_id);

        if ($stmt->execute()) {
            // driver updated
            return 0;
        } else {
            // some error
            return 1;
        }
    }

    // updating repair details
    public function updateRepairs($repair_id, $details, $date, $cost)
    {
        $stmt = $this->con->prepare("UPDATE `running_repair` SET `Repair` = ?, `Date` = ?, `Cost(Rs)` = ? WHERE `ID` = ?");
        $stmt->bind_param("sssi", $details, $date, $cost, $repair_id);

        if ($stmt->execute()) {
            // repair updated
            return 0;
        } else {
            // some error
            return 1;
        }
    }

    /* CRUD  -> D -> DELETE */

    // delete driver
    public function deleteDriver($driver_id)
    {
        $stmt = $this->con->prepare("DELETE FROM `drivers_reg` WHERE `ID` = ?");
        $stmt->bind_param("i", $driver_id);

        if ($stmt->execute()) {
            // driver deleted
            return 0;
        } else {
            // some error
            return 1;
        }
    }

    // delete repair
    public function deleteRepair($repair_id)
    {
        $stmt = $this->con->prepare("DELETE FROM `running_repair` WHERE `ID` = ?");
        $stmt->bind_param("i", $repair_id);

        if ($stmt->execute()) {
            // repair deleted
            return 0;
        } else {
            // some error
            return 1;
        }
    }
}
