-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 28, 2025 at 02:08 PM
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
(1, 'pi pi-pencil', 'Product updated: Cafe Americano', '2025-03-27 20:57:11', 'Updated'),
(2, 'pi pi-pencil', 'Product updated: Iced Caramel Macchiato', '2025-03-27 20:57:26', 'Updated'),
(3, 'pi pi-pencil', 'Product updated: Yakult Lemonade', '2025-03-27 21:39:20', 'Updated'),
(4, 'pi pi-pencil', 'Product updated: Mogu-Mogu Yakult w/ Honey', '2025-03-27 21:53:35', 'Updated'),
(5, 'pi pi-trash', 'Product deleted: Matcha Milktea', '2025-03-27 22:13:21', 'Deleted'),
(6, 'pi pi-pencil', 'Product updated: Oreo Milktea', '2025-03-27 22:20:24', 'Updated'),
(7, 'pi pi-pencil', 'Product updated: Mineral Water', '2025-03-27 23:15:16', 'Updated'),
(8, 'pi-truck', 'New supplier added: John Doe ', '2025-03-27 23:27:11', 'Success'),
(9, 'pi-truck', 'New supplier added: James Smith ', '2025-03-27 23:27:42', 'Success'),
(10, 'pi pi-trash', 'Product deleted: Mineral Water', '2025-03-28 00:16:07', 'Deleted'),
(11, 'pi pi-pencil', 'Product updated: Mineral Water', '2025-03-28 00:17:01', 'Updated'),
(12, 'pi pi-trash', 'Supplier deleted: John Doe', '2025-03-28 00:35:28', 'Deleted'),
(13, 'pi pi-truck', 'New supplier added: John Doe ', '2025-03-28 00:44:34', 'Success'),
(14, 'pi pi-truck', 'New supplier added: TESTTTT!!!! ', '2025-03-28 00:45:22', 'Success'),
(15, 'pi pi-trash', 'Supplier deleted: TESTTTT!!!!', '2025-03-28 00:45:26', 'Deleted'),
(16, 'pi pi-trash', 'Product deleted: Mineral Water', '2025-03-28 00:48:30', 'Deleted'),
(17, 'pi pi-pencil', 'Product updated: Demisoda', '2025-03-28 00:49:42', 'Updated'),
(18, 'pi pi-trash', 'Product deleted: Demisoda', '2025-03-28 00:50:19', 'Deleted'),
(19, 'pi pi-trash', 'Product deleted: Bundaberg', '2025-03-28 00:50:27', 'Deleted'),
(20, 'pi pi-pencil', 'Product updated: Mineral Water', '2025-03-28 00:51:55', 'Updated');

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
(1, 'HOT Coffee', 'uploads/categories/Hot_Coffee_5668494-0-image-a-4_1541098633929.jpg'),
(2, 'ICED Coffee', 'uploads/categories/ICED_Coffee_21667-easy-iced-coffee-ddmfs-4x3-0093-7becf3932bd64ed7b594d46c02d0889f.jpg'),
(3, 'JUICE Drinks', 'uploads/categories/JUICE_Drinks_Fresh-juice.jpg'),
(4, 'MILK Teas', 'uploads/categories/MILK_Teas_r0vc-listing.jpg'),
(5, 'CHOCOLATE Drinks', 'uploads/categories/CHOCOLATE_Drinks_how-to-make-hot-chocolate-7.jpg'),
(6, 'BLENDED Frappes', 'uploads/categories/BLENDED_Frappes_Frappe-e1600323632770.jpg'),
(7, 'PASTA Dishes', 'uploads/categories/PASTA_Dishes_67700_RichPastaforthePoorKitchen_ddmfs_4x3_2284-220302ec8328442096df370dede357d7.jpg'),
(9, 'BOTTLED & CANNED Drinks', 'uploads/categories/BOTTLED_&_CANNED_Drinks_png-clipart-assorted-brand-soda-bottles-and-cans-art-fizzy-drinks-fanta-juice-coca-cola-drink-plastic-bottle-cola.png');

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
  `Quantity` int(11) NOT NULL DEFAULT 0,
  `Threshold` int(11) DEFAULT 0
) ;

--
-- Dumping data for table `inventoryproduct`
--

