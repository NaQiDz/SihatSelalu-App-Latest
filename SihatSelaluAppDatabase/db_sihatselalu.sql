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
  `User_ID` int(11) NOT NULL,
  `Username` varchar(30) NOT NULL,
  `Email` varchar(40) NOT NULL,
  `Age` int(3) NOT NULL,
  `Gender` varchar(10) NOT NULL,
  `Password` varchar(999) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_parent`
--

INSERT INTO `tbl_parent` (`User_ID`, `Username`, `Email`, `Age`, `Gender`, `Password`) VALUES
(1, 'Ahmad', 'ahmad@gmail.com', 20, 'Male', '$2y$10$CqeLiHafHn4wcC7NRxwQYuw'),
(2, 'Naqid', 'naqid@gmail.com', 23, 'Male', '$2y$10$Ztd/LGr3V0pHj/LKkEZDJ.Z'),
(5, 'akmal', 'akmal@gmail.com', 20, 'Male', '$2y$10$5zofvCoyAfIKPuYAOAQLrOs'),
(6, 'Ahmad', 'ahmad@gmail.com', 21, 'Male', '$2y$10$tLjSOMWx3tOSUaoRhr3AX.FY8Wi74ybukmuZCkxOMRj6/iklGZe6W'),
(7, 'Zul', 'zulhelmi@gmail.com', 22, 'Male', '$2y$10$meIeU5GdzRop/mPr7raCk.eS5/3VQnoB/Mb3A01.USWIqc.R0oETi');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_parent`
--
ALTER TABLE `tbl_parent`
  ADD PRIMARY KEY (`User_ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_parent`
--
ALTER TABLE `tbl_parent`
  MODIFY `User_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
