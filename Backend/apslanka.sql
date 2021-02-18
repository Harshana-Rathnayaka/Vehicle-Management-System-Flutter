-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Feb 18, 2021 at 06:24 PM
-- Server version: 10.5.4-MariaDB
-- PHP Version: 7.1.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `apslanka`
--
CREATE DATABASE IF NOT EXISTS `apslanka` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `apslanka`;

-- --------------------------------------------------------

--
-- Table structure for table `drivers_reg`
--

DROP TABLE IF EXISTS `drivers_reg`;
CREATE TABLE IF NOT EXISTS `drivers_reg` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(100) NOT NULL,
  `Licen_No` varchar(100) NOT NULL,
  `Contact` varchar(10) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `drivers_reg`
--

INSERT INTO `drivers_reg` (`ID`, `Name`, `Licen_No`, `Contact`) VALUES
(11, 'Test Driver 1', '56255625', '0112772772'),
(12, 'Test Driver 2', '154248454', '2348472485'),
(13, 'Test Driver 3', '074638263', '0780454945'),
(14, 'Test Driver 4', '526362352', '0776455248');

-- --------------------------------------------------------

--
-- Table structure for table `fuel_cost`
--

DROP TABLE IF EXISTS `fuel_cost`;
CREATE TABLE IF NOT EXISTS `fuel_cost` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Add_By` varchar(100) NOT NULL,
  `Vehicle_No` varchar(20) NOT NULL,
  `Date` date NOT NULL,
  `Fuel_Type` varchar(10) NOT NULL,
  `Fuel_Price` varchar(20) NOT NULL,
  `Cost` varchar(20) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `fuel_cost`
--

INSERT INTO `fuel_cost` (`ID`, `Add_By`, `Vehicle_No`, `Date`, `Fuel_Type`, `Fuel_Price`, `Cost`) VALUES
(44, 'Lakshitha', 'KT 8603', '2020-09-27', 'Petrol', '130', '1500'),
(45, 'Lakshitha', 'KT 8603', '2020-09-23', 'Petrol', '130', '2000'),
(46, 'Lakshitha', 'KT 8603', '2020-10-09', 'Petrol', '130', '1300'),
(47, 'Lakshitha', 'KT 8603', '2020-11-19', 'Petrol', '130', '2700'),
(48, 'Lakshitha', 'TEST-01', '2021-02-13', 'Petrol', '138.00', '4500.00'),
(49, 'Romesh', 'BDM0944', '2021-02-15', 'Diesel', '130.00', '2000.00'),
(50, 'Prabath', 'BDM0944', '2021-02-28', 'Petrol', '138.00', '1500.00'),
(51, 'Romesh', 'KT 8603', '2021-02-28', 'Petrol', '138.00', '2000.00'),
(52, 'Prabath', 'KT 8603', '2021-02-25', 'Diesel', '130.00', '5000.00'),
(53, 'Romesh', 'TEST-02', '2021-02-27', 'Diesel', '130.00', '2500.00'),
(54, 'Prabath', 'TEST-01', '2021-02-13', 'Petrol', '138.00', '1500.00'),
(55, 'Romesh', 'BDM0944', '2021-02-14', 'Petrol', '138.00', '3000.00');

-- --------------------------------------------------------

--
-- Table structure for table `fuel_usage`
--

DROP TABLE IF EXISTS `fuel_usage`;
CREATE TABLE IF NOT EXISTS `fuel_usage` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Vehicle_No` varchar(10) NOT NULL,
  `Time_Duration` varchar(10) NOT NULL,
  `Total_Mileage` varchar(20) NOT NULL,
  `Total_Fuel` varchar(20) NOT NULL,
  `Total_Cost` varchar(20) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `fuel_usage`
--

INSERT INTO `fuel_usage` (`ID`, `Vehicle_No`, `Time_Duration`, `Total_Mileage`, `Total_Fuel`, `Total_Cost`) VALUES
(1, '3233', '0000-00-00', '1213d', '3231', '321');

-- --------------------------------------------------------

--
-- Table structure for table `login`
--

DROP TABLE IF EXISTS `login`;
CREATE TABLE IF NOT EXISTS `login` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `User_Name` varchar(100) NOT NULL,
  `Password` varchar(20) NOT NULL,
  `Email` varchar(20) NOT NULL,
  `Issuper` tinyint(4) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `login`
--

INSERT INTO `login` (`ID`, `User_Name`, `Password`, `Email`, `Issuper`) VALUES
(1, 'Anuhas ', 'anuhas@gma', '123abc', 0),
(3, 'vishwa', '222aaa', 'vishwa@gmail.com', 0),
(4, 'Kalum Sanj', 'kalum@apsl', 'kalu123', 0),
(5, 'Asitha', 'asi123', 'asi@gmail.com', 0),
(8, 'akila', '97aki', 'akila@gmail.com', 0),
(9, 'ashely', 'YXNoZWx5', 'ashely@gmail.com', 0),
(10, 'pubudu gay', '95pubu', 'pubudu@gmail.com', 0),
(13, 'Ashely Fiona', 'QXNoZWx5IEZpb25h', 'Ashelyf@gmail.com', 0),
(14, 'Sadun Laki', 'U2FkdW4gTGFraQ==', 'sadun@gmail.com', 0),
(15, 'Vishmi Ravi', 'vi1212', 'vishmi@gmail.com', 0),
(16, 'sami sami', 'c2FtaSBzYW1p', 'sam@gmail.com', 0),
(17, 'nadun silva', 'nd2121', 'nadun@aps.com', 0),
(18, 'lakshitha', 'lk9393', 'hr@apslanka.com', 1),
(21, 'test', '123', 'test@mail.com', 0),
(22, 'ggg', 'fgh', 'vhh', 0),
(23, 'hff', 'ffg', 'fhh', 0),
(24, 'ghg', 'zfh', 'zght@hsg.co', 0),
(26, 'test', '123', 'test@jmail.com', 0),
(27, 'test2', '123', 'test2@gmail.com', 0);

