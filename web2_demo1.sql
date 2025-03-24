-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 24, 2025 at 02:35 PM
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
(201, 'pi pi-box', 'New product added: Cafe Latte (Ready-Made)', '2025-03-15 10:16:11', 'Success'),
(202, 'pi pi-box', 'New product added: Cafe Latte (Ready-Made)', '2025-03-15 10:20:31', 'Success'),
(203, 'pi pi-box', 'New product added: Matcha Latte (To Be Made)', '2025-03-15 10:38:25', 'Success'),
(204, 'pi pi-trash', 'Product deleted: Cafe Latte', '2025-03-15 10:50:30', 'Deleted'),
(205, 'pi pi-box', 'New product added: Croissant (Ready-Made)', '2025-03-15 10:53:07', 'Success'),
(206, 'pi pi-box', 'New product added: Carbonara (To Be Made)', '2025-03-15 10:58:44', 'Success'),
(207, 'pi pi-box', 'New product added: Spaghetti (To Be Made)', '2025-03-15 11:00:56', 'Success'),
(208, 'pi pi-box', 'New product added: Cappuccino (To Be Made)', '2025-03-15 11:07:13', 'Success'),
(209, 'pi pi-trash', 'Stock deleted: Milk', '2025-03-15 11:12:26', 'Deleted'),
(210, 'pi pi-trash', 'Stock deleted: Blender', '2025-03-15 11:12:34', 'Deleted'),
(211, 'pi pi-trash', 'Stock deleted: Matcha Latte', '2025-03-15 11:12:37', 'Deleted'),
(212, 'pi pi-trash', 'Stock deleted: Stick', '2025-03-15 11:12:40', 'Deleted'),
(213, 'pi pi-trash', 'Stock deleted: Wooden Spoon', '2025-03-15 11:14:54', 'Deleted'),
(214, 'pi pi-trash', 'Stock deleted: Paper Plate', '2025-03-15 11:14:56', 'Deleted'),
(215, 'pi pi-trash', 'Stock deleted: Wooden Fork', '2025-03-15 11:14:58', 'Deleted'),
(216, 'pi pi-pencil', 'Stock updated: Coffee Beans', '2025-03-15 11:15:12', 'Updated'),
(217, 'pi pi-pencil', 'Stock updated: Caramel Syrup', '2025-03-15 11:15:22', 'Updated'),
(218, 'pi pi-pencil', 'Stock updated: Sugar', '2025-03-15 11:15:27', 'Updated'),
(219, 'pi pi-pencil', 'Stock updated: Ice Cubes', '2025-03-15 11:15:33', 'Updated'),
(220, 'pi pi-pencil', 'Stock updated: Cup', '2025-03-15 11:15:40', 'Updated'),
(221, 'pi pi-pencil', 'Stock updated: Oat Milk', '2025-03-15 11:15:46', 'Updated'),
(222, 'pi pi-box', 'New product added: Cafe Mocha (Ready-Made)', '2025-03-15 21:05:17', 'Success'),
(223, 'pi pi-box', 'New product added: Spanish Latte (Ready-Made)', '2025-03-15 21:36:15', 'Success'),
(224, 'pi pi-box', 'New product added: Bread (Ready-Made)', '2025-03-15 21:37:41', 'Success'),
(225, 'pi pi-box', 'New product added: Bread (Ready-Made)', '2025-03-15 23:18:06', 'Success'),
(226, 'pi pi-box', 'New product added: Bread (Ready-Made)', '2025-03-15 23:23:26', 'Success'),
(227, 'pi pi-box', 'New product added: sasa (Ready-Made)', '2025-03-16 00:12:39', 'Success'),
(228, 'pi pi-box', 'Stock added for sasa', '2025-03-16 00:40:21', 'Success'),
(229, 'pi pi-box', 'Stock added for Carbonara', '2025-03-16 00:41:09', 'Success'),
(230, 'pi pi-box', 'Stock added for Matcha Latte', '2025-03-16 00:50:15', 'Success'),
(231, 'pi pi-box', 'Stock added for Matcha Latte', '2025-03-16 00:54:01', 'Success'),
(232, 'pi pi-box', 'Stock added for Carbonara', '2025-03-16 01:00:25', 'Success'),
(233, 'pi pi-box', 'Stock added for Croissant', '2025-03-16 01:08:20', 'Success'),
(234, 'pi pi-chart-line', 'Inventory summary generated', '2025-03-16 09:47:52', 'Success'),
(235, 'pi pi-box', 'New product added: Matcha (Ready-Made)', '2025-03-16 10:56:25', 'Success'),
(236, 'pi pi-box', 'Stock added for Matcha', '2025-03-16 10:57:15', 'Success'),
(237, 'pi pi-box', 'Stock added for Matcha', '2025-03-16 12:32:54', 'Success'),
(238, 'pi pi-box', 'Stock added for Matcha', '2025-03-16 12:52:56', 'Success'),
(239, 'pi pi-box', 'Stock added for JAJJAJA', '2025-03-16 12:53:12', 'Success'),
(240, 'pi pi-box', 'Stock added for Cappuccino', '2025-03-16 13:08:50', 'Success'),
(241, 'pi pi-box', 'Stock added for Bread', '2025-03-16 13:34:00', 'Success'),
(242, 'pi pi-box', 'Stock added for Matcha', '2025-03-16 14:12:52', 'Success'),
(243, 'pi pi-box', 'Stock added for Matcha', '2025-03-16 14:56:44', 'Success'),
(244, 'pi pi-box', 'Stock added for Croissant', '2025-03-16 15:14:58', 'Success'),
(245, 'pi pi-box', 'New product added: uiokb (Ready-Made)', '2025-03-16 15:26:35', 'Success'),
(246, 'pi pi-box', 'Stock added for uiokb', '2025-03-16 15:27:08', 'Success'),
(247, 'pi pi-box', 'New product added: kjviu (To Be Made)', '2025-03-16 15:31:36', 'Success'),
(248, 'pi pi-box', 'Stock added for Matcha', '2025-03-16 18:04:20', 'Success'),
(249, 'pi pi-trash', 'Product deleted: JAJJAJA', '2025-03-16 19:10:39', 'Deleted'),
(250, 'pi pi-trash', 'Product deleted: uiokb', '2025-03-16 19:14:10', 'Deleted'),
(251, 'pi pi-box', 'New product added: walage (Ready-Made)', '2025-03-16 19:19:42', 'Success'),
(252, 'pi pi-trash', 'Product deleted: kjviu', '2025-03-16 19:23:16', 'Deleted'),
(253, 'pi pi-trash', 'Product deleted: jvufguj', '2025-03-16 19:23:37', 'Deleted'),
(254, 'pi pi-trash', 'Product deleted: Cafe Mocha', '2025-03-16 19:24:00', 'Deleted'),
(255, 'pi pi-box', 'Stock added for walage', '2025-03-16 19:25:41', 'Success'),
(256, 'pi pi-box', 'Stock added for walage', '2025-03-16 19:26:20', 'Success'),
(257, 'pi pi-box', 'New product added: asas (To Be Made)', '2025-03-16 20:03:30', 'Success'),
(258, 'pi pi-box', 'New product added: adsadadffgvv (Ready-Made)', '2025-03-16 20:04:28', 'Success'),
(259, 'pi pi-box', 'Stock added for adsadadffgvv', '2025-03-16 21:12:58', 'Success'),
(260, 'pi pi-box', 'Stock added for adsadadffgvv', '2025-03-16 21:27:08', 'Success'),
(261, 'pi pi-box', 'Stock added for Matcha', '2025-03-22 13:07:57', 'Success'),
(262, 'pi pi-box', 'Stock added for Matcha', '2025-03-22 19:25:32', 'Success');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `CategoryName` varchar(50) NOT NULL,
  `ImagePath` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `CategoryName`, `ImagePath`) VALUES
