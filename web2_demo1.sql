-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 16, 2025 at 12:20 AM
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
(221, 'pi pi-pencil', 'Stock updated: Oat Milk', '2025-03-15 11:15:46', 'Updated');

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
  `id` int(11) NOT NULL,
  `ProductName` varchar(100) DEFAULT NULL,
  `Quantity` int(11) DEFAULT NULL,
  `UnitPrice` decimal(10,2) DEFAULT NULL,
  `CategoryID (FK)` int(11) DEFAULT NULL,
  `SupplierID (FK)` int(11) DEFAULT NULL,
  `Status` varchar(20) DEFAULT NULL,
  `StockID` int(11) DEFAULT NULL,
  `StockQuantity` int(11) DEFAULT NULL,
  `ReportDate` datetime DEFAULT current_timestamp(),
  `Image` varchar(255) DEFAULT NULL,
  `ProcessType` enum('Ready-Made','To Be Made') NOT NULL DEFAULT 'Ready-Made'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventoryproduct`
--

INSERT INTO `inventoryproduct` (`id`, `ProductName`, `Quantity`, `UnitPrice`, `CategoryID (FK)`, `SupplierID (FK)`, `Status`, `StockID`, `StockQuantity`, `ReportDate`, `Image`, `ProcessType`) VALUES
(99, 'Cafe Latte', 11, 11.00, 20, 1, 'In Stock', NULL, NULL, '2025-03-15 10:16:11', 'Cafe_Latte_1742120171.png', 'Ready-Made'),
(101, 'Matcha Latte', 11, 111.00, 22, NULL, 'In Stock', NULL, NULL, '2025-03-15 10:38:25', 'Matcha_Latte_1742121505.jpg', 'To Be Made'),
(102, 'Croissant', 1, 20.00, 20, NULL, 'Low Stock', NULL, NULL, '2025-03-15 10:53:07', 'Croissant_1742122387.png', 'Ready-Made'),
(103, 'Carbonara', 11, 111.00, 20, NULL, 'In Stock', NULL, NULL, '2025-03-15 10:58:44', 'Carbonara_1742122724.png', 'To Be Made'),
(104, 'Spaghetti', 11, 11.00, 20, 1, 'In Stock', NULL, NULL, '2025-03-15 11:00:56', 'Spaghetti_1742122856.png', 'To Be Made'),
(105, 'Cappuccino', 11, 50.00, 22, NULL, 'In Stock', NULL, NULL, '2025-03-15 11:07:13', 'Cappuccino_1742123233.png', 'To Be Made');

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
  `Status` varchar(50) NOT NULL,
  `Image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventory_reports`
--

INSERT INTO `inventory_reports` (`ReportID`, `ReportDate`, `ProductID`, `ProductName`, `Quantity`, `UnitPrice`, `CategoryID`, `Status`, `Image`) VALUES
(26, '2025-03-14 00:23:19', 91, 'Isaw', 1, 11.00, 21, 'Low Stock', 'Isaw_1741998117.png');

-- --------------------------------------------------------

--
-- Table structure for table `inventory_transactions`
--

CREATE TABLE `inventory_transactions` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `transaction_type` enum('Added','Used','Updated') NOT NULL,
  `quantity_change` int(11) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `unit_price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `user_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventory_transactions`
--