-- --------------------------------------------------------

--
-- Table structure for table `monthly_countdown`
--

DROP TABLE IF EXISTS `monthly_countdown`;
CREATE TABLE IF NOT EXISTS `monthly_countdown` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Vehicle_No` varchar(10) NOT NULL,
  `Date` varchar(100) NOT NULL,
  `Start_of_Month` varchar(100) NOT NULL,
  `End_of_Month` varchar(100) NOT NULL,
  `Total Km` varchar(20) NOT NULL,
  `Amount` varchar(20) NOT NULL,
  `Liters` varchar(20) NOT NULL,
  `Average` varchar(20) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `monthly_countdown`
--

INSERT INTO `monthly_countdown` (`ID`, `Vehicle_No`, `Date`, `Start_of_Month`, `End_of_Month`, `Total Km`, `Amount`, `Liters`, `Average`) VALUES
(45, 'KT 8603', 'sep', '25000', '27800', '2,800.00', '3500', '26.92', '104.01'),
(46, 'KT 8603', 'oct', '27800', '29000', '1,200.00', '1300', '10.00', '120.00'),
(47, 'KT 8603', 'nov', '29000', '31200', '2,200.00', '2700', '20.77', '105.92'),
(48, 'TEST-02', 'February', '25000', '27000', '2000', '3000.00', '23.077', '86.67'),
(49, 'TEST-01', 'February', '21000', '21500', '500.00', '1500.00', '10.870', '46.00'),
(50, 'TEST-02', 'February', '60000', '63000', '3,000.00', '5000.00', '38.46', '78.00'),
(51, 'DC1349', 'February', '24000', '25000', '1,000.00', '1500.00', '10.87', '92.00'),
(52, 'BDM0944', 'February', '63000', '65000', '2,000.00', '6000.00', '43.48', '46.00'),
(53, 'TEST-03', 'February', '25000', '25500', '500.00', '1000.00', '7.69', '65.00'),
(54, 'TEST-02', 'February', '48000', '50000', '2,000.00', '5000.00', '38.46', '52.00');

-- --------------------------------------------------------

--
-- Table structure for table `running_repair`
--

DROP TABLE IF EXISTS `running_repair`;
CREATE TABLE IF NOT EXISTS `running_repair` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Vehicle_No` varchar(10) NOT NULL,
  `Repair` varchar(500) NOT NULL,
  `Date` varchar(20) NOT NULL,
  `Cost(Rs)` varchar(10) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `running_repair`
--

INSERT INTO `running_repair` (`ID`, `Vehicle_No`, `Repair`, `Date`, `Cost(Rs)`) VALUES
(1, 'KT 8603', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibu', '25/02/2021', '5000.00'),
(2, 'TEST-02', 'Final testing update testing', '25/02/2021', '5000.00');

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
CREATE TABLE IF NOT EXISTS `settings` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Petrol` varchar(20) NOT NULL,
  `Diesel` varchar(20) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`ID`, `Petrol`, `Diesel`) VALUES
(1, '138', '130');

-- --------------------------------------------------------

--
-- Table structure for table `vehicletable`
--

DROP TABLE IF EXISTS `vehicletable`;
CREATE TABLE IF NOT EXISTS `vehicletable` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Vehicle_No` varchar(10) NOT NULL,
  `Vehicle_Type` varchar(10) NOT NULL,
  `Capacity` varchar(10) NOT NULL,
  `Fuel_Type` varchar(10) NOT NULL,
  `Chassis_Number` varchar(10) NOT NULL,
  `Engine_Number` varchar(10) NOT NULL,
  `Ownership` varchar(10) NOT NULL,
  `Maintenance` varchar(10) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `vehicletable`
--

INSERT INTO `vehicletable` (`ID`, `Vehicle_No`, `Vehicle_Type`, `Capacity`, `Fuel_Type`, `Chassis_Number`, `Engine_Number`, `Ownership`, `Maintenance`) VALUES
(25, 'BDM0944', 'Bike', '150CC', 'Petrol', '12312', '12345', 'Own', 'Active'),
(26, 'KT 8604', 'Van', '1300CC', 'Diesel', '21321', '51311', 'Own', 'Active'),
(27, 'TEST-01', 'Car', '1500 CC', 'Petrol', '5524', '6325', 'Own', 'Active'),
(28, 'DC1349', 'Van', '200 CC', 'Petrol', '5427318', '2543', 'Own', 'Active'),
(29, 'TEST-02', 'Bike', '150 CC', 'Diesel', '645865', '1234', 'Own', 'Active');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