INSERT INTO `inventoryproduct` (`id`, `ProductName`, `UnitPrice`, `CategoryID (FK)`, `Status`, `ReportDate`, `Image`, `ProcessType`, `Quantity`, `Threshold`) VALUES
('1', 'Cafe Americano', 70.00, 1, 'Available', '2025-03-27 20:33:47', '1_Cafe_Americano.jpeg', 'To Be Made', 0, NULL),
('10', 'Peppermint Latte', 90.00, 1, 'Available', '2025-03-27 20:40:26', '10_Peppermint_Latte.jpg', 'To Be Made', 0, NULL),
('11', 'Vanilla Latte', 90.00, 1, 'Available', '2025-03-27 20:41:03', '11_Vanilla_Latte.jpg', 'To Be Made', 0, NULL),
('12', 'Matcha Cafe Latte', 90.00, 1, 'Available', '2025-03-27 20:41:31', '12_Matcha_Cafe_Latte.jpg', 'To Be Made', 0, NULL),
('13', 'Hot Tea', 60.00, 1, 'Available', '2025-03-27 20:42:06', '13_Hot_Tea.jpg', 'To Be Made', 0, NULL),
('14', 'Iced Cafe Latte', 80.00, 2, 'Available', '2025-03-27 20:55:46', '14_Iced_Cafe_Latte.jpeg', 'To Be Made', 0, NULL),
('15', 'Iced Caramel Macchiato', 115.00, 2, 'Available', '2025-03-27 20:56:16', '15_Caramel_Macchiato.jpg', 'To Be Made', 0, NULL),
('16', 'Iced Cafe Mocha', 115.00, 2, 'Available', '2025-03-27 20:57:54', '16_Iced_Cafe_Mocha.jpg', 'To Be Made', 0, NULL),
('17', 'Iced Cafe Americano', 75.00, 2, 'Available', '2025-03-27 20:58:28', '17_Iced_Cafe_Americano.webp', 'To Be Made', 0, NULL),
('18', 'Iced Cafe Frizzy', 80.00, 2, 'Available', '2025-03-27 20:59:23', '18_Iced_Cafe_Frizzy.jpg', 'To Be Made', 0, NULL),
('19', 'Iced Cappuccino', 80.00, 2, 'Available', '2025-03-27 21:00:14', '19_Iced_Cappuccino.webp', 'To Be Made', 0, NULL),
('2', 'Coffee Cappuccino', 750.00, 1, 'Available', '2025-03-27 20:34:32', '2_Coffee_Cappuccino.jpg', 'To Be Made', 0, NULL),
('20', 'Iced White Choco Mocha ', 115.00, 2, 'Available', '2025-03-27 21:00:51', '20_Iced_White_Choco_Mocha_.jpg', 'To Be Made', 0, NULL),
('21', 'Angel Affogato', 75.00, 2, 'Available', '2025-03-27 21:01:57', '21_Angel_Affogato.jpg', 'To Be Made', 0, NULL),
('22', 'Iced Spanish Latte', 115.00, 2, 'Available', '2025-03-27 21:02:51', '22_Iced_Spanish_Latte.jpg', 'To Be Made', 0, NULL),
('23', 'Iced Hazelnut Latte', 115.00, 2, 'Available', '2025-03-27 21:03:18', '23_Iced_Hazelnut_Latte.jpg', 'To Be Made', 0, NULL),
('24', 'Iced Salted Caramel Macchiato', 115.00, 2, 'Available', '2025-03-27 21:04:34', '24_Iced_Salted_Caramel_Macchiato.jpg', 'To Be Made', 0, NULL),
('25', 'Iced Vanilla Latte', 115.00, 2, 'Available', '2025-03-27 21:05:12', '25_Iced_Vanilla_Latte.webp', 'To Be Made', 0, NULL),
('26', 'Iced Peppermint Latte', 115.00, 2, 'Available', '2025-03-27 21:05:36', '26_Iced_Peppermint_Latte.webp', 'To Be Made', 0, NULL),
('27', 'Iced Matcha Latte', 115.00, 2, 'Available', '2025-03-27 21:05:59', '27_Iced_Matcha_Latte.jpg', 'To Be Made', 0, NULL),
('28', 'Iced Americano w/ Lemon', 90.00, 2, 'Available', '2025-03-27 21:13:22', '28_Iced_Americano_w__Lemon.jpg', 'To Be Made', 0, NULL),
('29', 'Apple Juice', 55.00, 3, 'Available', '2025-03-27 21:36:32', '29_Apple_Juice.webp', 'To Be Made', 0, NULL),
('3', 'Caramel Macchiato', 90.00, 1, 'Available', '2025-03-27 20:34:56', '3_Caramel_Macchiato.jpg', 'To Be Made', 0, NULL),
('30', 'Carrot Juice', 60.00, 3, 'Available', '2025-03-27 21:36:56', '30_Carrot_Juice.webp', 'To Be Made', 0, NULL),
('31', 'Mango Juice', 55.00, 3, 'Available', '2025-03-27 21:37:26', '31_Mango_Juice.jpg', 'To Be Made', 0, NULL),
('32', 'Yakult Lemonade', 55.00, 3, 'Available', '2025-03-27 21:38:20', '32_Yakult_Lemonade.jpeg', 'To Be Made', 0, NULL),
('33', 'Yakult Honey Lemonade', 75.00, 3, 'Available', '2025-03-27 21:39:01', '33_Yakult_Honey_Lemonade.jpg', 'To Be Made', 0, NULL),
('34', 'Yakult Apple Lemonade', 75.00, 2, 'Available', '2025-03-27 21:40:38', '34_Yakult_Apple_Lemonade.jpg', 'To Be Made', 0, NULL),
('35', 'Yakult Orange Lemonade', 75.00, 3, 'Available', '2025-03-27 21:41:31', '35_Yakult_Orange_Lemonade.png', 'To Be Made', 0, NULL),
('36', 'Yakult Sprite Lemonade', 75.00, 3, 'Available', '2025-03-27 21:42:03', '36_Yakult_Sprite_Lemonade.jpg', 'To Be Made', 0, NULL),
('37', 'Yakult Mango Lemonade', 75.00, 3, 'Available', '2025-03-27 21:43:26', '37_Yakult_Mango_Lemonade.jpg', 'To Be Made', 0, NULL),
('38', 'Yakult Caramel Lemonade', 75.00, 3, 'Available', '2025-03-27 21:43:53', NULL, 'To Be Made', 0, NULL),
('39', 'Yakult Strawberry Lemonade', 75.00, 3, 'Available', '2025-03-27 21:46:14', '39_Yakult_Strawberry_Lemonade.jpg', 'To Be Made', 0, NULL),
('4', 'Salted Caramel Macchiato', 90.00, 1, 'Available', '2025-03-27 20:36:41', '4_Salted_Caramel_Macchiato.jpg', 'To Be Made', 0, NULL),
('40', 'Strawberry Mango Blue Lemonade', 75.00, 3, 'Available', '2025-03-27 21:47:21', NULL, 'To Be Made', 0, NULL),
('41', 'Strawberry Orange Blue Lemonade', 75.00, 3, 'Available', '2025-03-27 21:48:25', NULL, 'To Be Made', 0, NULL),
('42', 'Strawberry Apple Lemonade', 75.00, 3, 'Available', '2025-03-27 21:49:10', '42_Strawberry_Apple_Lemonade.webp', 'To Be Made', 0, NULL),
('43', 'Orange Juice', 55.00, 3, 'Available', '2025-03-27 21:50:25', '43_Orange_Juice.jpg', 'To Be Made', 0, NULL),
('44', 'Apple Carrot Juice', 75.00, 3, 'Available', '2025-03-27 21:50:47', '44_Apple_Carrot_Juice.webp', 'To Be Made', 0, NULL),
('45', 'Fresh Lemon Juice', 60.00, 3, 'Available', '2025-03-27 21:51:25', '45_Fresh_Lemon_Juice.jpg', 'To Be Made', 0, NULL),
('46', 'Mogu-Mogu Yakult', 55.00, 3, 'Available', '2025-03-27 21:52:09', NULL, 'To Be Made', 0, NULL),
('47', 'Mogu-Mogu Yakult w/ Lemon', 75.00, 3, 'Available', '2025-03-27 21:52:36', NULL, 'To Be Made', 0, NULL),
('48', 'Mogu-Mogu Yakult w/ Honey', 85.00, 3, 'Available', '2025-03-27 21:53:08', NULL, 'To Be Made', 0, NULL),
('49', 'Mogu-Mogu w/ Honey', 85.00, 3, 'Available', '2025-03-27 21:54:10', NULL, 'To Be Made', 0, NULL),
('5', 'Cafe Mocha', 90.00, 1, 'Available', '2025-03-27 20:37:07', '5_Cafe_Mocha.jpg', 'To Be Made', 0, NULL),
('50', 'Mango Matcha Latte', 75.00, 3, 'Available', '2025-03-27 21:54:54', '50_Mango_Matcha_Latte.jpg', 'To Be Made', 0, NULL),
('51', 'Mango Strawberry Latte', 75.00, 3, 'Available', '2025-03-27 21:55:21', NULL, 'To Be Made', 0, NULL),
('52', 'Avocado Milktea', 60.00, 4, 'Available', '2025-03-27 22:07:37', '52_Avocado_Milktea.jpg', 'To Be Made', 0, NULL),
('53', 'Wintermelon Milktea', 60.00, 4, 'Available', '2025-03-27 22:08:06', '53_Wintermelon_Milktea.jpg', 'To Be Made', 0, NULL),
('54', 'Okinawa Milktea', 60.00, 4, 'Available', '2025-03-27 22:09:11', '54_Okinawa_Milktea.webp', 'To Be Made', 0, NULL),
('55', 'Mango Milktea', 60.00, 4, 'Available', '2025-03-27 22:09:45', '55_Mango_Milktea.jpg', 'To Be Made', 0, NULL),
('56', 'Oreo Milktea', 60.00, 4, 'Available', '2025-03-27 22:11:55', '56_Oreo_Milktea.jpg', 'To Be Made', 0, NULL),
('58', 'Caramel Milktea', 60.00, 4, 'Available', '2025-03-27 22:13:47', '58_Caramel_Milktea.jpg', 'To Be Made', 0, NULL),
('59', 'Chocolate Milktea', 60.00, 4, 'Available', '2025-03-27 22:14:29', '59_Chocolate_Milktea.jpg', 'To Be Made', 0, NULL),
('6', 'Cafe Latte', 85.00, 1, 'Available', '2025-03-27 20:37:38', '6_Cafe_Latte.jpg', 'To Be Made', 0, NULL),
('60', 'Mocha Milktea', 60.00, 4, 'Available', '2025-03-27 22:15:13', '60_Mocha_Milktea.jpg', 'To Be Made', 0, NULL),
('61', 'Matcha Milktea', 60.00, 4, 'Available', '2025-03-27 22:15:38', '61_Matcha_Milktea.jpg', 'To Be Made', 0, NULL),
('62', 'Taro Milktea', 60.00, 4, 'Available', '2025-03-27 22:15:59', '62_Taro_Milktea.jpeg', 'To Be Made', 0, NULL),
('63', 'Red Velvet Milktea', 60.00, 4, 'Available', '2025-03-27 22:16:36', '63_Red_Velvet_Milktea.jpg', 'To Be Made', 0, NULL),
('64', 'Ube Milktea', 60.00, 4, 'Available', '2025-03-27 22:18:10', '64_Ube_Milktea.jpg', 'To Be Made', 0, NULL),
('65', 'Pandan Milktea', 60.00, 4, 'Available', '2025-03-27 22:18:32', '65_Pandan_Milktea.jpg', 'To Be Made', 0, NULL),
('66', 'Strawberry Milktea', 60.00, 4, 'Available', '2025-03-27 22:19:07', '66_Strawberry_Milktea.jpg', 'To Be Made', 0, NULL),
('67', 'Melon Milktea', 60.00, 4, 'Available', '2025-03-27 22:19:39', '67_Melon_Milktea.jpg', 'To Be Made', 0, NULL),
('68', 'Ube Taro Milktea', 60.00, 4, 'Available', '2025-03-27 22:20:09', '68_Ube_Taro_Milktea.jpg', 'To Be Made', 0, NULL),
('69', 'Cookies & Cream', 90.00, 6, 'Available', '2025-03-27 22:33:17', '69_Cookies_&_Cream.jpg', 'To Be Made', 0, NULL),
('7', 'Cafe Latte Macchiato', 85.00, 1, 'Available', '2025-03-27 20:38:07', '7_Cafe_Latte_Macchiato.jpg', 'To Be Made', 0, NULL),
('70', 'Ube Frappe', 90.00, 6, 'Available', '2025-03-27 22:33:38', '70_Ube_Frappe.jpg', 'To Be Made', 0, NULL),
('71', 'Mocha Frappe', 135.00, 6, 'Available', '2025-03-27 22:34:09', '71_Mocha_Frappe.webp', 'To Be Made', 0, NULL),
('72', 'Matcha Frappe', 90.00, 6, 'Available', '2025-03-27 22:35:20', '72_Matcha_Frappe.webp', 'To Be Made', 0, NULL),
('73', 'Mango Frappe', 90.00, 6, 'Available', '2025-03-27 22:35:48', '73_Mango_Frappe.jpg', 'To Be Made', 0, NULL),
('74', 'Chocolate Frappe', 90.00, 6, 'Available', '2025-03-27 22:36:16', '74_Chocolate_Frappe.jpg', 'To Be Made', 0, NULL),
('75', 'Strawberry Frappe', 90.00, 6, 'Available', '2025-03-27 22:36:56', '75_Strawberry_Frappe.webp', 'To Be Made', 0, NULL),
('76', 'Pandan Frappe', 90.00, 6, 'Available', '2025-03-27 22:37:18', '76_Pandan_Frappe.jpg', 'To Be Made', 0, NULL),
('77', 'Avocado Frappe', 90.00, 6, 'Available', '2025-03-27 22:37:46', '77_Avocado_Frappe.webp', 'To Be Made', 0, NULL),
('78', 'Melon Frappe', 90.00, 6, 'Available', '2025-03-27 22:38:11', '78_Melon_Frappe.webp', 'To Be Made', 0, NULL),
('79', 'Cookies & Coffee Frappe', 135.00, 6, 'Available', '2025-03-27 22:38:36', '79_Cookies_&_Coffee_Frappe.jpg', 'To Be Made', 0, NULL),
('8', 'Hazelnut Latte', 90.00, 1, 'Available', '2025-03-27 20:38:45', '8_Hazelnut_Latte.jpg', 'To Be Made', 0, NULL),
('80', 'Hot Chocolate', 75.00, 5, 'Available', '2025-03-27 22:40:51', '80_Hot_Chocolate.jpg', 'To Be Made', 0, NULL),
('81', 'Cold Chocolate', 85.00, 5, 'Available', '2025-03-27 22:41:55', '81_Cold_Chocolate.jpg', 'To Be Made', 0, NULL),
('82', 'Carbonara', 70.00, 7, 'Available', '2025-03-27 22:47:12', '82_Carbonara.jpg', 'To Be Made', 0, NULL),
('83', 'Baked Mac', 70.00, 7, 'Available', '2025-03-27 22:48:39', '83_Baked_Mac.jpg', 'To Be Made', 0, NULL),
('84', 'Tuna Pasta', 70.00, 7, 'Available', '2025-03-27 22:49:02', '84_Tuna_Pasta.jpg', 'To Be Made', 0, NULL),
('85', 'Mineral Water', 10.00, 9, 'Out of Stock', '2025-03-28 00:50:55', '85_Mineral_Water.jpg', 'Ready-Made', 22, 5),
('86', 'Milkis', 60.00, 9, 'Out of Stock', '2025-03-27 23:17:10', '86_Milkis.jpg', 'Ready-Made', 8, 10),
('9', 'Spanish Latte', 90.00, 1, 'Available', '2025-03-27 20:39:10', '9_Spanish_Latte.jpeg', 'To Be Made', 0, NULL);

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