INSERT INTO `inventory_transactions` (`id`, `product_id`, `transaction_type`, `quantity_change`, `timestamp`, `unit_price`, `user_id`) VALUES
(14, 101, 'Added', 11, '2025-03-15 22:38:25', 111.00, 1),
(15, 102, 'Added', 1, '2025-03-15 22:53:07', 20.00, 1),
(16, 105, 'Added', 11, '2025-03-15 23:07:13', 50.00, NULL);

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
(1, 'qwq', 1, '2025-03-08 12:42:16', 230.00, 'Completed'),
(2, 'jj', 2, '2025-03-12 10:54:08', 1.00, 'Pending'),
(3, 'GI', 11, '2025-03-14 12:12:50', 72.00, 'Pending'),
(4, 'John Doe', 1, '2025-03-14 12:15:23', 345.00, 'Pending'),
(5, 'John Doe', 1, '2025-03-14 12:17:31', 345.00, 'Pending'),
(6, 'GI', 11, '2025-03-14 12:17:36', 72.00, 'Completed'),
(7, 'test', 1, '2025-03-14 12:35:16', 8900.00, 'Completed');

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
(1, 1, 'qwq', 1, '2025-03-08 00:42:16', 230.00, 'Completed', '2025-03-08 12:42:20'),
(2, 6, 'GI', 11, '2025-03-14 00:17:36', 72.00, 'Completed', '2025-03-14 12:18:00'),
(3, 7, 'test', 1, '2025-03-14 00:35:16', 8900.00, 'Completed', '2025-03-14 12:35:20');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `OrderID` int(11) NOT NULL,
  `ProductID` int(11) NOT NULL,
  `Quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(11, 'Daily', 'Inventory Summary', '2025-03-14 00:23:19');

-- --------------------------------------------------------

--
-- Table structure for table `sales`
--

CREATE TABLE `sales` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `Image` varchar(255) DEFAULT NULL,
  `quantity_sold` int(11) NOT NULL DEFAULT 0,
  `unit_price` decimal(10,2) NOT NULL,
  `total_revenue` decimal(10,2) GENERATED ALWAYS AS (`quantity_sold` * `unit_price`) STORED,
  `remitted` decimal(10,2) NOT NULL DEFAULT 0.00,
  `sale_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  `Status` enum('active','inactive') NOT NULL,
  `Image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stocks`
--

INSERT INTO `stocks` (`StockID`, `StockName`, `Quantity`, `CostPrice`, `CategoryID`, `SupplierID`, `Status`, `Image`) VALUES
(1, 'Coffee Beans', 1, 50.00, NULL, 1, '', 'Coffee_Beans_1742123712.jpg'),
(2, 'Caramel Syrup', 1, 11.00, NULL, 1, '', 'Caramel_Syrup_1742123722.jpg'),
(3, 'Sugar', 2, 20.00, NULL, 1, '', 'Sugar_1742123727.jpg'),
(4, 'Ice Cubes', 3, 15.00, NULL, 2, '', 'Ice_Cubes_1742123733.jpg'),
(5, 'Cup', 1, 30.00, NULL, 1, '', 'Cup_1742123740.jpg'),
(7, 'Oat Milk', 11, 90.00, NULL, 2, '', 'Oat_Milk_1742123746.jpg'),
(10, 'Mineral Water', 4, 20.00, NULL, 2, '', 'Mineral_Water_1741910675.png');

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
  `Status` enum('active','inactive') NOT NULL,
  `Image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stock_reports`
--