(20, 'Desserts', 'uploads/categories/Desserts_pngtree-coffee-latte-seen-up-close-png-image_15237865.png'),
(21, 'Frappe', 'uploads/categories/Frappe_User-Avatar-Profile-PNG-Free-File-Download.png'),
(22, 'Hot Coffee', 'uploads/categories/Hot_Coffee_Spoon-Full-of-Salt.jpg'),
(23, 'Streetfood', 'uploads/categories/Streetfood_User-Avatar-Profile-Clip-Art-Transparent-PNG.png');

-- --------------------------------------------------------

--
-- Table structure for table `inventoryproduct`
--

CREATE TABLE `inventoryproduct` (
  `id` varchar(36) NOT NULL,
  `ProductName` varchar(100) DEFAULT NULL,
  `UnitPrice` decimal(10,2) DEFAULT NULL,
  `CategoryID (FK)` int(11) DEFAULT NULL,
  `Status` varchar(20) DEFAULT NULL,
  `ReportDate` datetime DEFAULT current_timestamp(),
  `Image` varchar(255) DEFAULT NULL,
  `ProcessType` enum('Ready-Made','To Be Made') NOT NULL DEFAULT 'Ready-Made',
  `Quantity` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventoryproduct`
--

INSERT INTO `inventoryproduct` (`id`, `ProductName`, `UnitPrice`, `CategoryID (FK)`, `Status`, `ReportDate`, `Image`, `ProcessType`, `Quantity`) VALUES
('101', 'Matcha Latte', 111.00, 22, 'In Stock', '2025-03-15 10:38:25', 'Matcha_Latte_1742121505.jpg', 'To Be Made', 2),
('102', 'Croissant', 20.00, 20, 'Low Stock', '2025-03-15 10:53:07', 'Croissant_1742122387.png', 'Ready-Made', 0),
('103', 'Carbonara', 111.00, 20, 'In Stock', '2025-03-15 10:58:44', 'Carbonara_1742122724.png', 'To Be Made', 21),
('104', 'Spaghetti', 11.00, 20, 'In Stock', '2025-03-15 11:00:56', 'Spaghetti_1742122856.png', 'To Be Made', 0),
('105', 'Cappuccino', 50.00, 22, 'In Stock', '2025-03-15 11:07:13', 'Cappuccino_1742123233.png', 'To Be Made', 11),
('107', 'Spanish Latte', 11.00, 20, 'In Stock', '2025-03-15 21:36:15', 'Spanish_Latte_1742160975.jpg', 'Ready-Made', 0),
('108', 'Bread', 111.00, 20, 'In Stock', '2025-03-15 21:37:41', 'Bread_1742161061.png', 'Ready-Made', 1),
('109', 'Bread', 11.00, 20, NULL, '2025-03-15 23:18:06', 'Bread_1742167086.jpg', 'Ready-Made', 0),
('110', 'Bread', 11.00, 20, NULL, '2025-03-15 23:23:26', 'Bread_1742167406.jpg', 'Ready-Made', 0),
('111', 'sasa', 111.00, 20, NULL, '2025-03-16 00:12:39', '111_sasa.jpg', 'Ready-Made', 11),
('123', 'walage', 11.00, 20, NULL, '2025-03-16 19:19:42', '123_walage.jpg', 'Ready-Made', 22),
('2', 'asas', 11.00, 20, NULL, '2025-03-16 20:03:30', '2_asas.jpg', 'To Be Made', 0),
('3', 'adsadadffgvv', 11.00, 20, NULL, '2025-03-16 20:04:28', '3_adsadadffgvv.jpg', 'Ready-Made', 105),
('900', 'Matcha', 11.00, 20, NULL, '2025-03-16 10:56:25', '900_Matcha.jpg', 'Ready-Made', 2684),
('99', 'Cafe Latte', 11.00, 20, 'In Stock', '2025-03-15 10:16:11', 'Cafe_Latte_1742120171.png', 'Ready-Made', 0);

-- --------------------------------------------------------

--
-- Table structure for table `inventory_reports`
--

CREATE TABLE `inventory_reports` (
  `ReportID` int(11) NOT NULL,
  `ReportDate` datetime NOT NULL,
  `ProductID` varchar(36) DEFAULT NULL,
  `ProductName` varchar(255) NOT NULL,
  `Quantity` int(11) NOT NULL,
  `UnitPrice` decimal(10,2) NOT NULL,
  `CategoryID` int(11) NOT NULL,
  `Status` varchar(50) NOT NULL,
  `Image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventory_reports`
--

INSERT INTO `inventory_reports` (`ReportID`, `ReportDate`, `ProductID`, `ProductName`, `Quantity`, `UnitPrice`, `CategoryID`, `Status`, `Image`) VALUES
(26, '2025-03-14 00:23:19', '91', 'Isaw', 1, 11.00, 21, 'Low Stock', 'Isaw_1741998117.png'),
(27, '2025-03-16 09:47:52', '1000', 'JAJJAJA', 0, 11.00, 20, 'Out of Stock', 'JAJJAJA_1742169519.jpg'),
(28, '2025-03-16 09:47:52', '101', 'Matcha Latte', 2, 111.00, 22, 'Low Stock', 'Matcha_Latte_1742121505.jpg'),
(29, '2025-03-16 09:47:52', '102', 'Croissant', 6, 20.00, 20, 'Low Stock', 'Croissant_1742122387.png'),
(30, '2025-03-16 09:47:52', '103', 'Carbonara', 21, 111.00, 20, 'In Stock', 'Carbonara_1742122724.png'),
(31, '2025-03-16 09:47:52', '104', 'Spaghetti', 0, 11.00, 20, 'Out of Stock', 'Spaghetti_1742122856.png'),
(32, '2025-03-16 09:47:52', '105', 'Cappuccino', 0, 50.00, 22, 'Out of Stock', 'Cappuccino_1742123233.png'),
(33, '2025-03-16 09:47:52', '106', 'Cafe Mocha', 0, 11.00, 22, 'Out of Stock', NULL),
(34, '2025-03-16 09:47:52', '107', 'Spanish Latte', 0, 11.00, 20, 'Out of Stock', 'Spanish_Latte_1742160975.jpg'),
(35, '2025-03-16 09:47:52', '108', 'Bread', 0, 111.00, 20, 'Out of Stock', 'Bread_1742161061.png'),
(36, '2025-03-16 09:47:52', '109', 'Bread', 0, 11.00, 20, 'Out of Stock', 'Bread_1742167086.jpg'),
(37, '2025-03-16 09:47:52', '11', 'jvufguj', 0, 11.00, 20, 'Out of Stock', NULL),
(38, '2025-03-16 09:47:52', '110', 'Bread', 0, 11.00, 20, 'Out of Stock', 'Bread_1742167406.jpg'),
(39, '2025-03-16 09:47:52', '111', 'sasa', 11, 111.00, 20, 'In Stock', '111_sasa.jpg'),
(40, '2025-03-16 09:47:52', '99', 'Cafe Latte', 0, 11.00, 20, 'Out of Stock', 'Cafe_Latte_1742120171.png');

-- --------------------------------------------------------

--
-- Table structure for table `inventory_transactions`
--

CREATE TABLE `inventory_transactions` (
  `id` int(11) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `transaction_type` enum('Add','Update') NOT NULL,
  `quantity` int(11) NOT NULL,
  `cost_price` decimal(10,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventory_transactions`
--

INSERT INTO `inventory_transactions` (`id`, `product_name`, `transaction_type`, `quantity`, `cost_price`, `created_at`) VALUES
(1, 'adsadadffgvv', 'Add', 1, 21.00, '2025-03-17 09:12:58'),
(2, 'adsadadffgvv', 'Add', 112, 2111.00, '2025-03-17 09:27:08'),
(3, 'Matcha', 'Add', 11, 101.00, '2025-03-23 01:07:57'),
(4, 'Matcha', 'Add', 111, 1.00, '2025-03-23 07:25:32');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `OrderID` int(11) NOT NULL,
  `CustomerName` varchar(255) NOT NULL,
  `OrderDate` timestamp NOT NULL DEFAULT current_timestamp(),
  `TotalAmount` decimal(10,2) NOT NULL,
  `CashOnHand` decimal(10,2) NOT NULL DEFAULT 0.00,
  `OrderStatus` varchar(50) NOT NULL DEFAULT 'Pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`OrderID`, `CustomerName`, `OrderDate`, `TotalAmount`, `CashOnHand`, `OrderStatus`) VALUES
(2, 'John ', '2025-03-24 12:48:35', 51.00, 0.00, 'Pending'),
(3, 'John ', '2025-03-24 12:52:59', 51.00, 0.00, 'Pending'),
(4, 'John ', '2025-03-24 12:57:34', 51.00, 0.00, 'Pending');

-- --------------------------------------------------------

--
-- Table structure for table `order_history`
--

CREATE TABLE `order_history` (
  `history_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `customer_name` varchar(255) DEFAULT NULL,
  `order_date` datetime DEFAULT NULL,
  `total_items` int(11) NOT NULL DEFAULT 0,
  `cash_on_hand` decimal(10,2) DEFAULT NULL,
  `total_amount` decimal(10,2) DEFAULT NULL,
  `change` decimal(10,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_history`
--

INSERT INTO `order_history` (`history_id`, `order_id`, `customer_name`, `order_date`, `total_items`, `cash_on_hand`, `total_amount`, `change`, `created_at`) VALUES
(1, 1, 'John', NULL, 2, 0.00, 82.00, -82.00, '2025-03-24 12:34:28'),
(2, 5, 'John xcz', NULL, 2, 500.00, 55.00, 445.00, '2025-03-24 13:07:14'),
(4, 6, 'John xcz', NULL, 2, 500.00, 55.00, 445.00, '2025-03-24 13:24:32');

-- --------------------------------------------------------

--
-- Table structure for table `order_history_detail`
--

CREATE TABLE `order_history_detail` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `quantity` int(11) NOT NULL,
  `product_price` decimal(10,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_history_detail`
--

INSERT INTO `order_history_detail` (`id`, `order_id`, `product_id`, `product_name`, `quantity`, `product_price`) VALUES
(1, 5, 3, 'adsadadffgvv', 2, 0.00),
(2, 5, 2, 'asas', 3, 0.00),
(4, 6, 3, 'adsadadffgvv', 2, 11.00),
(5, 6, 2, 'asas', 3, 11.00);

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `OrderID` int(11) NOT NULL,
  `ProductID` varchar(36) NOT NULL,
  `Quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `OrderID`, `ProductID`, `Quantity`) VALUES
(3, 2, '102', 2),
(4, 2, '900', 1),
(5, 3, '102', 2),
(6, 3, '900', 1),
(7, 4, '102', 2),
(8, 4, '900', 1);

-- --------------------------------------------------------

--
-- Table structure for table `product_transactions`
--

CREATE TABLE `product_transactions` (
  `id` int(11) NOT NULL,
  `product_id` varchar(36) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `transaction_type` enum('Add','Edit','Delete') NOT NULL,
  `process_type` enum('Ready-Made','To Be Made') NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_transactions`
--

INSERT INTO `product_transactions` (`id`, `product_id`, `product_name`, `transaction_type`, `process_type`, `unit_price`, `category_id`, `created_at`) VALUES
(1, '2', 'asas', 'Add', 'To Be Made', 11.00, 20, '2025-03-17 08:03:30'),
(2, '3', 'adsadadffgvv', 'Add', 'Ready-Made', 11.00, 20, '2025-03-17 08:04:28');

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
(2, 'Daily', 'Inventory Summary', '2025-03-08 22:13:23'),
(3, 'Daily', 'Inventory Summary', '2025-03-11 21:59:37'),
(4, 'Daily', 'Inventory Summary', '2025-03-11 22:03:04'),
(5, 'Daily', 'Inventory Summary', '2025-03-11 22:10:23'),
(6, 'Daily', 'Inventory Summary', '2025-03-11 22:11:06'),
(7, 'Daily', 'Inventory Summary', '2025-03-11 22:11:22'),
(8, 'Daily', 'Inventory Summary', '2025-03-11 22:20:13'),
(9, 'Daily', 'Inventory Summary', '2025-03-11 22:20:46'),
(10, 'Daily', 'Inventory Summary', '2025-03-11 23:49:07'),
(11, 'Daily', 'Inventory Summary', '2025-03-14 00:23:19'),
(12, 'Daily', 'Inventory Summary', '2025-03-16 09:47:52');

-- --------------------------------------------------------

--
-- Table structure for table `sales`
--

CREATE TABLE `sales` (
  `id` int(11) NOT NULL,
  `product_id` varchar(36) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `Image` varchar(255) DEFAULT NULL,
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

INSERT INTO `sales` (`id`, `product_id`, `product_name`, `Image`, `quantity_sold`, `unit_price`, `remitted`, `sale_date`, `created_at`) VALUES
(12, '3', '', NULL, 2, 0.00, 22.00, '2025-03-24 12:04:14', '2025-03-24 12:04:14'),
(13, '102', '', NULL, 3, 0.00, 60.00, '2025-03-24 12:04:14', '2025-03-24 12:04:14'),
(14, '3', '', NULL, 2, 0.00, 22.00, '2025-03-24 12:30:23', '2025-03-24 12:30:23'),
(15, '102', '', NULL, 3, 0.00, 60.00, '2025-03-24 12:30:23', '2025-03-24 12:30:23'),
(16, '102', '', NULL, 2, 0.00, 40.00, '2025-03-24 12:48:35', '2025-03-24 12:48:35'),
(17, '900', '', NULL, 1, 0.00, 11.00, '2025-03-24 12:48:35', '2025-03-24 12:48:35'),
(18, '102', '', NULL, 2, 0.00, 40.00, '2025-03-24 12:52:59', '2025-03-24 12:52:59'),
(19, '900', '', NULL, 1, 0.00, 11.00, '2025-03-24 12:52:59', '2025-03-24 12:52:59'),
(20, '102', '', NULL, 2, 0.00, 40.00, '2025-03-24 12:57:34', '2025-03-24 12:57:34'),
(21, '900', '', NULL, 1, 0.00, 11.00, '2025-03-24 12:57:34', '2025-03-24 12:57:34'),
(22, '3', '', NULL, 2, 0.00, 22.00, '2025-03-24 13:06:33', '2025-03-24 13:06:33'),
(23, '2', '', NULL, 3, 0.00, 33.00, '2025-03-24 13:06:33', '2025-03-24 13:06:33'),
(24, '3', '', NULL, 2, 0.00, 22.00, '2025-03-24 13:23:24', '2025-03-24 13:23:24'),
(25, '2', '', NULL, 3, 0.00, 33.00, '2025-03-24 13:23:24', '2025-03-24 13:23:24');

-- --------------------------------------------------------

--
-- Table structure for table `stock_details`
--

CREATE TABLE `stock_details` (
  `id` int(11) NOT NULL,
  `ProductID` varchar(36) NOT NULL,
  `stock_location` varchar(255) NOT NULL,
  `batch_number` varchar(255) NOT NULL,
  `quantity` int(11) NOT NULL,
  `expiration_date` date DEFAULT NULL,
  `cost_price` float NOT NULL,
  `SupplierID` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stock_details`
--

INSERT INTO `stock_details` (`id`, `ProductID`, `stock_location`, `batch_number`, `quantity`, `expiration_date`, `cost_price`, `SupplierID`, `created_at`) VALUES
(1, '111', 'Ref', '1', 11, '0000-00-00', 0, NULL, '2025-03-17 05:54:21'),
(2, '103', 'Ref', '1', 11, '0000-00-00', 0, NULL, '2025-03-17 05:54:21'),
(3, '101', 'Table', '12', 1, '0000-00-00', 0, NULL, '2025-03-17 05:54:21'),
(4, '101', 'Table', '12', 1, '2025-03-20', 0, NULL, '2025-03-17 05:54:21'),
(5, '103', 'ref', '1', 10, '2025-03-20', 0, NULL, '2025-03-17 05:54:21'),
(6, '102', 'Rack', '12', 6, '2025-03-30', 30, NULL, '2025-03-17 05:54:21'),
(7, '900', 'Ref', '11', 110, '2025-03-20', 10, 1, '2025-03-17 05:54:21'),
(9, '900', 'Ref', '1', 110, '2025-03-20', 10, 1, '2025-03-17 05:54:21'),
(10, '900', 'Ref', '11', 1110, '2025-03-20', 10, 1, '2025-03-17 05:54:21'),
(12, '105', 'qweeq', '11', 11, '2025-03-17', 50, 2, '2025-03-17 05:54:21'),
(13, '108', 'rack', '1', 1, '2025-03-25', 11, 2, '2025-03-17 05:54:21'),
(14, '900', 'TAble', '23', 12, '2025-03-17', 120, 19, '2025-03-17 05:54:21'),
(15, '900', 'Ref', '11', 110, '2025-03-20', 10, 19, '2025-03-17 05:54:21'),
(16, '900', 'TAble', '23', 12, '2025-03-17', 10, 19, '2025-03-17 05:54:21'),
(17, '102', 'Table', '12', 6, '2025-03-30', 300, 19, '2025-03-17 05:54:21'),
(19, '900', 'Ref', '111', 1101, '2025-03-20', 101, 1, '2025-03-17 06:04:20'),
(20, '123', 'ead', '1', 11, '2025-03-17', 123, 19, '2025-03-17 07:25:41'),
(21, '123', 'ead', '1', 11, '2025-03-20', 123, 19, '2025-03-17 07:26:20'),
(22, '3', 'ADSA', '1', 1, '2025-03-25', 21, 6, '2025-03-17 09:12:58'),
(23, '3', 'ADSA', '2', 112, '2025-03-25', 2111, 2, '2025-03-17 09:27:08'),
(24, '900', 'lamisa', '113', 11, '2025-03-29', 101, 1, '2025-03-23 01:07:57'),
(25, '900', 'lamisa', '114', 111, '2025-03-29', 1, 20, '2025-03-23 07:25:32');

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
(19, 'admin111', '11213231', 'john.doe@example.com'),
(20, 'qq', '11213231', 'orent@123');

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
-- Indexes for table `inventory_transactions`
--
ALTER TABLE `inventory_transactions`
  ADD PRIMARY KEY (`id`);

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
  ADD UNIQUE KEY `order_id` (`order_id`);

--
-- Indexes for table `order_history_detail`
--
ALTER TABLE `order_history_detail`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `OrderID` (`OrderID`),
  ADD KEY `ProductID` (`ProductID`);

--
-- Indexes for table `product_transactions`
--
ALTER TABLE `product_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `category_id` (`category_id`);

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
-- Indexes for table `stock_details`
--
ALTER TABLE `stock_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ProductID` (`ProductID`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=263;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `inventory_reports`
--
ALTER TABLE `inventory_reports`
  MODIFY `ReportID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `inventory_transactions`
--
ALTER TABLE `inventory_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `OrderID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `order_history`
--
ALTER TABLE `order_history`
  MODIFY `history_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `order_history_detail`
--
ALTER TABLE `order_history_detail`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `product_transactions`
--
ALTER TABLE `product_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `reports`
--
ALTER TABLE `reports`
  MODIFY `ReportID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `sales`
--
ALTER TABLE `sales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `stock_details`
--
ALTER TABLE `stock_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `order_history_detail`
--
ALTER TABLE `order_history_detail`
  ADD CONSTRAINT `order_history_detail_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `order_history` (`order_id`) ON DELETE CASCADE;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`OrderID`) REFERENCES `orders` (`OrderID`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`ProductID`) REFERENCES `inventoryproduct` (`id`);

--
-- Constraints for table `product_transactions`
--
ALTER TABLE `product_transactions`
  ADD CONSTRAINT `product_transactions_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `inventoryproduct` (`id`),
  ADD CONSTRAINT `product_transactions_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`);

--
-- Constraints for table `sales`
--
ALTER TABLE `sales`
  ADD CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `inventoryproduct` (`id`);

--
-- Constraints for table `stock_details`
--
ALTER TABLE `stock_details`
  ADD CONSTRAINT `stock_details_ibfk_1` FOREIGN KEY (`ProductID`) REFERENCES `inventoryproduct` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