-- --------------------------------------------------------

--
-- Table structure for table `inventory_transactions`
--

CREATE TABLE `inventory_transactions` (
  `id` int(11) NOT NULL,
  `ProductID` varchar(36) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `transaction_type` enum('Add','Update','Deduct') NOT NULL,
  `quantity` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventory_transactions`
--

INSERT INTO `inventory_transactions` (`id`, `ProductID`, `product_name`, `transaction_type`, `quantity`, `created_at`) VALUES
(2, '86', 'Milkis', 'Add', 10, '2025-03-28 11:28:34'),
(7, '86', 'Milkis', 'Deduct', 3, '2025-03-28 11:31:52'),
(10, '86', 'Milkis', 'Deduct', 3, '2025-03-28 11:43:35'),
(19, '86', 'Milkis', 'Add', 4, '2025-03-28 12:33:26'),
(23, '85', 'Mineral Water', 'Add', 11, '2025-03-28 12:51:22'),
(24, '85', 'Mineral Water', 'Add', 11, '2025-03-28 12:52:16');

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
  `OrderStatus` varchar(50) NOT NULL DEFAULT 'Pending',
  `PaymentMethod` enum('Cash','Tally') NOT NULL DEFAULT 'Cash',
  `EmployeeID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `order_history`
--

CREATE TABLE `order_history` (
  `history_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `customer_name` varchar(255) DEFAULT NULL,
  `total_items` int(11) NOT NULL DEFAULT 0,
  `total_amount` decimal(10,2) DEFAULT NULL,
  `payment_method` varchar(50) NOT NULL DEFAULT 'Cash',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_history`
--

INSERT INTO `order_history` (`history_id`, `order_id`, `customer_name`, `total_items`, `total_amount`, `payment_method`, `created_at`) VALUES
(1, 0, 'Orent', 40, 4410.00, 'Tally', '2025-03-28 11:04:55'),
(2, 0, 'Gi', 8, 630.00, 'Cash', '2025-03-28 11:31:52'),
(3, 0, 'Orent', 7, 220.00, 'Cash', '2025-03-28 11:43:35'),
(4, 0, 'Myk', 7, 810.00, 'Cash', '2025-03-28 11:45:48'),
(5, 0, 'Myk', 7, 810.00, 'Cash', '2025-03-28 11:46:11'),
(6, 0, 'John', 5, 380.00, 'Cash', '2025-03-28 11:49:21');

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
(1, 1, 77, 'Avocado Frappe', 1, 90.00),
(2, 1, 74, 'Chocolate Frappe', 1, 90.00),
(3, 1, 79, 'Cookies & Coffee Frappe', 1, 135.00),
(4, 1, 69, 'Cookies & Cream', 1, 90.00),
(5, 1, 73, 'Mango Frappe', 1, 90.00),
(6, 1, 72, 'Matcha Frappe', 1, 90.00),
(7, 1, 78, 'Melon Frappe', 1, 90.00),
(8, 1, 71, 'Mocha Frappe', 1, 135.00),
(9, 1, 81, 'Cold Chocolate', 1, 85.00),
(10, 1, 70, 'Ube Frappe', 1, 90.00),
(11, 1, 75, 'Strawberry Frappe', 1, 90.00),
(12, 1, 76, 'Pandan Frappe', 1, 90.00),
(13, 1, 80, 'Hot Chocolate', 1, 75.00),
(14, 1, 1, 'Cafe Americano', 1, 70.00),
(15, 1, 6, 'Cafe Latte', 1, 85.00),
(16, 1, 7, 'Cafe Latte Macchiato', 1, 85.00),
(17, 1, 8, 'Hazelnut Latte', 1, 90.00),
(18, 1, 2, 'Coffee Cappuccino', 1, 750.00),
(19, 1, 3, 'Caramel Macchiato', 1, 90.00),
(20, 1, 5, 'Cafe Mocha', 1, 90.00),
(21, 1, 13, 'Hot Tea', 1, 60.00),
(22, 1, 12, 'Matcha Cafe Latte', 1, 90.00),
(23, 1, 10, 'Peppermint Latte', 1, 90.00),
(24, 1, 4, 'Salted Caramel Macchiato', 1, 90.00),
(25, 1, 28, 'Iced Americano w/ Lemon', 1, 90.00),
(26, 1, 21, 'Angel Affogato', 1, 75.00),
(27, 1, 11, 'Vanilla Latte', 1, 90.00),
(28, 1, 9, 'Spanish Latte', 1, 90.00),
(29, 1, 17, 'Iced Cafe Americano', 1, 75.00),
(30, 1, 18, 'Iced Cafe Frizzy', 1, 80.00),
(31, 1, 14, 'Iced Cafe Latte', 1, 80.00),
(32, 1, 16, 'Iced Cafe Mocha', 1, 115.00),
(33, 1, 27, 'Iced Matcha Latte', 1, 115.00),
(34, 1, 23, 'Iced Hazelnut Latte', 1, 115.00),
(35, 1, 15, 'Iced Caramel Macchiato', 1, 115.00),
(36, 1, 19, 'Iced Cappuccino', 1, 80.00),
(37, 1, 26, 'Iced Peppermint Latte', 1, 115.00),
(38, 1, 24, 'Iced Salted Caramel Macchiato', 1, 115.00),
(39, 1, 22, 'Iced Spanish Latte', 1, 115.00),
(40, 1, 25, 'Iced Vanilla Latte', 1, 115.00),
(41, 2, 87, 'Demisoda', 3, 70.00),
(42, 2, 86, 'Milkis', 3, 60.00),
(43, 2, 88, 'Bundaberg', 2, 120.00),
(44, 3, 85, 'Mineral Water', 4, 10.00),
(45, 3, 86, 'Milkis', 3, 60.00),
(46, 4, 71, 'Mocha Frappe', 2, 135.00),
(47, 4, 78, 'Melon Frappe', 2, 90.00),
(48, 4, 88, 'Bundaberg', 3, 120.00),
(49, 5, 71, 'Mocha Frappe', 2, 135.00),
(50, 5, 78, 'Melon Frappe', 2, 90.00),
(51, 5, 88, 'Bundaberg', 3, 120.00),
(52, 6, 85, 'Mineral Water', 2, 10.00),
(53, 6, 88, 'Bundaberg', 3, 120.00);

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
(1, '57', 'Matcha Milktea', 'Delete', 'To Be Made', 60.00, 4, '2025-03-28 10:13:21'),
(2, '85', 'Mineral Water', 'Delete', 'Ready-Made', 10.00, 9, '2025-03-28 12:16:07'),
(3, '85', 'Mineral Water', 'Delete', 'Ready-Made', 10.00, 2, '2025-03-28 12:48:30'),
(4, '87', 'Demisoda', 'Delete', 'Ready-Made', 70.00, 6, '2025-03-28 12:50:19'),
(5, '88', 'Bundaberg', 'Delete', 'Ready-Made', 120.00, 9, '2025-03-28 12:50:27');

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
(1, '77', '', NULL, 1, 0.00, 90.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(2, '74', '', NULL, 1, 0.00, 90.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(3, '79', '', NULL, 1, 0.00, 135.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(4, '69', '', NULL, 1, 0.00, 90.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(5, '73', '', NULL, 1, 0.00, 90.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(6, '72', '', NULL, 1, 0.00, 90.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(7, '78', '', NULL, 1, 0.00, 90.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(8, '71', '', NULL, 1, 0.00, 135.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(9, '81', '', NULL, 1, 0.00, 85.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(10, '70', '', NULL, 1, 0.00, 90.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(11, '75', '', NULL, 1, 0.00, 90.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(12, '76', '', NULL, 1, 0.00, 90.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(13, '80', '', NULL, 1, 0.00, 75.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(14, '1', '', NULL, 1, 0.00, 70.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(15, '6', '', NULL, 1, 0.00, 85.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(16, '7', '', NULL, 1, 0.00, 85.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(17, '8', '', NULL, 1, 0.00, 90.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(18, '2', '', NULL, 1, 0.00, 750.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(19, '3', '', NULL, 1, 0.00, 90.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(20, '5', '', NULL, 1, 0.00, 90.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(21, '13', '', NULL, 1, 0.00, 60.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(22, '12', '', NULL, 1, 0.00, 90.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(23, '10', '', NULL, 1, 0.00, 90.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(24, '4', '', NULL, 1, 0.00, 90.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(25, '28', '', NULL, 1, 0.00, 90.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(26, '21', '', NULL, 1, 0.00, 75.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(27, '11', '', NULL, 1, 0.00, 90.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(28, '9', '', NULL, 1, 0.00, 90.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(29, '17', '', NULL, 1, 0.00, 75.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(30, '18', '', NULL, 1, 0.00, 80.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(31, '14', '', NULL, 1, 0.00, 80.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(32, '16', '', NULL, 1, 0.00, 115.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(33, '27', '', NULL, 1, 0.00, 115.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(34, '23', '', NULL, 1, 0.00, 115.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(35, '15', '', NULL, 1, 0.00, 115.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(36, '19', '', NULL, 1, 0.00, 80.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(37, '26', '', NULL, 1, 0.00, 115.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(38, '24', '', NULL, 1, 0.00, 115.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(39, '22', '', NULL, 1, 0.00, 115.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(40, '25', '', NULL, 1, 0.00, 115.00, '2025-03-28 11:04:55', '2025-03-28 11:04:55'),
(42, '86', '', NULL, 3, 0.00, 180.00, '2025-03-28 11:31:52', '2025-03-28 11:31:52'),
(45, '86', '', NULL, 3, 0.00, 180.00, '2025-03-28 11:43:35', '2025-03-28 11:43:35'),
(46, '71', '', NULL, 2, 0.00, 270.00, '2025-03-28 11:45:48', '2025-03-28 11:45:48'),
(47, '78', '', NULL, 2, 0.00, 180.00, '2025-03-28 11:45:48', '2025-03-28 11:45:48'),
(49, '71', '', NULL, 2, 0.00, 270.00, '2025-03-28 11:46:11', '2025-03-28 11:46:11'),
(50, '78', '', NULL, 2, 0.00, 180.00, '2025-03-28 11:46:11', '2025-03-28 11:46:11');

-- --------------------------------------------------------

--
-- Table structure for table `stock_details`
--

CREATE TABLE `stock_details` (
  `id` int(11) NOT NULL,
  `ProductID` varchar(36) NOT NULL,
  `batch_number` varchar(255) NOT NULL,
  `quantity` int(11) NOT NULL,
  `expiration_date` date DEFAULT NULL,
  `SupplierID` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `transaction_type` enum('IN','OUT') DEFAULT 'IN'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stock_details`
--

INSERT INTO `stock_details` (`id`, `ProductID`, `batch_number`, `quantity`, `expiration_date`, `SupplierID`, `created_at`, `transaction_type`) VALUES
(2, '86', '1', 4, '2025-03-31', 2, '2025-03-28 11:28:34', 'IN'),
(9, '86', '2', 4, '2025-03-31', 2, '2025-03-28 12:33:26', 'IN'),
(13, '85', '1', 11, '2025-03-31', 2, '2025-03-28 12:51:22', 'IN'),
(14, '85', '2', 11, '2025-03-31', 2, '2025-03-28 12:52:16', 'IN');

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
(2, 'James Smith', '0987456123', 'jamessmith@gmail.com'),
(3, 'John Doe', '12234556', 'john.doe@example.com');

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
  ADD KEY `fk_product_id` (`ProductID`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`OrderID`);

--
-- Indexes for table `order_history`
--
ALTER TABLE `order_history`
  ADD PRIMARY KEY (`history_id`);

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
  ADD KEY `category_id` (`category_id`),
  ADD KEY `product_transactions_ibfk_1` (`product_id`);

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
  ADD KEY `stock_details_ibfk_1` (`ProductID`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `inventory_reports`
--
ALTER TABLE `inventory_reports`
  MODIFY `ReportID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inventory_transactions`
--
ALTER TABLE `inventory_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `OrderID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_history`
--
ALTER TABLE `order_history`
  MODIFY `history_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `order_history_detail`
--
ALTER TABLE `order_history_detail`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_transactions`
--
ALTER TABLE `product_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `reports`
--
ALTER TABLE `reports`
  MODIFY `ReportID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sales`
--
ALTER TABLE `sales`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT for table `stock_details`
--
ALTER TABLE `stock_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

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
  ADD CONSTRAINT `fk_product_id` FOREIGN KEY (`ProductID`) REFERENCES `inventoryproduct` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `order_history_detail`
--
ALTER TABLE `order_history_detail`
  ADD CONSTRAINT `fk_order_history_detail_history_id` FOREIGN KEY (`order_id`) REFERENCES `order_history` (`history_id`) ON DELETE CASCADE;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`OrderID`) REFERENCES `orders` (`OrderID`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`ProductID`) REFERENCES `inventoryproduct` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product_transactions`
--
ALTER TABLE `product_transactions`
  ADD CONSTRAINT `product_transactions_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`);

--
-- Constraints for table `sales`
--
ALTER TABLE `sales`
  ADD CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `inventoryproduct` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `stock_details`
--
ALTER TABLE `stock_details`
  ADD CONSTRAINT `stock_details_ibfk_1` FOREIGN KEY (`ProductID`) REFERENCES `inventoryproduct` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