INSERT INTO `stock_reports` (`ReportID`, `ReportDate`, `StockID`, `StockName`, `Quantity`, `CostPrice`, `SupplierID`, `Status`, `Image`) VALUES
(19, '2025-02-27 22:15:10', 3, 'Sugar', 2, 20.00, 1, '', NULL),
(20, '2025-02-27 22:15:10', 4, 'Ice Cubes', 6, 15.00, 2, '', NULL),
(21, '2025-02-27 22:15:10', 5, 'Cup', 1, 30.00, 1, '', NULL),
(23, '2025-02-27 22:15:10', 10, 'Mineral Water', 4, 20.00, 2, '', NULL),
(25, '2025-02-28 05:13:09', 3, 'Sugar', 2, 20.00, 1, '', NULL),
(26, '2025-02-28 05:13:09', 4, 'Ice Cubes', 6, 15.00, 2, '', NULL),
(27, '2025-02-28 05:13:09', 5, 'Cup', 1, 30.00, 1, '', NULL),
(29, '2025-02-28 05:13:09', 10, 'Mineral Water', 4, 20.00, 2, '', NULL),
(32, '2025-03-03 22:46:29', 1, 'Coffee Beans', 1, 50.00, 1, '', NULL),
(33, '2025-03-03 22:46:29', 2, 'Caramel Syrup', 1, 11.00, 1, '', NULL),
(34, '2025-03-03 22:46:29', 3, 'Sugar', 2, 20.00, 1, '', NULL),
(35, '2025-03-03 22:46:29', 4, 'Ice Cubes', 6, 15.00, 2, '', NULL),
(36, '2025-03-03 22:46:29', 5, 'Cup', 1, 30.00, 1, '', NULL),
(38, '2025-03-03 22:46:29', 10, 'Mineral Water', 4, 20.00, 2, '', NULL),
(41, '2025-03-08 20:09:10', 1, 'Coffee Beans', 1, 50.00, 1, '', NULL),
(42, '2025-03-08 20:09:10', 2, 'Caramel Syrup', 1, 11.00, 1, '', NULL),
(43, '2025-03-08 20:09:10', 3, 'Sugar', 2, 20.00, 1, '', NULL),
(44, '2025-03-08 20:09:10', 4, 'Ice Cubes', 6, 15.00, 2, '', NULL),
(45, '2025-03-08 20:09:10', 5, 'Cup', 1, 30.00, 1, '', NULL),
(47, '2025-03-08 20:09:10', 10, 'Mineral Water', 4, 20.00, 2, '', NULL),
(50, '2025-03-08 21:57:12', 1, 'Coffee Beans', 1, 50.00, 1, '', NULL),
(51, '2025-03-08 21:57:12', 2, 'Caramel Syrup', 1, 11.00, 1, '', NULL),
(52, '2025-03-08 21:57:12', 3, 'Sugar', 2, 20.00, 1, '', NULL),
(53, '2025-03-08 21:57:12', 4, 'Ice Cubes', 6, 15.00, 2, '', NULL),
(54, '2025-03-08 21:57:12', 5, 'Cup', 1, 30.00, 1, '', NULL),
(56, '2025-03-08 21:57:12', 10, 'Mineral Water', 4, 20.00, 2, '', NULL),
(58, '2025-03-13 20:21:13', 1, 'Coffee Beans', 1, 50.00, 1, '', 'Coffee_Beans_1741906531.png'),
(59, '2025-03-13 20:21:13', 2, 'Caramel Syrup', 1, 11.00, 1, '', 'Caramel_Syrup_1741906537.png'),
(60, '2025-03-13 20:21:13', 3, 'Sugar', 2, 20.00, 1, '', 'Sugar_1741906557.png'),
(61, '2025-03-13 20:21:13', 4, 'Ice Cubes', 3, 15.00, 2, '', 'Ice_Cubes_1741906563.png'),
(62, '2025-03-13 20:21:13', 5, 'Cup', 1, 30.00, 1, '', 'Cup_1741910655.png'),
(64, '2025-03-13 20:21:13', 10, 'Mineral Water', 4, 20.00, 2, '', 'Mineral_Water_1741910675.png'),
(69, '2025-03-13 21:14:37', 1, 'Coffee Beans', 1, 50.00, 1, '', 'Coffee_Beans_1741906531.png'),
(70, '2025-03-13 21:14:37', 2, 'Caramel Syrup', 1, 11.00, 1, '', 'Caramel_Syrup_1741906537.png'),
(71, '2025-03-13 21:14:37', 3, 'Sugar', 2, 20.00, 1, '', 'Sugar_1741906557.png'),
(72, '2025-03-13 21:14:37', 4, 'Ice Cubes', 3, 15.00, 2, '', 'Ice_Cubes_1741906563.png'),
(73, '2025-03-13 21:14:37', 5, 'Cup', 1, 30.00, 1, '', 'Cup_1741910655.png'),
(75, '2025-03-13 21:14:37', 10, 'Mineral Water', 4, 20.00, 2, '', 'Mineral_Water_1741910675.png'),
(80, '2025-03-13 21:27:56', 1, 'Coffee Beans', 1, 50.00, 1, '', 'Coffee_Beans_1741906531.png'),
(81, '2025-03-13 21:27:56', 2, 'Caramel Syrup', 1, 11.00, 1, '', 'Caramel_Syrup_1741906537.png'),
(82, '2025-03-13 21:27:56', 3, 'Sugar', 2, 20.00, 1, '', 'Sugar_1741906557.png'),
(83, '2025-03-13 21:27:56', 4, 'Ice Cubes', 3, 15.00, 2, '', 'Ice_Cubes_1741906563.png'),
(84, '2025-03-13 21:27:56', 5, 'Cup', 1, 30.00, 1, '', 'Cup_1741910655.png'),
(86, '2025-03-13 21:27:56', 10, 'Mineral Water', 4, 20.00, 2, '', 'Mineral_Water_1741910675.png'),
(91, '2025-03-14 00:23:25', 1, 'Coffee Beans', 1, 50.00, 1, '', 'Coffee_Beans_1741906531.png'),
(92, '2025-03-14 00:23:25', 2, 'Caramel Syrup', 0, 11.00, 1, '', 'Caramel_Syrup_1741906537.png'),
(93, '2025-03-14 00:23:25', 3, 'Sugar', 2, 20.00, 1, '', 'Sugar_1741906557.png'),
(94, '2025-03-14 00:23:25', 4, 'Ice Cubes', 3, 15.00, 2, '', 'Ice_Cubes_1741906563.png'),
(95, '2025-03-14 00:23:25', 5, 'Cup', 1, 30.00, 1, '', 'Cup_1741910655.png'),
(97, '2025-03-14 00:23:25', 10, 'Mineral Water', 4, 20.00, 2, '', 'Mineral_Water_1741910675.png');

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
-- Table structure for table `transaction_logs`
--

