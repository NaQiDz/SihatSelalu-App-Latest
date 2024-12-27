-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 27, 2024 at 05:31 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_sihatselalu`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_ai_recommended`
--

CREATE TABLE `tbl_ai_recommended` (
  `recommended_id` int(11) NOT NULL,
  `record_calorie_id` int(11) NOT NULL,
  `food_id` int(11) NOT NULL,
  `recommended_quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_calorie_child`
--

CREATE TABLE `tbl_calorie_child` (
  `record_calorie_id` int(11) NOT NULL,
  `recommended_calorie` int(20) NOT NULL,
  `suggestion_calorie` int(11) NOT NULL,
  `result_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_child`
--

CREATE TABLE `tbl_child` (
  `child_id` int(11) NOT NULL,
  `child_fullname` varchar(40) NOT NULL,
  `child_username` varchar(20) NOT NULL,
  `child_gender` enum('Male','Female') NOT NULL,
  `child_dateofbirth` date NOT NULL,
  `child_current_weight` int(20) NOT NULL,
  `child_current_height` int(20) NOT NULL,
  `parent_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_child`
--

INSERT INTO `tbl_child` (`child_id`, `child_fullname`, `child_username`, `child_gender`, `child_dateofbirth`, `child_current_weight`, `child_current_height`, `parent_id`) VALUES
(1, 'Akmal Hakimi', 'Akmal', 'Male', '2018-12-11', 0, 0, 11),
(2, 'Siti Balqis', 'Balqis', 'Female', '2020-12-08', 0, 0, 11),
(3, 'Zulhelmi', 'Zul', 'Male', '2018-12-04', 0, 0, 11);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_food`
--

CREATE TABLE `tbl_food` (
  `food_id` int(11) NOT NULL,
  `food_name` varchar(40) NOT NULL,
  `food_calories_100g` int(30) NOT NULL,
  `food_category` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_iot_devices`
--

CREATE TABLE `tbl_iot_devices` (
  `iot_id` int(11) NOT NULL,
  `iot_name` varchar(0) NOT NULL,
  `iot_serial_code` int(30) NOT NULL,
  `iot_date_provided` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_parent`
--

CREATE TABLE `tbl_parent` (
  `User_ID` int(11) NOT NULL,
  `token` varchar(20) NOT NULL,
  `Username` varchar(30) NOT NULL,
  `Email` varchar(40) NOT NULL,
  `PhoneNum` int(13) NOT NULL,
  `Age` int(3) NOT NULL,
  `Gender` varchar(10) NOT NULL,
  `Password` varchar(999) NOT NULL,
  `Icon` varchar(244) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_parent`
--

INSERT INTO `tbl_parent` (`User_ID`, `token`, `Username`, `Email`, `PhoneNum`, `Age`, `Gender`, `Password`, `Icon`) VALUES
(1, '', 'Ahmad', 'ahmad@gmail.com', 0, 20, 'Male', '$2y$10$CqeLiHafHn4wcC7NRxwQYuw', ''),
(2, '', 'Naqid', 'naqid@gmail.com', 0, 23, 'Male', '$2y$10$Ztd/LGr3V0pHj/LKkEZDJ.Z', ''),
(5, '', 'akmal', 'akmal@gmail.com', 1823123443, 20, 'Male', '$2a$12$MNyZVX75nrs/IupSB7aGL.nKioWhflz/0AazHPHDl5sDdoDJBOSQ.', 'images/1000000456.jpg'),
(6, '', 'Ahmad', 'ahmad@gmail.com', 0, 21, 'Male', '$2y$10$tLjSOMWx3tOSUaoRhr3AX.FY8Wi74ybukmuZCkxOMRj6/iklGZe6W', ''),
(7, '', 'Zul', 'zulhelmi@gmail.com', 0, 22, 'Male', '$2y$10$meIeU5GdzRop/mPr7raCk.eS5/3VQnoB/Mb3A01.USWIqc.R0oETi', ''),
(8, '', 'Ahmad', 'ahmad@gmail.com', 0, 20, 'Male', '$2y$10$iMOyyZXAKrPJG2.qitZH1et7nC1nOP3lfXHnxOuogafvR0gHh/m1.', ''),
(9, '', 'arif', 'arif@gmail.com', 0, 20, 'Male', '$2y$10$RhCcmNmVvE/pQry253V4iO8624.tQ5nw.S/KCtZXSfXooFdf5Cvzm', ''),
(10, '', 'Balqis', 'balqis@gmail.com', 0, 10, 'Female', '$2y$10$1S2kRfTHd1Hw1XUAE0lTUea/2j029AS8mSzV82BjepTDmfMz92/8e', ''),
(11, '', 'Naqiuddin', 'ahmadnaqiuddinmohamad@gmail.com', 197295642, 22, 'Male', '$2y$10$W0vo5gqzESKK2K7dl/VG9u60RbR8.4i51iyTpD3myEiWfIt67KzC2', 'images/1000000456.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_record_child`
--

CREATE TABLE `tbl_record_child` (
  `record_id` int(11) NOT NULL,
  `child_id` int(11) NOT NULL,
  `child_height` int(30) NOT NULL,
  `child_width` int(30) NOT NULL,
  `record_date` date NOT NULL,
  `record_collectdate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_result_child`
--

CREATE TABLE `tbl_result_child` (
  `result_id` int(11) NOT NULL,
  `child_id` int(11) NOT NULL,
  `child_bmi` int(20) NOT NULL,
  `result_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_ai_recommended`
--
ALTER TABLE `tbl_ai_recommended`
  ADD PRIMARY KEY (`recommended_id`),
  ADD KEY `record_calorie_id` (`record_calorie_id`),
  ADD KEY `food_id` (`food_id`);

--
-- Indexes for table `tbl_calorie_child`
--
ALTER TABLE `tbl_calorie_child`
  ADD PRIMARY KEY (`record_calorie_id`),
  ADD KEY `result_id` (`result_id`);

--
-- Indexes for table `tbl_child`
--
ALTER TABLE `tbl_child`
  ADD PRIMARY KEY (`child_id`),
  ADD KEY `parent_id` (`parent_id`);

--
-- Indexes for table `tbl_food`
--
ALTER TABLE `tbl_food`
  ADD PRIMARY KEY (`food_id`);

--
-- Indexes for table `tbl_iot_devices`
--
ALTER TABLE `tbl_iot_devices`
  ADD PRIMARY KEY (`iot_id`);

--
-- Indexes for table `tbl_parent`
--
ALTER TABLE `tbl_parent`
  ADD PRIMARY KEY (`User_ID`);

--
-- Indexes for table `tbl_record_child`
--
ALTER TABLE `tbl_record_child`
  ADD PRIMARY KEY (`record_id`),
  ADD KEY `child_id` (`child_id`);

--
-- Indexes for table `tbl_result_child`
--
ALTER TABLE `tbl_result_child`
  ADD PRIMARY KEY (`result_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_ai_recommended`
--
ALTER TABLE `tbl_ai_recommended`
  MODIFY `recommended_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_calorie_child`
--
ALTER TABLE `tbl_calorie_child`
  MODIFY `record_calorie_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_child`
--
ALTER TABLE `tbl_child`
  MODIFY `child_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `tbl_food`
--
ALTER TABLE `tbl_food`
  MODIFY `food_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_iot_devices`
--
ALTER TABLE `tbl_iot_devices`
  MODIFY `iot_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_parent`
--
ALTER TABLE `tbl_parent`
  MODIFY `User_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `tbl_record_child`
--
ALTER TABLE `tbl_record_child`
  MODIFY `record_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_result_child`
--
ALTER TABLE `tbl_result_child`
  MODIFY `result_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_ai_recommended`
--
ALTER TABLE `tbl_ai_recommended`
  ADD CONSTRAINT `food_id` FOREIGN KEY (`food_id`) REFERENCES `tbl_food` (`food_id`),
  ADD CONSTRAINT `record_calorie_id` FOREIGN KEY (`record_calorie_id`) REFERENCES `tbl_calorie_child` (`record_calorie_id`);

--
-- Constraints for table `tbl_calorie_child`
--
ALTER TABLE `tbl_calorie_child`
  ADD CONSTRAINT `result_id` FOREIGN KEY (`result_id`) REFERENCES `tbl_result_child` (`result_id`);

--
-- Constraints for table `tbl_child`
--
ALTER TABLE `tbl_child`
  ADD CONSTRAINT `parent_id` FOREIGN KEY (`parent_id`) REFERENCES `tbl_parent` (`User_ID`);

--
-- Constraints for table `tbl_record_child`
--
ALTER TABLE `tbl_record_child`
  ADD CONSTRAINT `child_id` FOREIGN KEY (`child_id`) REFERENCES `tbl_child` (`child_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
