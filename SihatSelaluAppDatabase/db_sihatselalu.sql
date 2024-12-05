-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 29, 2024 at 02:27 PM
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
-- Table structure for table `tbl_parent`
--

CREATE TABLE `tbl_parent` (
  `User_ID` int(11) NOT NULL AUTO_INCREMENT,
  `Username` varchar(30) NOT NULL,
  `Email` varchar(40) NOT NULL,
  `Age` int(3) NOT NULL,
  `Gender` varchar(10) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `Reset_Code` VARCHAR(6) DEFAULT NULL,
  `Reset_Expiry` DATETIME DEFAULT NULL,
  PRIMARY KEY (`User_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


--
-- Dumping data for table `tbl_parent`
--
INSERT INTO `tbl_parent` (`User_ID`, `Username`, `Email`, `Age`, `Gender`, `Password`, `Reset_Code`, `Reset_Expiry`) VALUES
(1, 'Ahmad', 'ahmad@gmail.com', 11, 'Male', '$2y$10$CqeLiHafHn4wcC7NRxwQYuw', '123456', '2024-12-31 23:59:59'),
(2, 'Naqid', 'naqid@gmail.com', 9, 'Male', '$2y$10$Ztd/LGr3V0pHj/LKkEZDJ.Z', '654321', '2024-12-31 23:59:59'),
(5, 'Akmal', 'akmal@gmail.com', 2, 'Male', '$2y$10$5zofvCoyAfIKPuYAOAQLrOs', '789012', '2024-12-31 23:59:59'),
(6, 'Ahmad', 'ahmad@gmail.com', 15, 'Male', '$2y$10$tLjSOMWx3tOSUaoRhr3AX.FY8Wi74ybukmuZCkxOMRj6/iklGZe6W', NULL, NULL),
(7, 'Loly', 'lolyy1902@gmail.com', 7, 'Female', '$2y$10$tLjSOMWx3tOSUaoRhr3AX.FY8Wi74ybukmuZCkxOMRj6/iklGZe6W', NULL, NULL),
(8, 'Lisha', 'lisharoshinee@gmail.com', 12, 'Female', '$2y$10$tLjSOMWx3tOSUaoRhr3AX.FY8Wi74ybukmuZCkxOMRj6/iklGZe6W', NULL, NULL),
(9, 'Zul', 'zulhelmi@gmail.com', 17, 'Male', '$2y$10$meIeU5GdzRop/mPr7raCk.eS5/3VQnoB/Mb3A01.USWIqc.R0oETi', '345678', '2024-12-31 23:59:59');


--
-- Indexes for dumped tables
--


--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_parent`
--
ALTER TABLE `tbl_parent`
  MODIFY `User_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
COMMIT;

-- Explanation:
-- `Reset_Code`: Stores the verification code sent to the user's email.
-- `Reset_Expiry`: Stores the expiry date and time of the reset code.

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
