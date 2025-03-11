-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 11, 2025 at 11:36 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `web2_demo1`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity_logs`
--

CREATE TABLE `activity_logs` (
  `id` int(11) NOT NULL,
  `icon` varchar(50) NOT NULL,
  `title` varchar(255) NOT NULL,
  `time` datetime DEFAULT current_timestamp(),
  `status` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `activity_logs`
--

INSERT INTO `activity_logs` (`id`, `icon`, `title`, `time`, `status`) VALUES
(16, 'pi pi-trash', 'Product deleted: ljguihop', '2025-03-08 23:06:00', 'Warning'),
(17, 'pi pi-trash', 'Product deleted: string', '2025-03-08 23:06:02', 'Warning'),
(18, 'pi pi-trash', 'Supplier deleted: qq', '2025-03-08 23:06:11', 'Warning'),
(19, 'pi pi-trash', 'Product deleted: Cafe Americano', '2025-03-08 23:06:31', 'Warning'),
(20, 'pi pi-trash', 'Product deleted: TESTTTT', '2025-03-08 23:06:38', 'Warning'),
(21, 'pi pi-box', 'New product added: TESttttt', '2025-03-08 23:06:47', 'Success'),
(22, 'pi pi-pencil', 'Product updated: TESttttt', '2025-03-08 23:06:56', 'Success'),
(23, 'pi pi-pencil', 'Product updated: TESTTT', '2025-03-08 23:06:56', 'Success'),
(24, 'pi pi-trash', 'Supplier deleted: TESTTTT!!!!', '2025-03-08 23:11:35', 'Warning'),
(25, 'pi pi-trash', 'Stock deleted: Whipped Cream', '2025-03-08 23:13:13', 'Warning'),
(26, 'pi pi-trash', 'Stock deleted: Paper Plate', '2025-03-08 23:13:16', 'Warning'),
(27, 'pi pi-box', 'New Stock added: Paper Plate ', '2025-03-08 23:13:39', 'Success'),
(28, 'pi pi-box', 'New Stock added: Wooden Fork ', '2025-03-08 23:14:02', 'Success'),
(29, 'pi-truck', 'New supplier added: asas ', '2025-03-08 23:14:16', 'Success'),
(30, 'pi pi-pencil', 'Supplier updated: asas', '2025-03-08 23:14:22', 'Success'),
(31, 'pi pi-box', 'New Stock added: Blender ', '2025-03-08 23:18:55', 'Success'),
(32, 'pi-truck', 'New supplier added: admin111 ', '2025-03-08 23:28:52', 'Success'),
(33, 'pi pi-pencil', 'Supplier updated: admin111', '2025-03-08 23:29:06', 'Success'),
(34, 'pi pi-trash', 'Supplier deleted: asas', '2025-03-08 23:29:11', 'Warning'),
(35, 'pi pi-pencil', 'Stock updated: Blender', '2025-03-08 23:29:43', 'Success'),
(36, 'pi pi-pencil', 'Stock updated: Wooden Fork', '2025-03-08 23:29:48', 'Success'),
(37, 'pi pi-box', 'New Stock added: waaa ', '2025-03-08 23:30:13', 'Success'),
(38, 'pi pi-pencil', 'Stock updated: waaa', '2025-03-08 23:30:27', 'Success'),
(39, 'pi pi-trash', 'Stock deleted: waaasss', '2025-03-08 23:30:30', 'Warning'),
(40, 'pi pi-box', 'New product added: qsq', '2025-03-08 23:30:40', 'Success'),
(41, 'pi pi-pencil', 'Product updated: qsq', '2025-03-08 23:30:46', 'Success'),
(42, 'pi pi-pencil', 'Product updated: qsq', '2025-03-08 23:30:46', 'Success'),
(43, 'pi pi-trash', 'Product deleted: qsq', '2025-03-08 23:30:50', 'Warning'),
(44, 'pi pi-trash', 'Product deleted: NNNNNN', '2025-03-08 23:30:53', 'Warning'),
(45, 'pi pi-trash', 'Supplier deleted: admin111', '2025-03-08 23:32:00', 'Warning'),
(46, 'pi pi-box', 'New product added: OrenttTESTT', '2025-03-09 13:26:42', 'Success'),
(47, 'pi-truck', 'New supplier added: string ', '2025-03-09 13:44:50', 'Success'),
(48, 'pi-truck', 'New supplier added: TESTTTTT ', '2025-03-09 13:46:37', 'Success'),
(49, 'pi pi-trash', 'Supplier deleted: TESTTTTT', '2025-03-09 13:47:54', 'Warning'),
(50, 'pi-truck', 'New supplier added: TESTTTTT ', '2025-03-09 13:50:47', 'Success'),
(51, 'pi pi-pencil', 'Product updated: OrenttTESTT', '2025-03-09 13:54:59', 'Success'),
(52, 'pi pi-pencil', 'Product updated: Orentt', '2025-03-09 13:54:59', 'Success'),
(53, 'pi pi-pencil', 'Stock updated: Blender', '2025-03-09 13:56:22', 'Success'),
(54, 'pi pi-pencil', 'Supplier updated: TESTTTTT', '2025-03-09 13:58:03', 'Success'),
(55, 'pi pi-trash', 'Supplier deleted: TESTTTTT', '2025-03-10 22:24:00', 'Warning'),
(56, 'pi pi-box', 'New product added: OrenttTESTT', '2025-03-10 22:30:26', 'Success'),
(57, 'pi pi-box', 'New product added: QWQ', '2025-03-10 22:35:36', 'Success'),
(58, 'pi pi-trash', 'Product deleted: iuyfuygo', '2025-03-10 22:35:54', 'Warning'),
(59, 'pi pi-trash', 'Product deleted: OrenttTESTT', '2025-03-10 22:35:57', 'Warning'),
(60, 'pi pi-trash', 'Product deleted: Orentt', '2025-03-10 22:35:58', 'Warning'),
(61, 'pi pi-trash', 'Product deleted: QWQ', '2025-03-10 22:35:59', 'Warning');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `CategoryName` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `CategoryName`) VALUES
(1, 'Ice Coffee'),
(3, 'Mga Pan'),
(4, 'Juice'),
(5, 'Pasta'),
(7, 'Coffee'),
(9, 'Desserts'),
(10, 'Tea'),
(15, 'Streetfood');

-- --------------------------------------------------------

--
-- Table structure for table `inventoryproduct`
--

CREATE TABLE `inventoryproduct` (
  `id` int(11) NOT NULL,
  `ProductName` varchar(100) DEFAULT NULL,
  `Quantity` int(11) DEFAULT NULL,
  `UnitPrice` decimal(10,2) DEFAULT NULL,
  `CategoryID (FK)` int(11) DEFAULT NULL,
  `SupplierID (FK)` int(11) DEFAULT NULL,
  `Status` varchar(20) DEFAULT NULL,
  `StockID` int(11) DEFAULT NULL,
  `StockQuantity` int(11) DEFAULT NULL,
  `ReportDate` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventoryproduct`