CREATE TABLE `transaction_logs` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `action` varchar(50) DEFAULT NULL,
  `details` text DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaction_logs`
--

INSERT INTO `transaction_logs` (`id`, `user_id`, `action`, `details`, `timestamp`) VALUES
(1, 13, 'LOGIN', 'User logged in', '2025-03-15 22:34:49'),
(2, 13, 'LOGIN', 'User logged in', '2025-03-15 22:37:06'),
(3, 13, 'LOGIN', 'User logged in', '2025-03-15 23:00:10');

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
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`);

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
  ADD PRIMARY KEY (`id`),
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
-- Indexes for table `transaction_logs`
--
ALTER TABLE `transaction_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=222;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `inventoryproduct`
--
ALTER TABLE `inventoryproduct`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=106;

--
-- AUTO_INCREMENT for table `inventory_reports`
--
ALTER TABLE `inventory_reports`
  MODIFY `ReportID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `inventory_transactions`
--
ALTER TABLE `inventory_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `OrderID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `order_history`
--
ALTER TABLE `order_history`
  MODIFY `history_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `reports`
--
ALTER TABLE `reports`
  MODIFY `ReportID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `sales`
--
ALTER TABLE `sales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `stocks`
--
ALTER TABLE `stocks`
  MODIFY `StockID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `stock_reports`
--
ALTER TABLE `stock_reports`
  MODIFY `ReportID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=103;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `transaction_logs`
--
ALTER TABLE `transaction_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `inventory_transactions`
--
ALTER TABLE `inventory_transactions`
  ADD CONSTRAINT `inventory_transactions_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `inventoryproduct` (`id`);

--
-- Constraints for table `order_history`
--
ALTER TABLE `order_history`
  ADD CONSTRAINT `order_history_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`OrderID`) ON DELETE CASCADE;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`OrderID`) REFERENCES `orders` (`OrderID`) ON DELETE CASCADE,
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

--
-- Constraints for table `transaction_logs`
--
ALTER TABLE `transaction_logs`
  ADD CONSTRAINT `transaction_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