--

INSERT INTO `inventoryproduct` (`id`, `ProductName`, `Quantity`, `UnitPrice`, `CategoryID (FK)`, `SupplierID (FK)`, `Status`, `StockID`, `StockQuantity`, `ReportDate`) VALUES
(4, 'Matcha Latte', 6, 160.00, 2, 2, 'In Stock', NULL, NULL, '2025-02-26 22:44:31'),
(5, 'Crossiant', 12, 25.00, 4, 5, 'In Stock', NULL, NULL, '2025-02-26 22:44:31'),
(6, 'Spanish Latte', 2, 120.00, 2, 1, 'In Stock', NULL, NULL, '2025-02-26 22:44:31'),
(7, 'Cafe Americano', 12, 70.00, 2, 1, 'In Stock', NULL, NULL, '2025-02-26 22:44:31'),
(8, 'Cafe Mocha', 12, 120.00, 1, 2, 'In Stock', NULL, NULL, '2025-02-26 22:44:31'),
(15, 'Caramel Macchiato', 14, 100.00, 2, 2, 'In Stock', NULL, NULL, '2025-02-26 22:44:31'),
(23, 'Cafe Americano', 9, 11.00, 1, 1, 'In Stock', NULL, NULL, '2025-02-26 22:44:31'),
(28, 'Vanilla Latte', 14, 120.00, 1, NULL, 'In Stock', NULL, NULL, '2025-02-26 22:44:31'),
(29, 'Cafe Mocha', 6, 40.00, 1, NULL, 'Low Stock', NULL, NULL, '2025-02-26 22:44:31'),
(40, 'Nescafe', 1, 40.00, 7, NULL, NULL, NULL, NULL, '2025-02-26 22:44:31'),
(41, 'Kopiko', 11, 50.00, 7, NULL, 'In Stock', NULL, NULL, '2025-02-26 22:44:31'),
(42, '3in1', 7, 20.00, 7, NULL, 'Low Stock', NULL, NULL, '2025-02-26 22:44:31'),
(43, 'Wintermelon', 10, 80.00, 4, NULL, NULL, NULL, NULL, '2025-02-26 22:44:31'),
(44, 'Orange', 15, 20.00, 4, NULL, 'In Stock', NULL, NULL, '2025-02-26 22:44:31'),
(45, 'Lemon', 5, 20.00, 4, NULL, NULL, NULL, NULL, '2025-02-26 22:44:31'),
(46, 'Mango', 11, 20.00, 4, NULL, 'In Stock', NULL, NULL, '2025-02-26 22:44:31'),
(48, 'Green Tea', 11, 70.00, 10, NULL, 'In Stock', NULL, NULL, '2025-02-26 22:44:31'),
(49, 'Black Tea', 11, 70.00, 10, NULL, NULL, NULL, NULL, '2025-02-26 22:44:31'),
(51, 'Ham & Cheese', 11, 90.00, 3, NULL, 'In Stock', NULL, NULL, '2025-02-27 00:03:54'),
(67, 'TESTTT', 1, 11.00, 3, NULL, 'Low Stock', NULL, NULL, '2025-03-08 23:06:47');

-- --------------------------------------------------------

--
-- Table structure for table `inventory_reports`
--

CREATE TABLE `inventory_reports` (
  `ReportID` int(11) NOT NULL,
  `ReportDate` datetime NOT NULL,
  `ProductID` int(11) NOT NULL,
  `ProductName` varchar(255) NOT NULL,
  `Quantity` int(11) NOT NULL,
  `UnitPrice` decimal(10,2) NOT NULL,
  `CategoryID` int(11) NOT NULL,
  `Status` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventory_reports`
--

INSERT INTO `inventory_reports` (`ReportID`, `ReportDate`, `ProductID`, `ProductName`, `Quantity`, `UnitPrice`, `CategoryID`, `Status`) VALUES
(1, '2025-02-27 01:20:58', 4, 'Matcha Latte', 14, 160.00, 2, 'In Stock'),
(2, '2025-02-27 01:20:58', 5, 'Crossiant', 21, 25.00, 4, 'In Stock'),
(3, '2025-02-27 01:20:58', 6, 'Spanish Latte', 5, 120.00, 2, 'Low Stock'),
(4, '2025-02-27 01:20:58', 7, 'Cafe Americano', 14, 70.00, 2, 'In Stock'),
(5, '2025-02-27 01:20:58', 8, 'Cafe Mocha', 13, 120.00, 1, 'In Stock'),
(6, '2025-02-27 01:20:58', 9, 'Cafe Americano', 20, 125.00, 1, 'In Stock'),
(7, '2025-02-27 01:20:58', 15, 'Caramel Macchiato', 15, 100.00, 2, 'In Stock'),
(8, '2025-02-27 01:20:58', 23, 'Cafe Americano', 9, 11.00, 1, 'Low Stock'),
(9, '2025-02-27 01:20:58', 28, 'Vanilla Latte', 14, 120.00, 1, 'In Stock'),
(10, '2025-02-27 01:20:58', 29, 'Cafe Mocha', 6, 40.00, 1, 'Low Stock'),
(11, '2025-02-27 01:20:58', 40, 'Nescafe', 1, 40.00, 7, 'Low Stock'),
(12, '2025-02-27 01:20:58', 41, 'Kopiko', 11, 50.00, 7, 'In Stock'),
(13, '2025-02-27 01:20:58', 42, '3in1', 7, 20.00, 7, 'Low Stock'),
(14, '2025-02-27 01:20:58', 43, 'Wintermelon', 10, 80.00, 4, 'Low Stock'),
(15, '2025-02-27 01:20:58', 44, 'Orange', 15, 20.00, 4, 'In Stock'),
(16, '2025-02-27 01:20:58', 45, 'Lemon', 5, 20.00, 4, 'Low Stock'),
(17, '2025-02-27 01:20:58', 46, 'Mango', 11, 20.00, 4, 'In Stock'),
(18, '2025-02-27 01:20:58', 48, 'Green Tea', 11, 70.00, 10, 'In Stock'),
(19, '2025-02-27 01:20:58', 49, 'Black Tea', 11, 70.00, 10, 'In Stock'),
(20, '2025-02-27 01:20:58', 51, 'Ham & Cheese', 11, 90.00, 3, 'In Stock'),
(21, '2025-02-27 01:20:58', 52, 'Cheesy Egg Drop', 7, 90.00, 3, 'Low Stock'),
(22, '2025-02-27 01:20:58', 53, 'asas', 11, 11.00, 3, 'In Stock'),
(23, '2025-02-27 01:20:58', 54, '11111', 111, 111.00, 4, 'In Stock'),
(24, '2025-02-27 01:20:58', 55, 'John Doe', 111, 11.00, 3, 'In Stock'),
(25, '2025-02-27 01:20:58', 56, '444', 1, 1.00, 5, 'Low Stock'),
(26, '2025-02-26 12:11:00', 4, 'Matcha Latte', 14, 160.00, 2, 'In Stock'),
(27, '2025-02-26 12:11:00', 5, 'Crossiant', 21, 25.00, 4, 'In Stock'),
(28, '2025-02-26 12:11:00', 6, 'Spanish Latte', 5, 120.00, 2, 'Low Stock'),
(29, '2025-02-26 12:11:00', 7, 'Cafe Americano', 14, 70.00, 2, 'In Stock'),
(30, '2025-02-26 12:11:00', 8, 'Cafe Mocha', 13, 120.00, 1, 'In Stock'),
(31, '2025-02-26 12:11:00', 9, 'Cafe Americano', 20, 125.00, 1, 'In Stock'),
(32, '2025-02-26 12:11:00', 15, 'Caramel Macchiato', 15, 100.00, 2, 'In Stock'),
(33, '2025-02-26 12:11:00', 23, 'Cafe Americano', 9, 11.00, 1, 'Low Stock'),
(34, '2025-02-26 12:11:00', 28, 'Vanilla Latte', 14, 120.00, 1, 'In Stock'),
(35, '2025-02-26 12:11:00', 29, 'Cafe Mocha', 6, 40.00, 1, 'Low Stock'),
(36, '2025-02-26 12:11:00', 40, 'Nescafe', 1, 40.00, 7, 'Low Stock'),
(37, '2025-02-26 12:11:00', 41, 'Kopiko', 11, 50.00, 7, 'In Stock'),
(38, '2025-02-26 12:11:00', 42, '3in1', 7, 20.00, 7, 'Low Stock'),
(39, '2025-02-26 12:11:00', 43, 'Wintermelon', 10, 80.00, 4, 'Low Stock'),
(40, '2025-02-26 12:11:00', 44, 'Orange', 15, 20.00, 4, 'In Stock'),
(41, '2025-02-26 12:11:00', 45, 'Lemon', 5, 20.00, 4, 'Low Stock'),
(42, '2025-02-26 12:11:00', 46, 'Mango', 11, 20.00, 4, 'In Stock'),
(43, '2025-02-26 12:11:00', 48, 'Green Tea', 11, 70.00, 10, 'In Stock'),
(44, '2025-02-26 12:11:00', 49, 'Black Tea', 11, 70.00, 10, 'In Stock'),
(45, '2025-02-26 12:11:00', 51, 'Ham & Cheese', 11, 90.00, 3, 'In Stock'),
(46, '2025-02-28 05:13:23', 4, 'Matcha Latte', 14, 160.00, 2, 'In Stock'),
(47, '2025-02-28 05:13:23', 5, 'Crossiant', 21, 25.00, 4, 'In Stock'),
(48, '2025-02-28 05:13:23', 6, 'Spanish Latte', 5, 120.00, 2, 'Low Stock'),
(49, '2025-02-28 05:13:23', 7, 'Cafe Americano', 14, 70.00, 2, 'In Stock'),
(50, '2025-02-28 05:13:23', 8, 'Cafe Mocha', 13, 120.00, 1, 'In Stock'),
(51, '2025-02-28 05:13:23', 9, 'Cafe Americano', 20, 125.00, 1, 'In Stock'),
(52, '2025-02-28 05:13:23', 15, 'Caramel Macchiato', 15, 100.00, 2, 'In Stock'),
(53, '2025-02-28 05:13:23', 23, 'Cafe Americano', 9, 11.00, 1, 'Low Stock'),
(54, '2025-02-28 05:13:23', 28, 'Vanilla Latte', 14, 120.00, 1, 'In Stock'),
(55, '2025-02-28 05:13:23', 29, 'Cafe Mocha', 6, 40.00, 1, 'Low Stock'),
(56, '2025-02-28 05:13:23', 40, 'Nescafe', 1, 40.00, 7, 'Low Stock'),
(57, '2025-02-28 05:13:23', 41, 'Kopiko', 11, 50.00, 7, 'In Stock'),
(58, '2025-02-28 05:13:23', 42, '3in1', 7, 20.00, 7, 'Low Stock'),
(59, '2025-02-28 05:13:23', 43, 'Wintermelon', 10, 80.00, 4, 'Low Stock'),
(60, '2025-02-28 05:13:23', 44, 'Orange', 15, 20.00, 4, 'In Stock'),
(61, '2025-02-28 05:13:23', 45, 'Lemon', 5, 20.00, 4, 'Low Stock'),
(62, '2025-02-28 05:13:23', 46, 'Mango', 11, 20.00, 4, 'In Stock'),
(63, '2025-02-28 05:13:23', 48, 'Green Tea', 11, 70.00, 10, 'In Stock'),
(64, '2025-02-28 05:13:23', 49, 'Black Tea', 11, 70.00, 10, 'In Stock'),
(65, '2025-02-28 05:13:23', 51, 'Ham & Cheese', 11, 90.00, 3, 'In Stock'),
(66, '2025-02-28 05:13:23', 57, 'asa', 1, 11.00, 5, 'Low Stock'),
(67, '2025-03-08 19:08:30', 4, 'Matcha Latte', 6, 160.00, 2, 'Low Stock'),
(68, '2025-03-08 19:08:30', 5, 'Crossiant', 12, 25.00, 4, 'In Stock'),
(69, '2025-03-08 19:08:30', 6, 'Spanish Latte', 2, 120.00, 2, 'Low Stock'),
(70, '2025-03-08 19:08:30', 7, 'Cafe Americano', 12, 70.00, 2, 'In Stock'),
(71, '2025-03-08 19:08:30', 8, 'Cafe Mocha', 12, 120.00, 1, 'In Stock'),
(72, '2025-03-08 19:08:30', 9, 'Cafe Americano', 20, 125.00, 1, 'In Stock'),
(73, '2025-03-08 19:08:30', 15, 'Caramel Macchiato', 14, 100.00, 2, 'In Stock'),
(74, '2025-03-08 19:08:30', 23, 'Cafe Americano', 9, 11.00, 1, 'Low Stock'),
(75, '2025-03-08 19:08:30', 28, 'Vanilla Latte', 14, 120.00, 1, 'In Stock'),
(76, '2025-03-08 19:08:30', 29, 'Cafe Mocha', 6, 40.00, 1, 'Low Stock'),
(77, '2025-03-08 19:08:30', 40, 'Nescafe', 1, 40.00, 7, 'Low Stock'),
(78, '2025-03-08 19:08:30', 41, 'Kopiko', 11, 50.00, 7, 'In Stock'),
(79, '2025-03-08 19:08:30', 42, '3in1', 7, 20.00, 7, 'Low Stock'),
(80, '2025-03-08 19:08:30', 43, 'Wintermelon', 10, 80.00, 4, 'Low Stock'),
(81, '2025-03-08 19:08:30', 44, 'Orange', 15, 20.00, 4, 'In Stock'),
(82, '2025-03-08 19:08:30', 45, 'Lemon', 5, 20.00, 4, 'Low Stock'),
(83, '2025-03-08 19:08:30', 46, 'Mango', 11, 20.00, 4, 'In Stock'),
(84, '2025-03-08 19:08:30', 48, 'Green Tea', 11, 70.00, 10, 'In Stock'),
(85, '2025-03-08 19:08:30', 49, 'Black Tea', 11, 70.00, 10, 'In Stock'),
(86, '2025-03-08 19:08:30', 51, 'Ham & Cheese', 11, 90.00, 3, 'In Stock'),
(87, '2025-03-08 19:08:30', 57, 'asa', 1, 11.00, 5, 'Low Stock'),
(88, '2025-03-08 19:08:30', 60, 'TESTTTT', 1, 11.00, 4, 'Low Stock'),
(89, '2025-03-08 22:13:23', 4, 'Matcha Latte', 6, 160.00, 2, 'Low Stock'),
(90, '2025-03-08 22:13:23', 5, 'Crossiant', 12, 25.00, 4, 'In Stock'),
(91, '2025-03-08 22:13:23', 6, 'Spanish Latte', 2, 120.00, 2, 'Low Stock'),
(92, '2025-03-08 22:13:23', 7, 'Cafe Americano', 12, 70.00, 2, 'In Stock'),
(93, '2025-03-08 22:13:23', 8, 'Cafe Mocha', 12, 120.00, 1, 'In Stock'),
(94, '2025-03-08 22:13:23', 9, 'Cafe Americano', 20, 125.00, 1, 'In Stock'),
(95, '2025-03-08 22:13:23', 15, 'Caramel Macchiato', 14, 100.00, 2, 'In Stock'),
(96, '2025-03-08 22:13:23', 23, 'Cafe Americano', 9, 11.00, 1, 'Low Stock'),
(97, '2025-03-08 22:13:23', 28, 'Vanilla Latte', 14, 120.00, 1, 'In Stock'),
(98, '2025-03-08 22:13:23', 29, 'Cafe Mocha', 6, 40.00, 1, 'Low Stock'),
(99, '2025-03-08 22:13:23', 40, 'Nescafe', 1, 40.00, 7, 'Low Stock'),
(100, '2025-03-08 22:13:23', 41, 'Kopiko', 11, 50.00, 7, 'In Stock'),
(101, '2025-03-08 22:13:23', 42, '3in1', 7, 20.00, 7, 'Low Stock'),
(102, '2025-03-08 22:13:23', 43, 'Wintermelon', 10, 80.00, 4, 'Low Stock'),
(103, '2025-03-08 22:13:23', 44, 'Orange', 15, 20.00, 4, 'In Stock'),
(104, '2025-03-08 22:13:23', 45, 'Lemon', 5, 20.00, 4, 'Low Stock'),
(105, '2025-03-08 22:13:23', 46, 'Mango', 11, 20.00, 4, 'In Stock'),
(106, '2025-03-08 22:13:23', 48, 'Green Tea', 11, 70.00, 10, 'In Stock'),
(107, '2025-03-08 22:13:23', 49, 'Black Tea', 11, 70.00, 10, 'In Stock'),
(108, '2025-03-08 22:13:23', 51, 'Ham & Cheese', 11, 90.00, 3, 'In Stock'),
(109, '2025-03-08 22:13:23', 60, 'TESTTTT', 1, 11.00, 4, 'Low Stock'),
(110, '2025-03-08 22:13:23', 61, 'ljguihop', 11, 11.00, 3, 'In Stock'),
(111, '2025-03-08 22:13:23', 62, 'string', 11, 11.00, 1, 'In Stock');

-- --------------------------------------------------------

--
-- Table structure for table `menu_items`
--

CREATE TABLE `menu_items` (
  `MenuItemID` int(11) NOT NULL,
  `MenuName` varchar(255) NOT NULL,
  `MenuPrice` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `OrderID` int(11) NOT NULL,
  `CustomerName` varchar(255) NOT NULL,
  `TableNumber` int(11) NOT NULL,
  `OrderDate` timestamp NOT NULL DEFAULT current_timestamp(),
  `TotalAmount` decimal(10,2) NOT NULL,
  `OrderStatus` varchar(50) DEFAULT 'Pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`OrderID`, `CustomerName`, `TableNumber`, `OrderDate`, `TotalAmount`, `OrderStatus`) VALUES
(1, 'qwq', 1, '2025-03-08 12:42:16', 230.00, 'Completed');

-- --------------------------------------------------------

--
-- Table structure for table `order_history`
--

CREATE TABLE `order_history` (
  `history_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `customer_name` varchar(255) DEFAULT NULL,
  `table_number` int(11) DEFAULT NULL,
  `order_date` datetime DEFAULT NULL,
  `total_amount` decimal(10,2) DEFAULT NULL,
  `order_status` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_history`
--

INSERT INTO `order_history` (`history_id`, `order_id`, `customer_name`, `table_number`, `order_date`, `total_amount`, `order_status`, `created_at`) VALUES
(1, 1, 'qwq', 1, '2025-03-08 00:42:16', 230.00, 'Completed', '2025-03-08 12:42:20');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `OrderItemID` int(11) NOT NULL,
  `OrderID` int(11) NOT NULL,
  `ProductID` int(11) NOT NULL,
  `Quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`OrderItemID`, `OrderID`, `ProductID`, `Quantity`) VALUES
(1, 1, 4, 1),
(2, 1, 7, 1);

-- --------------------------------------------------------

--
-- Table structure for table `reports`
--

CREATE TABLE `reports` (
  `ReportID` int(11) NOT NULL,
  `ReportType` enum('Daily','Weekly','Monthly','Yearly') NOT NULL,
  `ReportName` varchar(255) NOT NULL,
  `ReportDate` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reports`
--

INSERT INTO `reports` (`ReportID`, `ReportType`, `ReportName`, `ReportDate`) VALUES
(1, 'Daily', 'Inventory Summary', '2025-03-08 19:08:30'),
(2, 'Daily', 'Inventory Summary', '2025-03-08 22:13:23');

-- --------------------------------------------------------

--
-- Table structure for table `sales`
--

CREATE TABLE `sales` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `quantity_sold` int(11) NOT NULL DEFAULT 0,
  `unit_price` decimal(10,2) NOT NULL,
  `total_revenue` decimal(10,2) GENERATED ALWAYS AS (`quantity_sold` * `unit_price`) STORED,
  `remitted` decimal(10,2) NOT NULL DEFAULT 0.00,
  `sale_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sales`
--

INSERT INTO `sales` (`id`, `product_id`, `product_name`, `quantity_sold`, `unit_price`, `remitted`, `sale_date`, `created_at`) VALUES
(1, 4, '', 1, 0.00, 160.00, '2025-03-08 12:42:16', '2025-03-08 12:42:16'),
(2, 7, '', 1, 0.00, 70.00, '2025-03-08 12:42:16', '2025-03-08 12:42:16');

-- --------------------------------------------------------

--
-- Table structure for table `stocks`
--

CREATE TABLE `stocks` (
  `StockID` int(11) NOT NULL,
  `StockName` varchar(255) NOT NULL,
  `Quantity` int(11) NOT NULL,
  `CostPrice` decimal(10,2) NOT NULL,
  `CategoryID` int(11) DEFAULT NULL,
  `SupplierID` int(11) DEFAULT NULL,
  `Status` enum('active','inactive') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stocks`
--

INSERT INTO `stocks` (`StockID`, `StockName`, `Quantity`, `CostPrice`, `CategoryID`, `SupplierID`, `Status`) VALUES
(1, 'Coffee Beans', 1, 50.00, NULL, 1, ''),
(2, 'Caramel Syrup', 1, 11.00, NULL, 1, ''),
(3, 'Sugar', 2, 20.00, NULL, 1, ''),
(4, 'Ice Cubes', 3, 15.00, NULL, 2, ''),
(5, 'Cup', 1, 30.00, NULL, 1, ''),
(6, 'Milk', 7, 80.00, NULL, 2, ''),
(7, 'Oat Milk', 11, 90.00, NULL, 2, ''),
(10, 'Mineral Water', 4, 20.00, NULL, 2, ''),
(16, 'Wooden Spoon', 11, 100.00, NULL, 2, ''),
(18, 'Paper Plate', 10, 11.00, NULL, 1, ''),
(19, 'Wooden Fork', 0, 11.00, NULL, 6, ''),
(20, 'Blender', 1, 123.00, NULL, 8, '');

-- --------------------------------------------------------

--
-- Table structure for table `stock_reports`
--

CREATE TABLE `stock_reports` (
  `ReportID` int(11) NOT NULL,
  `ReportDate` datetime NOT NULL,
  `StockID` int(11) NOT NULL,
  `StockName` varchar(255) NOT NULL,
  `Quantity` int(11) NOT NULL,
  `CostPrice` decimal(10,2) NOT NULL,
  `SupplierID` int(11) NOT NULL,
  `Status` enum('active','inactive') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stock_reports`
--

INSERT INTO `stock_reports` (`ReportID`, `ReportDate`, `StockID`, `StockName`, `Quantity`, `CostPrice`, `SupplierID`, `Status`) VALUES
(19, '2025-02-27 22:15:10', 3, 'Sugar', 2, 20.00, 1, ''),
(20, '2025-02-27 22:15:10', 4, 'Ice Cubes', 6, 15.00, 2, ''),
(21, '2025-02-27 22:15:10', 5, 'Cup', 1, 30.00, 1, ''),
(22, '2025-02-27 22:15:10', 6, 'Milk', 7, 80.00, 2, ''),
(23, '2025-02-27 22:15:10', 10, 'Mineral Water', 4, 20.00, 2, ''),
(25, '2025-02-28 05:13:09', 3, 'Sugar', 2, 20.00, 1, ''),
(26, '2025-02-28 05:13:09', 4, 'Ice Cubes', 6, 15.00, 2, ''),
(27, '2025-02-28 05:13:09', 5, 'Cup', 1, 30.00, 1, ''),
(28, '2025-02-28 05:13:09', 6, 'Milk', 7, 80.00, 2, ''),
(29, '2025-02-28 05:13:09', 10, 'Mineral Water', 4, 20.00, 2, ''),
(32, '2025-03-03 22:46:29', 1, 'Coffee Beans', 1, 50.00, 1, ''),
(33, '2025-03-03 22:46:29', 2, 'Caramel Syrup', 1, 11.00, 1, ''),
(34, '2025-03-03 22:46:29', 3, 'Sugar', 2, 20.00, 1, ''),
(35, '2025-03-03 22:46:29', 4, 'Ice Cubes', 6, 15.00, 2, ''),
(36, '2025-03-03 22:46:29', 5, 'Cup', 1, 30.00, 1, ''),
(37, '2025-03-03 22:46:29', 6, 'Milk', 7, 80.00, 2, ''),
(38, '2025-03-03 22:46:29', 10, 'Mineral Water', 4, 20.00, 2, ''),
(41, '2025-03-08 20:09:10', 1, 'Coffee Beans', 1, 50.00, 1, ''),
(42, '2025-03-08 20:09:10', 2, 'Caramel Syrup', 1, 11.00, 1, ''),
(43, '2025-03-08 20:09:10', 3, 'Sugar', 2, 20.00, 1, ''),
(44, '2025-03-08 20:09:10', 4, 'Ice Cubes', 6, 15.00, 2, ''),
(45, '2025-03-08 20:09:10', 5, 'Cup', 1, 30.00, 1, ''),
(46, '2025-03-08 20:09:10', 6, 'Milk', 7, 80.00, 2, ''),
(47, '2025-03-08 20:09:10', 10, 'Mineral Water', 4, 20.00, 2, ''),
(50, '2025-03-08 21:57:12', 1, 'Coffee Beans', 1, 50.00, 1, ''),
(51, '2025-03-08 21:57:12', 2, 'Caramel Syrup', 1, 11.00, 1, ''),
(52, '2025-03-08 21:57:12', 3, 'Sugar', 2, 20.00, 1, ''),
(53, '2025-03-08 21:57:12', 4, 'Ice Cubes', 6, 15.00, 2, ''),
(54, '2025-03-08 21:57:12', 5, 'Cup', 1, 30.00, 1, ''),
(55, '2025-03-08 21:57:12', 6, 'Milk', 7, 80.00, 2, ''),
(56, '2025-03-08 21:57:12', 10, 'Mineral Water', 4, 20.00, 2, '');

-- --------------------------------------------------------

--
-- Table structure for table `suppliers`
--

CREATE TABLE `suppliers` (
  `id` int(11) NOT NULL,
  `suppliername` varchar(100) NOT NULL,
  `contactinfo` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `suppliers`
--

INSERT INTO `suppliers` (`id`, `suppliername`, `contactinfo`, `email`) VALUES
(1, 'Smith', '0123456789', 'jsmith@gmail.com'),
(2, 'Orent', '12345', 'qwert@gmail.com'),
(6, 'admin', '1234134', 'admin@admi'),
(8, 'asas', '12234556', 'asasq@sasa'),
(16, 'string', '2344544', 'string@hfghfg');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(50) NOT NULL DEFAULT 'user',
  `profile_pic` varchar(255) DEFAULT NULL,
  `date_added` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `role`, `profile_pic`, `date_added`) VALUES
(11, 'User1', '$2b$12$E6tss2w04JpIlm9nvA.ZNeD/L0axz9WXMprrORw/CXhO99TnKNLhi', 'admin', 'uploads/profile_pics/User1_1740796171.png', '2025-03-01 02:29:31'),
(12, 'User2', '$2b$12$LJsa0wDPm1rKNpVOPdYU.eb77rPygghbgT7XA8QilqjO51gnj.fku', 'cafe_staff', 'uploads/profile_pics/User2_1740799226.png', '2025-03-01 03:20:26'),
(13, 'Orent', '$2b$12$VxduYHm3ZryPTo/7ZjFq/uLxQ1Mtge/G91KxvIMYE9ZD4Mm5WSiBm', 'cafe_staff', 'Orent_1740800686.png', '2025-03-01 03:44:46'),
(14, 'Inventory', '$2b$12$plHz50XhzXetGMQMGP.KA.ZQlFdYbBoOaeFpfEJ1QGy53QlH79t6W', 'cafe_staff', 'Inventory_1740801917.png', '2025-03-01 04:05:17');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `inventoryproduct`
--
ALTER TABLE `inventoryproduct`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `inventory_reports`
--
ALTER TABLE `inventory_reports`
  ADD PRIMARY KEY (`ReportID`);

--
-- Indexes for table `menu_items`
--
ALTER TABLE `menu_items`
  ADD PRIMARY KEY (`MenuItemID`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`OrderID`);

--
-- Indexes for table `order_history`
--
ALTER TABLE `order_history`
  ADD PRIMARY KEY (`history_id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`OrderItemID`),
  ADD KEY `OrderID` (`OrderID`),
  ADD KEY `ProductID` (`ProductID`);

--
-- Indexes for table `reports`
--
ALTER TABLE `reports`
  ADD PRIMARY KEY (`ReportID`);

--
-- Indexes for table `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `stocks`
--
ALTER TABLE `stocks`
  ADD PRIMARY KEY (`StockID`),
  ADD KEY `CategoryID` (`CategoryID`),
  ADD KEY `SupplierID` (`SupplierID`);

--
-- Indexes for table `stock_reports`
--
ALTER TABLE `stock_reports`
  ADD PRIMARY KEY (`ReportID`),
  ADD KEY `StockID` (`StockID`),
  ADD KEY `SupplierID` (`SupplierID`);

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `activity_logs`
--
ALTER TABLE `activity_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `inventoryproduct`
--
ALTER TABLE `inventoryproduct`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=74;

--
-- AUTO_INCREMENT for table `inventory_reports`
--
ALTER TABLE `inventory_reports`
  MODIFY `ReportID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=112;

--
-- AUTO_INCREMENT for table `menu_items`
--
ALTER TABLE `menu_items`
  MODIFY `MenuItemID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `OrderID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `order_history`
--
ALTER TABLE `order_history`
  MODIFY `history_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `OrderItemID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `reports`
--
ALTER TABLE `reports`
  MODIFY `ReportID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `sales`
--
ALTER TABLE `sales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `stocks`
--
ALTER TABLE `stocks`
  MODIFY `StockID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `stock_reports`
--
ALTER TABLE `stock_reports`
  MODIFY `ReportID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=58;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `order_history`
--
ALTER TABLE `order_history`
  ADD CONSTRAINT `order_history_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`OrderID`) ON DELETE CASCADE;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`ProductID`) REFERENCES `inventoryproduct` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `sales`
--
ALTER TABLE `sales`
  ADD CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `inventoryproduct` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `stocks`
--
ALTER TABLE `stocks`
  ADD CONSTRAINT `stocks_ibfk_1` FOREIGN KEY (`CategoryID`) REFERENCES `categories` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `stocks_ibfk_2` FOREIGN KEY (`SupplierID`) REFERENCES `suppliers` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `stock_reports`
--
ALTER TABLE `stock_reports`
  ADD CONSTRAINT `stock_reports_ibfk_1` FOREIGN KEY (`StockID`) REFERENCES `stocks` (`StockID`),
  ADD CONSTRAINT `stock_reports_ibfk_2` FOREIGN KEY (`SupplierID`) REFERENCES `suppliers` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
