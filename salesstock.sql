-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : mer. 28 oct. 2026 à 13:33
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `salesstock`
--

-- --------------------------------------------------------

--
-- Structure de la table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `cache`
--

INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('salesstock_cache_6d8d5e93eac699e086afd2ff1de6ae70', 'i:1;', 1793138224),
('salesstock_cache_6d8d5e93eac699e086afd2ff1de6ae70:timer', 'i:1793138224;', 1793138224),
('salesstock_cache_83582c40e28d31cf02feecf512156806', 'i:1;', 1793136101),
('salesstock_cache_83582c40e28d31cf02feecf512156806:timer', 'i:1793136101;', 1793136101),
('salesstock_cache_88c58d0d41bbbe0acdcf212b3c142919', 'i:1;', 1793143018),
('salesstock_cache_88c58d0d41bbbe0acdcf212b3c142919:timer', 'i:1793143018;', 1793143018),
('salesstock_cache_a75f3f172bfb296f2e10cbfc6dfc1883', 'i:1;', 1793143017),
('salesstock_cache_a75f3f172bfb296f2e10cbfc6dfc1883:timer', 'i:1793143017;', 1793143017),
('salesstock_cache_e9b6cc1432541b9ceebf113eee05eeba', 'i:1;', 1793138356),
('salesstock_cache_e9b6cc1432541b9ceebf113eee05eeba:timer', 'i:1793138356;', 1793138356),
('salesstock_cache_f1f70ec40aaa556905d4a030501c0ba4', 'i:3;', 1793147575),
('salesstock_cache_f1f70ec40aaa556905d4a030501c0ba4:timer', 'i:1793147574;', 1793147574),
('salesstock_cache_settings.all', 'a:5:{s:12:\"company_name\";s:10:\"SalesStock\";s:8:\"currency\";s:4:\"FCFA\";s:15:\"currency_symbol\";s:4:\"FCFA\";s:16:\"default_tax_rate\";s:2:\"18\";s:27:\"default_low_stock_threshold\";s:1:\"5\";}', 2108507463);

-- --------------------------------------------------------

--
-- Structure de la table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `categories`
--

CREATE TABLE `categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `categories`
--

INSERT INTO `categories` (`id`, `name`, `slug`, `description`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Électronique', 'electronique', 'Accessoires et périphériques électroniques du quotidien.', '2026-10-27 20:19:06', '2026-10-27 20:19:06', NULL),
(2, 'Informatique', 'informatique', 'Ordinateurs, composants et équipements de bureau.', '2026-10-27 20:19:06', '2026-10-27 20:19:06', NULL),
(3, 'Téléphonie', 'telephonie', 'Accessoires pour smartphones et tablettes.', '2026-10-27 20:19:06', '2026-10-27 20:19:06', NULL),
(4, 'Maison & Électroménager', 'maison-electromenager', 'Appareils et équipements pour la maison.', '2026-10-27 20:19:07', '2026-10-27 20:19:07', NULL),
(5, 'Bureau & Fournitures', 'bureau-fournitures', 'Fournitures et matériel de bureau.', '2026-10-27 20:19:07', '2026-10-27 20:19:07', NULL),
(6, 'Vêtements & Accessoires', 'vetements-accessoires', 'Mode, chaussures et accessoires.', '2026-10-27 20:19:07', '2026-10-27 20:19:07', NULL),
(7, 'Alimentation', 'alimentation', 'Produits d\'épicerie et denrées de base.', '2026-10-27 20:19:07', '2026-10-27 20:19:07', NULL),
(8, 'Sport & Loisirs', 'sport-loisirs', 'Équipements de sport et articles de loisirs.', '2026-10-27 20:19:07', '2026-10-27 20:19:07', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `customers`
--

CREATE TABLE `customers` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `customers`
--

INSERT INTO `customers` (`id`, `name`, `email`, `phone`, `address`, `notes`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Entreprise Kodjo & Fils', 'entreprise.kodjo.fils@exemple.ci', '+225 06 81 10 29 44', '86, place Colette Carlier, Rolland-sur-Jacob', 'Client régulier, privilégie la livraison.', '2026-10-27 20:19:12', '2026-10-27 20:19:12', NULL),
(2, 'Marie Konan', 'hubert.jeannine@example.com', '+225 06 73 50 71 08', ', De Oliveira', NULL, '2026-10-27 20:19:12', '2026-10-27 20:19:12', NULL),
(3, 'Serge Kouadio', 'sophie.gomes@example.com', '+225 07 76 04 59 13', ', Chevallierboeuf', NULL, '2026-10-27 20:19:12', '2026-10-27 20:19:12', NULL),
(4, 'Aïcha Traoré', 'rperrot@example.com', '+225 03 89 33 39 70', ', Gonzalez', NULL, '2026-10-27 20:19:12', '2026-10-27 20:19:12', NULL),
(5, 'Boutique La Grâce', 'boutique.la.grace@exemple.ci', '+225 03 06 63 34 20', '17, avenue de Texier, Gregoire', NULL, '2026-10-27 20:19:12', '2026-10-27 20:19:12', NULL),
(6, 'Jean-Baptiste N\'Guessan', 'yves90@example.com', '+225 06 41 94 60 72', ', Texier', NULL, '2026-10-27 20:19:12', '2026-10-27 20:19:12', NULL),
(7, 'Fatoumata Coulibaly', 'olivie.roussel@example.com', '+225 01 25 38 35 79', 'avenue de Georges, LerouxBourg', NULL, '2026-10-27 20:19:12', '2026-10-27 20:19:12', NULL),
(8, 'Pharmacie du Plateau', 'pharmacie.du.plateau@exemple.ci', '+225 04 03 18 02 21', '39, rue Agathe Gomez, Brunel', 'Client régulier, privilégie la livraison.', '2026-10-27 20:19:12', '2026-10-27 20:19:12', NULL),
(9, 'Établissements Diabaté', 'etablissements.diabate@exemple.ci', '+225 04 54 07 39 97', '76, place Alix Techer, Huet', NULL, '2026-10-27 20:19:12', '2026-10-27 20:19:12', NULL),
(10, 'Clarisse Yao', 'munoz.anne@example.net', '+225 03 01 00 50 27', '98, rue de Schmitt, Charpentier', NULL, '2026-10-27 20:19:12', '2026-10-27 20:19:12', NULL),
(11, 'Moussa Ouédraogo', 'victor83@example.org', '+225 01 27 51 65 00', ', Ollivier', NULL, '2026-10-27 20:19:12', '2026-10-27 20:19:12', NULL),
(12, 'Superette Espoir', 'superette.espoir@exemple.ci', '+225 04 78 71 40 83', '81, chemin Rolland, Rey-les-Bains', NULL, '2026-10-27 20:19:12', '2026-10-27 20:19:12', NULL),
(13, 'Patrice Zongo', 'thierry77@example.net', '+225 01 16 33 85 85', 'impasse Adrien Imbert, Vallee', NULL, '2026-10-27 20:19:12', '2026-10-27 20:19:12', NULL),
(14, 'Nadège Bamba', 'glefevre@example.com', '+225 05 42 03 54 99', '6, place Renault, Hoareau', NULL, '2026-10-27 20:19:12', '2026-10-27 20:19:12', NULL),
(15, 'Centre informatique Adjangba', 'centre.informatique.adjangba@exemple.ci', '+225 07 40 54 77 90', '27, boulevard Inès Benard, Bertrand-sur-Andre', 'Client régulier, privilégie la livraison.', '2026-10-27 20:19:12', '2026-10-27 20:19:12', NULL),
(16, 'Ibrahim Cissé', 'augustin.gros@example.net', '+225 04 34 39 45 76', ', Martineau', NULL, '2026-10-27 20:19:12', '2026-10-27 20:19:12', NULL),
(17, 'Solange Assamoi', 'isaac66@example.com', '+225 03 24 79 31 90', ', Raynaud-les-Bains', NULL, '2026-10-27 20:19:12', '2026-10-27 20:19:12', NULL),
(18, 'Boulangerie Le Délice', 'boulangerie.le.delice@exemple.ci', '+225 07 16 36 45 21', '22, rue Barthelemy, Becker', NULL, '2026-10-27 20:19:13', '2026-10-27 20:19:13', NULL),
(19, 'Éric Tanoh', 'eugene.descamps@example.org', '+225 03 40 95 03 71', 'avenue Raymond Dumont, Brunet-sur-Pages', NULL, '2026-10-27 20:19:13', '2026-10-27 20:19:13', NULL),
(20, 'Awa Sanogo', 'delannoy.diane@example.net', '+225 05 25 40 74 36', ', Denis-la-Forêt', NULL, '2026-10-27 20:19:13', '2026-10-27 20:19:13', NULL),
(21, 'Restaurant Chez Mama', 'restaurant.chez.mama@exemple.ci', '+225 06 47 46 80 85', ', Gallet', NULL, '2026-10-27 20:19:13', '2026-10-27 20:19:13', NULL),
(22, 'Hervé Gnahoré', 'djulien@example.net', '+225 05 27 01 75 13', ', Tanguy-sur-Lejeune', 'Client régulier, privilégie la livraison.', '2026-10-27 20:19:13', '2026-10-27 20:19:13', NULL),
(23, 'Chantal Doumbia', 'gbodin@example.org', '+225 03 44 57 42 66', ', Guyon', NULL, '2026-10-27 20:19:13', '2026-10-27 20:19:13', NULL),
(24, 'Librairie La Plume', 'librairie.la.plume@exemple.ci', '+225 04 54 61 52 22', '75, rue Meyer, Bazin', NULL, '2026-10-27 20:19:13', '2026-10-27 20:19:13', NULL),
(25, 'Yaya Camara', 'gchevallier@example.net', '+225 01 12 67 62 57', ', Fouquet', NULL, '2026-10-27 20:19:13', '2026-10-27 20:19:13', NULL),
(26, 'Georgette Amani', 'raymond.alex@example.com', '+225 05 76 71 01 77', '4, chemin Dupont, JacquesBourg', NULL, '2026-10-27 20:19:13', '2026-10-27 20:19:13', NULL),
(27, 'Cabinet Conseil Abidjan', 'cabinet.conseil.abidjan@exemple.ci', '+225 03 63 52 19 97', '88, rue de Gerard, Navarro', NULL, '2026-10-27 20:19:13', '2026-10-27 20:19:13', NULL),
(28, 'Sékou Touré', 'zoe29@example.net', '+225 04 42 89 76 91', '46, chemin Bouvier, Dupre-sur-Vaillant', NULL, '2026-10-27 20:19:13', '2026-10-27 20:19:13', NULL),
(29, 'Rachelle Kouamé', 'hgrenier@example.net', '+225 07 03 97 64 13', 'rue Blot, Brunelboeuf', 'Client régulier, privilégie la livraison.', '2026-10-27 20:19:13', '2026-10-27 20:19:13', NULL),
(30, 'Quincaillerie du Nord', 'quincaillerie.du.nord@exemple.ci', '+225 01 13 99 60 65', '76, rue de Menard, Alexandre', NULL, '2026-10-27 20:19:13', '2026-10-27 20:19:13', NULL),
(31, 'Alain Bogui', 'boyer.emmanuelle@example.net', '+225 04 89 92 16 09', '983, rue de Lefort, Colas', NULL, '2026-10-27 20:19:13', '2026-10-27 20:19:13', NULL),
(32, 'Miriam Sery', 'vincent.allain@example.org', '+225 05 41 92 63 76', '67, place Delorme, TecherVille', NULL, '2026-10-27 20:19:13', '2026-10-27 20:19:13', NULL),
(33, 'Garage Auto Plus', 'garage.auto.plus@exemple.ci', '+225 01 54 22 91 14', '37, boulevard Masson, Meunier', NULL, '2026-10-27 20:19:13', '2026-10-27 20:19:13', NULL),
(34, 'Fabrice Yapo', 'xperrot@example.com', '+225 04 23 63 50 73', ', Gregoire', NULL, '2026-10-27 20:19:13', '2026-10-27 20:19:13', NULL),
(35, 'Émilie Sow', 'potier.veronique@example.com', '+225 02 28 41 08 92', '35, rue Odette Michel, Auger-sur-Mer', NULL, '2026-10-27 20:19:13', '2026-10-27 20:19:13', NULL),
(36, 'Épicerie Bonheur', 'epicerie.bonheur@exemple.ci', '+225 04 35 52 20 61', '29, rue de Rousseau, Pelletier', 'Client régulier, privilégie la livraison.', '2026-10-27 20:19:13', '2026-10-27 20:19:13', NULL),
(37, 'Constant Aké', 'laroche.gabriel@example.com', '+225 02 95 60 22 24', ', HamelVille', NULL, '2026-10-27 20:19:13', '2026-10-27 20:19:13', NULL),
(38, 'Josiane Ehoulé', 'marc36@example.net', '+225 07 09 40 23 08', '64, place de Pruvost, Lejeunedan', NULL, '2026-10-27 20:19:14', '2026-10-27 20:19:14', NULL),
(39, 'SARL Matériaux BTP', 'sarl.materiaux.btp@exemple.ci', '+225 03 57 80 51 67', 'rue de Schneider, Bernard-les-Bains', NULL, '2026-10-27 20:19:14', '2026-10-27 20:19:14', NULL),
(40, 'Olivier Sankara', 'benoit.morin@example.com', '+225 07 44 59 74 64', '7, rue Maggie Da Costa, Evrardboeuf', NULL, '2026-10-27 20:19:14', '2026-10-27 20:19:14', NULL),
(41, 'QA Client Phase 6', 'qa.client@salesstock.test', '+225 07 99 88 77 66', 'Cocody, Riviera 3', 'Client QA — fiche mise à jour lors du test Phase 6.', '2026-10-27 23:19:07', '2026-10-27 23:24:53', '2026-10-27 23:24:53');

-- --------------------------------------------------------

--
-- Structure de la table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2026_10_27_000010_create_categories_table', 1),
(5, '2026_10_27_000011_create_products_table', 1),
(6, '2026_10_27_000012_create_customers_table', 1),
(7, '2026_10_27_000013_create_sales_table', 1),
(8, '2026_10_27_000014_create_sale_items_table', 1),
(9, '2026_10_27_000015_create_stock_movements_table', 1),
(10, '2026_10_27_000020_create_settings_table', 1),
(11, '2026_10_27_191316_create_personal_access_tokens_table', 1);

-- --------------------------------------------------------

--
-- Structure de la table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` text NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 1, 'salesstock-web', '4a4c76606ad738494978507211b4d2429d26b4695fb3a19e12e8eb0de0ae0bd6', '[\"*\"]', '2026-10-27 20:21:08', NULL, '2026-10-27 20:21:05', '2026-10-27 20:21:08'),
(3, 'App\\Models\\User', 2, 'salesstock-web', '663e4ff231af782aea7bb888577fb7b8840dd389a556698b0b74a5e820c3c830', '[\"*\"]', '2026-10-27 20:46:14', NULL, '2026-10-27 20:46:13', '2026-10-27 20:46:14'),
(4, 'App\\Models\\User', 1, 'salesstock-web', 'c854222e3d465d1652d1d6222dbb99940b683bfe28f4a7269c9a4296f4dd6f53', '[\"*\"]', '2026-10-27 23:32:01', NULL, '2026-10-27 20:48:06', '2026-10-27 23:32:01'),
(7, 'App\\Models\\User', 1, 'salesstock-web', '50b453e1dad109acf468b64f21c199d275b99d7658b3c049d8b94e7661127476', '[\"*\"]', '2026-10-27 23:26:47', NULL, '2026-10-27 21:49:28', '2026-10-27 23:26:47'),
(8, 'App\\Models\\User', 1, 'salesstock-web', 'b9d8dd530996eced3092b0bd9c7f7daffe3b07ee4d51387c16cd0da260cfeaff', '[\"*\"]', '2026-10-27 22:07:11', NULL, '2026-10-27 22:07:00', '2026-10-27 22:07:11'),
(9, 'App\\Models\\User', 1, 'salesstock-web', 'f0d1dac64ff3e11730d1d1d8e158d21609eb6d3aa691570cd6b1a0783b744a4a', '[\"*\"]', '2026-10-27 22:07:39', NULL, '2026-10-27 22:07:37', '2026-10-27 22:07:39'),
(10, 'App\\Models\\User', 1, 'salesstock-web', '739c168975d8f2ab3a58df9ee7c0e53c57a1481bd283ef5ca15e9fbe6ca2f24a', '[\"*\"]', '2026-10-27 22:10:14', NULL, '2026-10-27 22:10:09', '2026-10-27 22:10:14'),
(11, 'App\\Models\\User', 1, 'salesstock-web', 'db25f5920ca36efdd17669502258909231194dc8612457bd930b148ed0367f63', '[\"*\"]', '2026-10-27 22:14:30', NULL, '2026-10-27 22:14:27', '2026-10-27 22:14:30'),
(12, 'App\\Models\\User', 1, 'salesstock-web', '9a266af4321cf16bd4e1adbdc95b6ee06e8188e28b2029214ae3abde66b4e5a7', '[\"*\"]', '2026-10-27 22:16:00', NULL, '2026-10-27 22:15:59', '2026-10-27 22:16:00');

-- --------------------------------------------------------

--
-- Structure de la table `products`
--

CREATE TABLE `products` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `sku` varchar(255) NOT NULL,
  `category_id` bigint(20) UNSIGNED NOT NULL,
  `description` text DEFAULT NULL,
  `purchase_price` decimal(12,2) NOT NULL DEFAULT 0.00,
  `selling_price` decimal(12,2) NOT NULL,
  `quantity` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `low_stock_threshold` int(10) UNSIGNED NOT NULL DEFAULT 5,
  `image` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `products`
--

INSERT INTO `products` (`id`, `name`, `sku`, `category_id`, `description`, `purchase_price`, `selling_price`, `quantity`, `low_stock_threshold`, `image`, `is_active`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Casque audio sans fil Pro', 'ELEC-0001', 1, NULL, 17900.00, 25000.00, 33, 8, NULL, 1, '2026-10-27 20:19:07', '2026-10-27 20:19:15', NULL),
(2, 'Enceinte Bluetooth nomade', 'ELEC-0002', 1, NULL, 13200.00, 18500.00, 12, 6, NULL, 1, '2026-10-27 20:19:07', '2026-10-27 20:19:15', NULL),
(3, 'Chargeur rapide USB-C 25W', 'ELEC-0003', 1, NULL, 4600.00, 6500.00, 100, 15, NULL, 1, '2026-10-27 20:19:07', '2026-10-27 20:19:15', NULL),
(4, 'Câble USB-C tressé 2 m', 'ELEC-0004', 1, NULL, 2500.00, 3500.00, 127, 12, NULL, 1, '2026-10-27 20:19:07', '2026-10-27 20:19:15', NULL),
(5, 'Batterie externe 20 000 mAh', 'ELEC-0005', 1, NULL, 10700.00, 15000.00, 32, 8, NULL, 1, '2026-10-27 20:19:07', '2026-10-27 22:12:39', NULL),
(6, 'Adaptateur secteur universel', 'ELEC-0006', 1, NULL, 3900.00, 5500.00, 0, 5, NULL, 0, '2026-10-27 20:19:08', '2026-10-27 21:27:22', NULL),
(7, 'Hub USB-C 4 ports', 'ELEC-0007', 1, NULL, 8600.00, 12000.00, 0, 5, NULL, 1, '2026-10-27 20:19:08', '2026-10-27 20:19:15', NULL),
(8, 'Lampe LED de bureau', 'ELEC-0008', 1, NULL, 5700.00, 8000.00, 0, 6, NULL, 1, '2026-10-27 20:19:08', '2026-10-27 20:19:15', NULL),
(9, 'Clavier mécanique rétroéclairé', 'INFO-0001', 2, NULL, 22900.00, 32000.00, 93, 5, NULL, 1, '2026-10-27 20:19:08', '2026-10-27 20:19:15', NULL),
(10, 'Souris gaming 6400 DPI', 'INFO-0002', 2, NULL, 10400.00, 14500.00, 23, 8, NULL, 1, '2026-10-27 20:19:08', '2026-10-27 20:19:15', NULL),
(11, 'Écran LED 24\" Full HD', 'INFO-0003', 2, NULL, 60700.00, 85000.00, 0, 3, NULL, 1, '2026-10-27 20:19:08', '2026-10-27 20:19:15', NULL),
(12, 'SSD NVMe 1 To', 'INFO-0004', 2, NULL, 37100.00, 52000.00, 0, 4, NULL, 1, '2026-10-27 20:19:08', '2026-10-27 20:19:15', NULL),
(13, 'Barrette mémoire RAM 16 Go DDR4', 'INFO-0005', 2, NULL, 20000.00, 28000.00, 0, 4, NULL, 1, '2026-10-27 20:19:08', '2026-10-27 20:19:16', NULL),
(14, 'Webcam HD 1080p', 'INFO-0006', 2, NULL, 11800.00, 16500.00, 22, 6, NULL, 1, '2026-10-27 20:19:08', '2026-10-27 20:19:16', NULL),
(15, 'Station d\'accueil USB-C', 'INFO-0007', 2, NULL, 32100.00, 45000.00, 20, 3, NULL, 1, '2026-10-27 20:19:08', '2026-10-27 20:19:16', NULL),
(16, 'Disque dur externe 2 To', 'INFO-0008', 2, NULL, 34300.00, 48000.00, 1, 4, NULL, 1, '2026-10-27 20:19:08', '2026-10-27 20:19:16', NULL),
(17, 'Support portable ergonomique', 'INFO-0009', 2, NULL, 15000.00, 21000.00, 0, 3, NULL, 1, '2026-10-27 20:19:08', '2026-10-27 20:19:16', NULL),
(18, 'Coque de protection iPhone 15', 'TEL-0001', 3, NULL, 3200.00, 4500.00, 64, 15, NULL, 1, '2026-10-27 20:19:08', '2026-10-27 20:19:16', NULL),
(19, 'Verre trempé universel', 'TEL-0002', 3, NULL, 1800.00, 2500.00, 175, 20, NULL, 1, '2026-10-27 20:19:08', '2026-10-27 20:19:16', NULL),
(20, 'Support voiture magnétique', 'TEL-0003', 3, NULL, 3600.00, 5000.00, 36, 10, NULL, 1, '2026-10-27 20:19:09', '2026-10-27 20:19:16', NULL),
(21, 'Chargeur secteur 33W double port', 'TEL-0004', 3, NULL, 6800.00, 9500.00, 26, 8, NULL, 1, '2026-10-27 20:19:09', '2026-10-27 20:19:16', NULL),
(22, 'Écouteurs sans fil TWS', 'TEL-0005', 3, NULL, 8900.00, 12500.00, 41, 10, NULL, 1, '2026-10-27 20:19:09', '2026-10-27 20:19:16', NULL),
(23, 'Câble Lightning tressé 1,5 m', 'TEL-0006', 3, NULL, 2900.00, 4000.00, 0, 10, NULL, 1, '2026-10-27 20:19:09', '2026-10-27 20:19:16', NULL),
(24, 'Batterie solaire 10 000 mAh', 'TEL-0007', 3, NULL, 12500.00, 17500.00, 2, 4, NULL, 1, '2026-10-27 20:19:09', '2026-10-27 20:19:16', NULL),
(25, 'Housse de téléphone en cuir', 'TEL-0008', 3, NULL, 4300.00, 6000.00, 3, 8, NULL, 1, '2026-10-27 20:19:09', '2026-10-27 20:19:16', NULL),
(26, 'Ventilateur tour 45 cm', 'MAIS-0001', 4, NULL, 15700.00, 22000.00, 75, 5, NULL, 1, '2026-10-27 20:19:09', '2026-10-27 20:19:16', NULL),
(27, 'Bouilloire électrique 1,7 L', 'MAIS-0002', 4, NULL, 8900.00, 12500.00, 71, 6, NULL, 1, '2026-10-27 20:19:09', '2026-10-27 20:19:16', NULL),
(28, 'Grill-pain 2 fentes', 'MAIS-0003', 4, NULL, 10000.00, 14000.00, 0, 5, NULL, 1, '2026-10-27 20:19:09', '2026-10-27 20:19:16', NULL),
(29, 'Mixeur plongeant 3 vitesses', 'MAIS-0004', 4, NULL, 13900.00, 19500.00, 40, 4, NULL, 1, '2026-10-27 20:19:09', '2026-10-27 20:19:16', NULL),
(30, 'Fer à repasser vapeur', 'MAIS-0005', 4, NULL, 11400.00, 16000.00, 8, 5, NULL, 1, '2026-10-27 20:19:09', '2026-10-27 20:19:16', NULL),
(31, 'Machine à café expresso', 'MAIS-0006', 4, NULL, 46400.00, 65000.00, 0, 3, NULL, 1, '2026-10-27 20:19:09', '2026-10-27 20:19:16', NULL),
(32, 'Robot pâtissier 5 L', 'MAIS-0007', 4, NULL, 55700.00, 78000.00, 0, 2, NULL, 1, '2026-10-27 20:19:09', '2026-10-27 20:19:16', NULL),
(33, 'Aspirateur balai 2 en 1', 'MAIS-0008', 4, NULL, 30000.00, 42000.00, 0, 4, NULL, 1, '2026-10-27 20:19:09', '2026-10-27 22:19:45', NULL),
(34, 'Ramette A4 80 g (500 feuilles)', 'BUR-0001', 5, NULL, 2700.00, 3800.00, 103, 20, NULL, 1, '2026-10-27 20:19:10', '2026-10-27 20:19:16', NULL),
(35, 'Lot de 10 stylos bille', 'BUR-0002', 5, NULL, 1800.00, 2500.00, 85, 15, NULL, 1, '2026-10-27 20:19:10', '2026-10-27 20:19:16', NULL),
(36, 'Classeur à levier 8 cm', 'BUR-0003', 5, NULL, 1300.00, 1800.00, 106, 20, NULL, 1, '2026-10-27 20:19:10', '2026-10-27 20:19:16', NULL),
(37, 'Chaise de bureau ergonomique', 'BUR-0004', 5, NULL, 41400.00, 58000.00, 0, 3, NULL, 1, '2026-10-27 20:19:10', '2026-10-27 20:19:16', NULL),
(38, 'Bureau pliant 120x60 cm', 'BUR-0005', 5, NULL, 25000.00, 35000.00, 0, 3, NULL, 1, '2026-10-27 20:19:10', '2026-10-27 20:19:16', NULL),
(39, 'Cahier A5 200 p. (lot de 5)', 'BUR-0006', 5, NULL, 3000.00, 4200.00, 161, 12, NULL, 1, '2026-10-27 20:19:10', '2026-10-27 20:19:16', NULL),
(40, 'Toner laser noir compatible', 'BUR-0007', 5, NULL, 17500.00, 24500.00, 0, 4, NULL, 1, '2026-10-27 20:19:10', '2026-10-27 20:19:16', NULL),
(41, 'T-shirt coton unisexe', 'VET-0001', 6, NULL, 3900.00, 5500.00, 75, 15, NULL, 1, '2026-10-27 20:19:10', '2026-10-27 20:19:16', NULL),
(42, 'Jean denim slim', 'VET-0002', 6, NULL, 11100.00, 15500.00, 68, 8, NULL, 1, '2026-10-27 20:19:10', '2026-10-27 20:19:17', NULL),
(43, 'Sneakers cuir blanc', 'VET-0003', 6, NULL, 20000.00, 28000.00, 4, 6, NULL, 1, '2026-10-27 20:19:10', '2026-10-27 20:19:17', NULL),
(44, 'Sac à dos ordinateur 15,6\"', 'VET-0004', 6, NULL, 13200.00, 18500.00, 3, 6, NULL, 1, '2026-10-27 20:19:10', '2026-10-27 20:19:17', NULL),
(45, 'Ceinture en cuir homme', 'VET-0005', 6, NULL, 5400.00, 7500.00, 38, 10, NULL, 1, '2026-10-27 20:19:10', '2026-10-27 20:19:17', NULL),
(46, 'Robe wax élégante', 'VET-0006', 6, NULL, 15700.00, 22000.00, 4, 5, NULL, 1, '2026-10-27 20:19:11', '2026-10-27 20:19:17', NULL),
(47, 'Casquette brodée', 'VET-0007', 6, NULL, 3200.00, 4500.00, 0, 10, NULL, 1, '2026-10-27 20:19:11', '2026-10-27 20:19:17', NULL),
(48, 'Riz parfumé 5 kg', 'ALI-0001', 7, NULL, 3200.00, 4500.00, 127, 25, NULL, 1, '2026-10-27 20:19:11', '2026-10-27 20:19:17', NULL),
(49, 'Huile végétale 1 L', 'ALI-0002', 7, NULL, 1600.00, 2200.00, 163, 30, NULL, 1, '2026-10-27 20:19:11', '2026-10-27 20:19:17', NULL),
(50, 'Sucre en poudre 1 kg', 'ALI-0003', 7, NULL, 900.00, 1200.00, 137, 30, NULL, 1, '2026-10-27 20:19:11', '2026-10-27 20:19:17', NULL),
(51, 'Café moulu 250 g', 'ALI-0004', 7, NULL, 2500.00, 3500.00, 40, 12, NULL, 1, '2026-10-27 20:19:11', '2026-10-27 20:19:17', NULL),
(52, 'Lait en poudre 900 g', 'ALI-0005', 7, NULL, 3400.00, 4800.00, 75, 15, NULL, 1, '2026-10-27 20:19:11', '2026-10-27 20:19:17', NULL),
(53, 'Farine de blé 1 kg', 'ALI-0006', 7, NULL, 1100.00, 1500.00, 3, 20, NULL, 1, '2026-10-27 20:19:11', '2026-10-27 20:19:17', NULL),
(54, 'Concentré de tomate 400 g', 'ALI-0007', 7, NULL, 800.00, 1100.00, 103, 25, NULL, 1, '2026-10-27 20:19:11', '2026-10-27 20:19:17', NULL),
(55, 'Ballon de football taille 5', 'SPO-0001', 8, NULL, 6800.00, 9500.00, 47, 8, NULL, 1, '2026-10-27 20:19:11', '2026-10-27 22:12:38', NULL),
(56, 'Paire d\'haltères réglables 20 kg', 'SPO-0002', 8, NULL, 22900.00, 32000.00, 0, 3, NULL, 1, '2026-10-27 20:19:11', '2026-10-27 20:19:17', NULL),
(57, 'Tapis de yoga 6 mm', 'SPO-0003', 8, NULL, 8200.00, 11500.00, 61, 6, NULL, 1, '2026-10-27 20:19:11', '2026-10-27 20:19:17', NULL),
(58, 'Corde à sauter cardio', 'SPO-0004', 8, NULL, 2500.00, 3500.00, 0, 10, NULL, 1, '2026-10-27 20:19:12', '2026-10-27 20:19:17', NULL),
(59, 'Vélo de ville 26\"', 'SPO-0005', 8, NULL, 67900.00, 95000.00, 0, 2, NULL, 1, '2026-10-27 20:19:12', '2026-10-27 20:19:17', NULL),
(60, 'Jeu de société familial', 'SPO-0006', 8, NULL, 9600.00, 13500.00, 14, 5, NULL, 1, '2026-10-27 20:19:12', '2026-10-27 20:19:17', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `sales`
--

CREATE TABLE `sales` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `reference` varchar(255) NOT NULL,
  `customer_id` bigint(20) UNSIGNED DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `subtotal` decimal(14,2) NOT NULL,
  `discount` decimal(14,2) NOT NULL DEFAULT 0.00,
  `tax` decimal(14,2) NOT NULL DEFAULT 0.00,
  `total` decimal(14,2) NOT NULL,
  `payment_method` enum('especes','mobile_money','carte','virement') NOT NULL,
  `payment_status` enum('payee','en_attente') NOT NULL DEFAULT 'payee',
  `status` enum('validee','annulee') NOT NULL DEFAULT 'validee',
  `sold_at` datetime NOT NULL,
  `cancelled_at` datetime DEFAULT NULL,
  `cancel_reason` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `sales`
--

INSERT INTO `sales` (`id`, `reference`, `customer_id`, `user_id`, `subtotal`, `discount`, `tax`, `total`, `payment_method`, `payment_status`, `status`, `sold_at`, `cancelled_at`, `cancel_reason`, `created_at`, `updated_at`) VALUES
(1, 'VTE-2026-000001', 12, 3, 7600.00, 0.00, 1368.00, 8968.00, 'especes', 'payee', 'validee', '2026-04-28 22:06:51', NULL, NULL, '2026-04-28 21:06:51', '2026-04-28 21:06:51'),
(2, 'VTE-2026-000002', 38, 2, 87000.00, 4350.00, 14877.00, 97527.00, 'mobile_money', 'payee', 'validee', '2026-04-29 13:32:12', NULL, NULL, '2026-04-29 12:32:12', '2026-04-29 12:32:12'),
(3, 'VTE-2026-000003', 23, 3, 14000.00, 700.00, 2394.00, 15694.00, 'carte', 'payee', 'validee', '2026-05-01 19:56:02', NULL, NULL, '2026-05-01 18:56:02', '2026-05-01 18:56:02'),
(4, 'VTE-2026-000004', 1, 3, 74600.00, 0.00, 13428.00, 88028.00, 'carte', 'payee', 'validee', '2026-05-03 06:27:34', NULL, NULL, '2026-05-03 05:27:34', '2026-05-03 05:27:34'),
(5, 'VTE-2026-000005', NULL, 2, 56100.00, 0.00, 10098.00, 66198.00, 'especes', 'payee', 'validee', '2026-05-05 10:30:22', NULL, NULL, '2026-05-05 09:30:22', '2026-05-05 09:30:22'),
(6, 'VTE-2026-000006', 18, 2, 18500.00, 0.00, 3330.00, 21830.00, 'virement', 'en_attente', 'validee', '2026-05-05 12:55:38', NULL, NULL, '2026-05-05 11:55:38', '2026-05-05 11:55:38'),
(7, 'VTE-2026-000007', 11, 2, 162500.00, 0.00, 29250.00, 191750.00, 'carte', 'payee', 'annulee', '2026-05-08 00:31:03', '2026-05-10 00:31:03', 'Annulation demandée par le client', '2026-05-07 23:31:03', '2026-05-07 23:31:03'),
(8, 'VTE-2026-000008', NULL, 2, 73000.00, 0.00, 13140.00, 86140.00, 'carte', 'payee', 'validee', '2026-05-09 07:18:57', NULL, NULL, '2026-05-09 06:18:57', '2026-05-09 06:18:57'),
(9, 'VTE-2026-000009', 26, 1, 132900.00, 0.00, 23922.00, 156822.00, 'mobile_money', 'payee', 'validee', '2026-05-09 15:05:08', NULL, NULL, '2026-05-09 14:05:08', '2026-05-09 14:05:08'),
(10, 'VTE-2026-000010', 22, 3, 5800.00, 0.00, 1044.00, 6844.00, 'especes', 'payee', 'annulee', '2026-05-09 21:11:04', '2026-05-10 22:11:04', 'Annulation demandée par le client', '2026-05-09 20:11:04', '2026-05-09 20:11:04'),
(11, 'VTE-2026-000011', NULL, 3, 70900.00, 0.00, 12762.00, 83662.00, 'virement', 'en_attente', 'annulee', '2026-05-10 05:10:09', '2026-05-10 10:10:09', 'Annulation demandée par le client', '2026-05-10 04:10:09', '2026-05-10 04:10:09'),
(12, 'VTE-2026-000012', 20, 1, 235800.00, 0.00, 42444.00, 278244.00, 'especes', 'payee', 'validee', '2026-05-12 19:56:04', NULL, NULL, '2026-05-12 18:56:04', '2026-05-12 18:56:04'),
(13, 'VTE-2026-000013', 35, 3, 81300.00, 0.00, 14634.00, 95934.00, 'virement', 'en_attente', 'annulee', '2026-05-12 23:32:47', '2026-05-14 20:32:47', 'Annulation demandée par le client', '2026-05-12 22:32:47', '2026-05-12 22:32:47'),
(14, 'VTE-2026-000014', 4, 1, 172500.00, 0.00, 31050.00, 203550.00, 'carte', 'payee', 'validee', '2026-05-13 01:42:36', NULL, NULL, '2026-05-13 00:42:36', '2026-05-13 00:42:36'),
(15, 'VTE-2026-000015', 33, 2, 253400.00, 0.00, 45612.00, 299012.00, 'especes', 'payee', 'validee', '2026-05-15 06:47:56', NULL, NULL, '2026-05-15 05:47:56', '2026-05-15 05:47:56'),
(16, 'VTE-2026-000016', 19, 1, 56500.00, 0.00, 10170.00, 66670.00, 'carte', 'payee', 'validee', '2026-05-16 04:31:36', NULL, NULL, '2026-05-16 03:31:36', '2026-05-16 03:31:36'),
(17, 'VTE-2026-000017', 22, 3, 294000.00, 0.00, 52920.00, 346920.00, 'especes', 'payee', 'validee', '2026-05-18 23:25:39', NULL, NULL, '2026-05-18 22:25:39', '2026-05-18 22:25:39'),
(18, 'VTE-2026-000018', 24, 1, 58500.00, 0.00, 10530.00, 69030.00, 'virement', 'en_attente', 'validee', '2026-05-19 20:25:09', NULL, NULL, '2026-05-19 19:25:09', '2026-05-19 19:25:09'),
(19, 'VTE-2026-000019', NULL, 2, 96000.00, 0.00, 17280.00, 113280.00, 'carte', 'payee', 'validee', '2026-05-21 17:39:41', NULL, NULL, '2026-05-21 16:39:41', '2026-05-21 16:39:41'),
(20, 'VTE-2026-000020', 28, 3, 97700.00, 0.00, 17586.00, 115286.00, 'virement', 'payee', 'validee', '2026-05-22 05:40:17', NULL, NULL, '2026-05-22 04:40:17', '2026-05-22 04:40:17'),
(21, 'VTE-2026-000021', 19, 2, 24000.00, 0.00, 4320.00, 28320.00, 'especes', 'payee', 'validee', '2026-05-23 02:41:39', NULL, NULL, '2026-05-23 01:41:39', '2026-05-23 01:41:39'),
(22, 'VTE-2026-000022', NULL, 1, 5400.00, 270.00, 923.40, 6053.40, 'mobile_money', 'payee', 'validee', '2026-05-29 11:49:44', NULL, NULL, '2026-05-29 10:49:44', '2026-05-29 10:49:44'),
(23, 'VTE-2026-000023', 32, 3, 15500.00, 0.00, 2790.00, 18290.00, 'virement', 'payee', 'validee', '2026-05-30 21:23:58', NULL, NULL, '2026-05-30 20:23:58', '2026-05-30 20:23:58'),
(24, 'VTE-2026-000024', 33, 3, 130800.00, 0.00, 23544.00, 154344.00, 'especes', 'payee', 'validee', '2026-06-01 09:32:42', NULL, NULL, '2026-06-01 08:32:42', '2026-06-01 08:32:42'),
(25, 'VTE-2026-000025', NULL, 1, 187500.00, 0.00, 33750.00, 221250.00, 'mobile_money', 'payee', 'validee', '2026-06-01 23:04:18', NULL, NULL, '2026-06-01 22:04:18', '2026-06-01 22:04:18'),
(26, 'VTE-2026-000026', 18, 2, 119400.00, 0.00, 21492.00, 140892.00, 'carte', 'payee', 'validee', '2026-06-03 04:25:40', NULL, NULL, '2026-06-03 03:25:40', '2026-06-03 03:25:40'),
(27, 'VTE-2026-000027', 20, 3, 73600.00, 0.00, 13248.00, 86848.00, 'mobile_money', 'payee', 'validee', '2026-06-03 15:38:12', NULL, NULL, '2026-06-03 14:38:12', '2026-06-03 14:38:12'),
(28, 'VTE-2026-000028', NULL, 3, 169500.00, 0.00, 30510.00, 200010.00, 'mobile_money', 'payee', 'validee', '2026-06-03 17:30:24', NULL, NULL, '2026-06-03 16:30:24', '2026-06-03 16:30:24'),
(29, 'VTE-2026-000029', NULL, 3, 16200.00, 0.00, 2916.00, 19116.00, 'carte', 'payee', 'validee', '2026-06-04 11:15:33', NULL, NULL, '2026-06-04 10:15:33', '2026-06-04 10:15:33'),
(30, 'VTE-2026-000030', 35, 3, 105000.00, 0.00, 18900.00, 123900.00, 'carte', 'payee', 'validee', '2026-06-05 12:27:39', NULL, NULL, '2026-06-05 11:27:39', '2026-06-05 11:27:39'),
(31, 'VTE-2026-000031', 24, 2, 218900.00, 0.00, 39402.00, 258302.00, 'carte', 'payee', 'validee', '2026-06-05 21:22:39', NULL, NULL, '2026-06-05 20:22:39', '2026-06-05 20:22:39'),
(32, 'VTE-2026-000032', NULL, 2, 30400.00, 0.00, 5472.00, 35872.00, 'especes', 'payee', 'validee', '2026-06-06 12:46:46', NULL, NULL, '2026-06-06 11:46:46', '2026-06-06 11:46:46'),
(33, 'VTE-2026-000033', 22, 2, 162000.00, 0.00, 29160.00, 191160.00, 'especes', 'payee', 'validee', '2026-06-07 04:25:27', NULL, NULL, '2026-06-07 03:25:27', '2026-06-07 03:25:27'),
(34, 'VTE-2026-000034', 18, 3, 101100.00, 0.00, 18198.00, 119298.00, 'virement', 'payee', 'validee', '2026-06-07 08:09:45', NULL, NULL, '2026-06-07 07:09:45', '2026-06-07 07:09:45'),
(35, 'VTE-2026-000035', 10, 1, 158000.00, 0.00, 28440.00, 186440.00, 'carte', 'payee', 'validee', '2026-06-07 17:23:14', NULL, NULL, '2026-06-07 16:23:14', '2026-06-07 16:23:14'),
(36, 'VTE-2026-000036', NULL, 3, 122200.00, 0.00, 21996.00, 144196.00, 'carte', 'payee', 'validee', '2026-06-08 02:37:15', NULL, NULL, '2026-06-08 01:37:15', '2026-06-08 01:37:15'),
(37, 'VTE-2026-000037', 13, 2, 85400.00, 0.00, 15372.00, 100772.00, 'especes', 'payee', 'validee', '2026-06-10 11:08:45', NULL, NULL, '2026-06-10 10:08:45', '2026-06-10 10:08:45'),
(38, 'VTE-2026-000038', 8, 3, 257000.00, 0.00, 46260.00, 303260.00, 'especes', 'payee', 'validee', '2026-06-12 01:03:28', NULL, NULL, '2026-06-12 00:03:28', '2026-06-12 00:03:28'),
(39, 'VTE-2026-000039', 32, 2, 2200.00, 0.00, 396.00, 2596.00, 'mobile_money', 'payee', 'validee', '2026-06-13 07:30:02', NULL, NULL, '2026-06-13 06:30:02', '2026-06-13 06:30:02'),
(40, 'VTE-2026-000040', 22, 1, 180500.00, 0.00, 32490.00, 212990.00, 'especes', 'payee', 'validee', '2026-06-13 10:10:48', NULL, NULL, '2026-06-13 09:10:48', '2026-06-13 09:10:48'),
(41, 'VTE-2026-000041', 35, 1, 140000.00, 0.00, 25200.00, 165200.00, 'carte', 'payee', 'validee', '2026-06-13 16:30:45', NULL, NULL, '2026-06-13 15:30:45', '2026-06-13 15:30:45'),
(42, 'VTE-2026-000042', 19, 1, 173700.00, 0.00, 31266.00, 204966.00, 'mobile_money', 'payee', 'validee', '2026-06-15 08:05:22', NULL, NULL, '2026-06-15 07:05:22', '2026-06-15 07:05:22'),
(43, 'VTE-2026-000043', 9, 1, 144300.00, 0.00, 25974.00, 170274.00, 'carte', 'payee', 'validee', '2026-06-15 23:04:41', NULL, NULL, '2026-06-15 22:04:41', '2026-06-15 22:04:41'),
(44, 'VTE-2026-000044', 31, 3, 43100.00, 2155.00, 7370.10, 48315.10, 'especes', 'payee', 'validee', '2026-06-16 23:43:32', NULL, NULL, '2026-06-16 22:43:32', '2026-06-16 22:43:32'),
(45, 'VTE-2026-000045', 26, 2, 90000.00, 0.00, 16200.00, 106200.00, 'virement', 'en_attente', 'validee', '2026-06-21 10:45:14', NULL, NULL, '2026-06-21 09:45:14', '2026-06-21 09:45:14'),
(46, 'VTE-2026-000046', NULL, 3, 75200.00, 0.00, 13536.00, 88736.00, 'especes', 'payee', 'validee', '2026-06-22 08:28:16', NULL, NULL, '2026-06-22 07:28:16', '2026-06-22 07:28:16'),
(47, 'VTE-2026-000047', NULL, 1, 321600.00, 0.00, 57888.00, 379488.00, 'carte', 'payee', 'validee', '2026-06-27 01:12:53', NULL, NULL, '2026-06-27 00:12:53', '2026-06-27 00:12:53'),
(48, 'VTE-2026-000048', 16, 1, 46000.00, 2300.00, 7866.00, 51566.00, 'mobile_money', 'payee', 'validee', '2026-07-02 21:42:43', NULL, NULL, '2026-07-02 20:42:43', '2026-07-02 20:42:43'),
(49, 'VTE-2026-000049', NULL, 1, 66200.00, 0.00, 11916.00, 78116.00, 'especes', 'payee', 'validee', '2026-07-03 03:42:13', NULL, NULL, '2026-07-03 02:42:13', '2026-07-03 02:42:13'),
(50, 'VTE-2026-000050', 39, 3, 31300.00, 1565.00, 5352.30, 35087.30, 'mobile_money', 'payee', 'validee', '2026-07-04 18:48:34', NULL, NULL, '2026-07-04 17:48:34', '2026-07-04 17:48:34'),
(51, 'VTE-2026-000051', 22, 2, 73700.00, 0.00, 13266.00, 86966.00, 'especes', 'payee', 'annulee', '2026-07-06 11:21:59', '2026-07-07 00:21:59', 'Annulation demandée par le client', '2026-07-06 10:21:59', '2026-07-06 10:21:59'),
(52, 'VTE-2026-000052', 4, 1, 365000.00, 0.00, 65700.00, 430700.00, 'virement', 'payee', 'validee', '2026-07-07 14:54:59', NULL, NULL, '2026-07-07 13:54:59', '2026-07-07 13:54:59'),
(53, 'VTE-2026-000053', 16, 3, 143500.00, 0.00, 25830.00, 169330.00, 'carte', 'payee', 'validee', '2026-07-10 14:43:44', NULL, NULL, '2026-07-10 13:43:44', '2026-07-10 13:43:44'),
(54, 'VTE-2026-000054', NULL, 3, 76700.00, 0.00, 13806.00, 90506.00, 'mobile_money', 'payee', 'validee', '2026-07-10 23:51:34', NULL, NULL, '2026-07-10 22:51:34', '2026-07-10 22:51:34'),
(55, 'VTE-2026-000055', NULL, 1, 4500.00, 0.00, 810.00, 5310.00, 'carte', 'payee', 'validee', '2026-07-13 18:43:32', NULL, NULL, '2026-07-13 17:43:32', '2026-07-13 17:43:32'),
(56, 'VTE-2026-000056', NULL, 1, 120500.00, 0.00, 21690.00, 142190.00, 'carte', 'payee', 'validee', '2026-07-16 02:10:52', NULL, NULL, '2026-07-16 01:10:52', '2026-07-16 01:10:52'),
(57, 'VTE-2026-000057', 15, 1, 28000.00, 0.00, 5040.00, 33040.00, 'carte', 'payee', 'validee', '2026-07-20 05:52:03', NULL, NULL, '2026-07-20 04:52:03', '2026-07-20 04:52:03'),
(58, 'VTE-2026-000058', NULL, 3, 68500.00, 0.00, 12330.00, 80830.00, 'virement', 'payee', 'validee', '2026-07-22 16:05:52', NULL, NULL, '2026-07-22 15:05:52', '2026-07-22 15:05:52'),
(59, 'VTE-2026-000059', 16, 3, 67000.00, 0.00, 12060.00, 79060.00, 'especes', 'payee', 'validee', '2026-07-23 08:05:07', NULL, NULL, '2026-07-23 07:05:07', '2026-07-23 07:05:07'),
(60, 'VTE-2026-000060', 4, 1, 50300.00, 0.00, 9054.00, 59354.00, 'carte', 'payee', 'validee', '2026-07-23 17:01:16', NULL, NULL, '2026-07-23 16:01:16', '2026-07-23 16:01:16'),
(61, 'VTE-2026-000061', NULL, 2, 4500.00, 0.00, 810.00, 5310.00, 'especes', 'payee', 'validee', '2026-07-23 22:46:28', NULL, NULL, '2026-07-23 21:46:28', '2026-07-23 21:46:28'),
(62, 'VTE-2026-000062', 2, 2, 15000.00, 0.00, 2700.00, 17700.00, 'virement', 'payee', 'validee', '2026-07-25 11:22:43', NULL, NULL, '2026-07-25 10:22:43', '2026-07-25 10:22:43'),
(63, 'VTE-2026-000063', 10, 3, 74000.00, 0.00, 13320.00, 87320.00, 'mobile_money', 'payee', 'validee', '2026-07-27 06:59:20', NULL, NULL, '2026-07-27 05:59:20', '2026-07-27 05:59:20'),
(64, 'VTE-2026-000064', 3, 2, 48000.00, 0.00, 8640.00, 56640.00, 'carte', 'payee', 'validee', '2026-07-27 13:06:53', NULL, NULL, '2026-07-27 12:06:53', '2026-07-27 12:06:53'),
(65, 'VTE-2026-000065', 38, 1, 246500.00, 0.00, 44370.00, 290870.00, 'mobile_money', 'payee', 'validee', '2026-07-27 23:49:19', NULL, NULL, '2026-07-27 22:49:19', '2026-07-27 22:49:19'),
(66, 'VTE-2026-000066', 15, 3, 63000.00, 0.00, 11340.00, 74340.00, 'virement', 'payee', 'validee', '2026-07-28 09:06:02', NULL, NULL, '2026-07-28 08:06:02', '2026-07-28 08:06:02'),
(67, 'VTE-2026-000067', NULL, 3, 160000.00, 0.00, 28800.00, 188800.00, 'mobile_money', 'payee', 'validee', '2026-08-02 06:22:51', NULL, NULL, '2026-08-02 05:22:51', '2026-08-02 05:22:51'),
(68, 'VTE-2026-000068', 7, 1, 78000.00, 0.00, 14040.00, 92040.00, 'especes', 'payee', 'validee', '2026-08-05 10:08:01', NULL, NULL, '2026-08-05 09:08:01', '2026-08-05 09:08:01'),
(69, 'VTE-2026-000069', 19, 1, 333500.00, 0.00, 60030.00, 393530.00, 'carte', 'payee', 'validee', '2026-08-05 19:27:21', NULL, NULL, '2026-08-05 18:27:21', '2026-08-05 18:27:21'),
(70, 'VTE-2026-000070', 38, 2, 37500.00, 0.00, 6750.00, 44250.00, 'especes', 'payee', 'validee', '2026-08-11 02:22:08', NULL, NULL, '2026-08-11 01:22:08', '2026-08-11 01:22:08'),
(71, 'VTE-2026-000071', 7, 1, 66000.00, 0.00, 11880.00, 77880.00, 'mobile_money', 'payee', 'validee', '2026-08-12 02:29:26', NULL, NULL, '2026-08-12 01:29:26', '2026-08-12 01:29:26'),
(72, 'VTE-2026-000072', 9, 1, 10300.00, 0.00, 1854.00, 12154.00, 'virement', 'payee', 'validee', '2026-08-13 21:31:40', NULL, NULL, '2026-08-13 20:31:40', '2026-08-13 20:31:40'),
(73, 'VTE-2026-000073', NULL, 1, 48200.00, 2410.00, 8242.20, 54032.20, 'virement', 'en_attente', 'validee', '2026-08-16 00:20:49', NULL, NULL, '2026-08-15 23:20:49', '2026-08-15 23:20:49'),
(74, 'VTE-2026-000074', 34, 1, 40500.00, 0.00, 7290.00, 47790.00, 'mobile_money', 'payee', 'validee', '2026-08-20 21:56:22', NULL, NULL, '2026-08-20 20:56:22', '2026-08-20 20:56:22'),
(75, 'VTE-2026-000075', NULL, 2, 12500.00, 0.00, 2250.00, 14750.00, 'mobile_money', 'payee', 'validee', '2026-08-21 07:08:40', NULL, NULL, '2026-08-21 06:08:40', '2026-08-21 06:08:40'),
(76, 'VTE-2026-000076', 21, 3, 2500.00, 0.00, 450.00, 2950.00, 'mobile_money', 'payee', 'validee', '2026-08-21 08:10:22', NULL, NULL, '2026-08-21 07:10:22', '2026-08-21 07:10:22'),
(77, 'VTE-2026-000077', 38, 1, 12800.00, 0.00, 2304.00, 15104.00, 'carte', 'payee', 'annulee', '2026-08-22 16:18:37', '2026-08-23 19:18:37', 'Annulation demandée par le client', '2026-08-22 15:18:37', '2026-08-22 15:18:37'),
(78, 'VTE-2026-000078', 20, 1, 106400.00, 0.00, 19152.00, 125552.00, 'mobile_money', 'payee', 'validee', '2026-08-24 11:52:06', NULL, NULL, '2026-08-24 10:52:06', '2026-08-24 10:52:06'),
(79, 'VTE-2026-000079', NULL, 1, 13500.00, 675.00, 2308.50, 15133.50, 'mobile_money', 'payee', 'validee', '2026-08-25 14:38:56', NULL, NULL, '2026-08-25 13:38:56', '2026-08-25 13:38:56'),
(80, 'VTE-2026-000080', 37, 1, 171000.00, 8550.00, 29241.00, 191691.00, 'virement', 'en_attente', 'validee', '2026-08-26 17:13:21', NULL, NULL, '2026-08-26 16:13:21', '2026-08-26 16:13:21'),
(81, 'VTE-2026-000081', NULL, 2, 131000.00, 0.00, 23580.00, 154580.00, 'carte', 'payee', 'validee', '2026-08-29 02:05:14', NULL, NULL, '2026-08-29 01:05:14', '2026-08-29 01:05:14'),
(82, 'VTE-2026-000082', 32, 3, 131900.00, 0.00, 23742.00, 155642.00, 'carte', 'payee', 'validee', '2026-08-31 10:45:37', NULL, NULL, '2026-08-31 09:45:37', '2026-08-31 09:45:37'),
(83, 'VTE-2026-000083', 11, 1, 37000.00, 0.00, 6660.00, 43660.00, 'especes', 'payee', 'annulee', '2026-09-01 10:36:17', '2026-09-02 20:36:17', 'Annulation demandée par le client', '2026-09-01 09:36:17', '2026-09-01 09:36:17'),
(84, 'VTE-2026-000084', 7, 3, 163900.00, 0.00, 29502.00, 193402.00, 'virement', 'en_attente', 'validee', '2026-09-07 15:01:43', NULL, NULL, '2026-09-07 14:01:43', '2026-09-07 14:01:43'),
(85, 'VTE-2026-000085', NULL, 2, 136000.00, 0.00, 24480.00, 160480.00, 'carte', 'payee', 'validee', '2026-09-08 12:39:27', NULL, NULL, '2026-09-08 11:39:27', '2026-09-08 11:39:27'),
(86, 'VTE-2026-000086', 8, 1, 51100.00, 2555.00, 8738.10, 57283.10, 'virement', 'payee', 'validee', '2026-09-11 02:20:14', NULL, NULL, '2026-09-11 01:20:14', '2026-09-11 01:20:14'),
(87, 'VTE-2026-000087', NULL, 1, 124000.00, 0.00, 22320.00, 146320.00, 'especes', 'payee', 'validee', '2026-09-13 01:08:47', NULL, NULL, '2026-09-13 00:08:47', '2026-09-13 00:08:47'),
(88, 'VTE-2026-000088', 23, 1, 75000.00, 0.00, 13500.00, 88500.00, 'mobile_money', 'payee', 'annulee', '2026-09-13 10:34:58', '2026-09-14 17:34:58', 'Annulation demandée par le client', '2026-09-13 09:34:58', '2026-09-13 09:34:58'),
(89, 'VTE-2026-000089', 12, 2, 10500.00, 0.00, 1890.00, 12390.00, 'especes', 'payee', 'validee', '2026-09-16 03:21:31', NULL, NULL, '2026-09-16 02:21:31', '2026-09-16 02:21:31'),
(90, 'VTE-2026-000090', NULL, 1, 76300.00, 0.00, 13734.00, 90034.00, 'mobile_money', 'payee', 'validee', '2026-09-17 19:22:10', NULL, NULL, '2026-09-17 18:22:10', '2026-09-17 18:22:10'),
(91, 'VTE-2026-000091', 9, 1, 55100.00, 0.00, 9918.00, 65018.00, 'carte', 'payee', 'validee', '2026-09-20 14:14:07', NULL, NULL, '2026-09-20 13:14:07', '2026-09-20 13:14:07'),
(92, 'VTE-2026-000092', 32, 2, 50500.00, 0.00, 9090.00, 59590.00, 'mobile_money', 'payee', 'validee', '2026-09-21 12:10:57', NULL, NULL, '2026-09-21 11:10:57', '2026-09-21 11:10:57'),
(93, 'VTE-2026-000093', 6, 3, 101400.00, 0.00, 18252.00, 119652.00, 'carte', 'payee', 'validee', '2026-09-24 14:10:56', NULL, NULL, '2026-09-24 13:10:56', '2026-09-24 13:10:56'),
(94, 'VTE-2026-000094', 7, 3, 13800.00, 0.00, 2484.00, 16284.00, 'carte', 'payee', 'validee', '2026-09-26 07:53:45', NULL, NULL, '2026-09-26 06:53:45', '2026-09-26 06:53:45'),
(95, 'VTE-2026-000095', 24, 1, 2500.00, 0.00, 450.00, 2950.00, 'especes', 'payee', 'validee', '2026-09-27 01:57:32', NULL, NULL, '2026-09-27 00:57:32', '2026-09-27 00:57:32'),
(96, 'VTE-2026-000096', 25, 1, 91400.00, 0.00, 16452.00, 107852.00, 'carte', 'payee', 'validee', '2026-09-27 06:26:42', NULL, NULL, '2026-09-27 05:26:42', '2026-09-27 05:26:42'),
(97, 'VTE-2026-000097', NULL, 2, 41600.00, 0.00, 7488.00, 49088.00, 'carte', 'payee', 'validee', '2026-09-27 22:47:49', NULL, NULL, '2026-09-27 21:47:49', '2026-09-27 21:47:49'),
(98, 'VTE-2026-000098', 36, 3, 156000.00, 0.00, 28080.00, 184080.00, 'virement', 'en_attente', 'validee', '2026-10-01 18:35:34', NULL, NULL, '2026-10-01 17:35:34', '2026-10-01 17:35:34'),
(99, 'VTE-2026-000099', 9, 2, 58500.00, 0.00, 10530.00, 69030.00, 'mobile_money', 'payee', 'validee', '2026-10-02 04:21:30', NULL, NULL, '2026-10-02 03:21:30', '2026-10-02 03:21:30'),
(100, 'VTE-2026-000100', NULL, 3, 56800.00, 0.00, 10224.00, 67024.00, 'mobile_money', 'payee', 'validee', '2026-10-03 10:17:18', NULL, NULL, '2026-10-03 09:17:18', '2026-10-03 09:17:18'),
(101, 'VTE-2026-000101', 12, 2, 28000.00, 0.00, 5040.00, 33040.00, 'virement', 'en_attente', 'validee', '2026-10-03 13:43:40', NULL, NULL, '2026-10-03 12:43:40', '2026-10-03 12:43:40'),
(102, 'VTE-2026-000102', 24, 1, 173100.00, 0.00, 31158.00, 204258.00, 'especes', 'payee', 'validee', '2026-10-05 01:37:47', NULL, NULL, '2026-10-05 00:37:47', '2026-10-05 00:37:47'),
(103, 'VTE-2026-000103', NULL, 2, 188900.00, 0.00, 34002.00, 222902.00, 'especes', 'payee', 'validee', '2026-10-05 19:17:45', NULL, NULL, '2026-10-05 18:17:45', '2026-10-05 18:17:45'),
(104, 'VTE-2026-000104', NULL, 1, 96000.00, 0.00, 17280.00, 113280.00, 'virement', 'payee', 'validee', '2026-10-06 05:30:12', NULL, NULL, '2026-10-06 04:30:12', '2026-10-06 04:30:12'),
(105, 'VTE-2026-000105', NULL, 1, 109700.00, 0.00, 19746.00, 129446.00, 'carte', 'payee', 'annulee', '2026-10-06 17:38:49', '2026-10-07 21:38:49', 'Annulation demandée par le client', '2026-10-06 16:38:49', '2026-10-06 16:38:49'),
(106, 'VTE-2026-000106', NULL, 2, 184000.00, 0.00, 33120.00, 217120.00, 'virement', 'en_attente', 'validee', '2026-10-06 21:58:01', NULL, NULL, '2026-10-06 20:58:01', '2026-10-06 20:58:01'),
(107, 'VTE-2026-000107', 22, 1, 116400.00, 0.00, 20952.00, 137352.00, 'virement', 'payee', 'validee', '2026-10-07 23:30:35', NULL, NULL, '2026-10-07 22:30:35', '2026-10-07 22:30:35'),
(108, 'VTE-2026-000108', NULL, 3, 57300.00, 0.00, 10314.00, 67614.00, 'virement', 'en_attente', 'validee', '2026-10-08 14:17:01', NULL, NULL, '2026-10-08 13:17:01', '2026-10-08 13:17:01'),
(109, 'VTE-2026-000109', 3, 2, 84900.00, 4245.00, 14517.90, 95172.90, 'especes', 'payee', 'validee', '2026-10-08 16:58:03', NULL, NULL, '2026-10-08 15:58:03', '2026-10-08 15:58:03'),
(110, 'VTE-2026-000110', 22, 1, 16000.00, 0.00, 2880.00, 18880.00, 'virement', 'en_attente', 'validee', '2026-10-08 23:45:11', NULL, NULL, '2026-10-08 22:45:11', '2026-10-08 22:45:11'),
(111, 'VTE-2026-000111', 4, 1, 7100.00, 0.00, 1278.00, 8378.00, 'especes', 'payee', 'validee', '2026-10-09 06:22:49', NULL, NULL, '2026-10-09 05:22:49', '2026-10-09 05:22:49'),
(112, 'VTE-2026-000112', NULL, 1, 60000.00, 0.00, 10800.00, 70800.00, 'mobile_money', 'payee', 'validee', '2026-10-09 06:43:25', NULL, NULL, '2026-10-09 05:43:25', '2026-10-09 05:43:25'),
(113, 'VTE-2026-000113', 38, 1, 1500.00, 75.00, 256.50, 1681.50, 'virement', 'payee', 'validee', '2026-10-09 17:24:29', NULL, NULL, '2026-10-09 16:24:29', '2026-10-09 16:24:29'),
(114, 'VTE-2026-000114', 34, 1, 452300.00, 0.00, 81414.00, 533714.00, 'carte', 'payee', 'validee', '2026-10-09 17:42:39', NULL, NULL, '2026-10-09 16:42:39', '2026-10-09 16:42:39'),
(115, 'VTE-2026-000115', 38, 2, 3600.00, 0.00, 648.00, 4248.00, 'mobile_money', 'payee', 'validee', '2026-10-09 23:55:15', NULL, NULL, '2026-10-09 22:55:15', '2026-10-09 22:55:15'),
(116, 'VTE-2026-000116', 32, 2, 39300.00, 0.00, 7074.00, 46374.00, 'mobile_money', 'payee', 'validee', '2026-10-10 09:21:08', NULL, NULL, '2026-10-10 08:21:08', '2026-10-10 08:21:08'),
(117, 'VTE-2026-000117', 1, 1, 25000.00, 0.00, 4500.00, 29500.00, 'especes', 'payee', 'annulee', '2026-10-10 17:28:52', '2026-10-10 21:28:52', 'Annulation demandée par le client', '2026-10-10 16:28:52', '2026-10-10 16:28:52'),
(118, 'VTE-2026-000118', 19, 2, 58500.00, 0.00, 10530.00, 69030.00, 'mobile_money', 'payee', 'validee', '2026-10-11 07:18:54', NULL, NULL, '2026-10-11 06:18:54', '2026-10-11 06:18:54'),
(119, 'VTE-2026-000119', 38, 1, 130200.00, 0.00, 23436.00, 153636.00, 'mobile_money', 'payee', 'validee', '2026-10-11 16:10:59', NULL, NULL, '2026-10-11 15:10:59', '2026-10-11 15:10:59'),
(120, 'VTE-2026-000120', 33, 3, 147900.00, 0.00, 26622.00, 174522.00, 'virement', 'payee', 'annulee', '2026-10-11 19:11:21', '2026-10-13 10:11:21', 'Annulation demandée par le client', '2026-10-11 18:11:21', '2026-10-11 18:11:21'),
(121, 'VTE-2026-000121', 25, 2, 5500.00, 0.00, 990.00, 6490.00, 'mobile_money', 'payee', 'validee', '2026-10-11 21:13:50', NULL, NULL, '2026-10-11 20:13:50', '2026-10-11 20:13:50'),
(122, 'VTE-2026-000122', NULL, 3, 109200.00, 0.00, 19656.00, 128856.00, 'virement', 'payee', 'validee', '2026-10-12 05:12:15', NULL, NULL, '2026-10-12 04:12:15', '2026-10-12 04:12:15'),
(123, 'VTE-2026-000123', NULL, 3, 36100.00, 0.00, 6498.00, 42598.00, 'carte', 'payee', 'validee', '2026-10-12 12:29:03', NULL, NULL, '2026-10-12 11:29:03', '2026-10-12 11:29:03'),
(124, 'VTE-2026-000124', 22, 3, 98900.00, 0.00, 17802.00, 116702.00, 'mobile_money', 'payee', 'validee', '2026-10-12 13:28:52', NULL, NULL, '2026-10-12 12:28:52', '2026-10-12 12:28:52'),
(125, 'VTE-2026-000125', 11, 1, 126000.00, 6300.00, 21546.00, 141246.00, 'especes', 'payee', 'validee', '2026-10-13 02:49:21', NULL, NULL, '2026-10-13 01:49:21', '2026-10-13 01:49:21'),
(126, 'VTE-2026-000126', 30, 3, 89100.00, 0.00, 16038.00, 105138.00, 'mobile_money', 'payee', 'validee', '2026-10-13 08:56:27', NULL, NULL, '2026-10-13 07:56:27', '2026-10-13 07:56:27'),
(127, 'VTE-2026-000127', 22, 1, 5500.00, 275.00, 940.50, 6165.50, 'carte', 'payee', 'validee', '2026-10-14 00:46:25', NULL, NULL, '2026-10-13 23:46:25', '2026-10-13 23:46:25'),
(128, 'VTE-2026-000128', NULL, 3, 169200.00, 0.00, 30456.00, 199656.00, 'carte', 'payee', 'validee', '2026-10-14 04:30:02', NULL, NULL, '2026-10-14 03:30:02', '2026-10-14 03:30:02'),
(129, 'VTE-2026-000129', 29, 3, 50700.00, 0.00, 9126.00, 59826.00, 'carte', 'payee', 'annulee', '2026-10-14 15:14:23', '2026-10-15 14:14:23', 'Annulation demandée par le client', '2026-10-14 14:14:23', '2026-10-14 14:14:23'),
(130, 'VTE-2026-000130', 28, 3, 47100.00, 0.00, 8478.00, 55578.00, 'especes', 'payee', 'validee', '2026-10-14 20:34:16', NULL, NULL, '2026-10-14 19:34:16', '2026-10-14 19:34:16'),
(131, 'VTE-2026-000131', 17, 3, 21500.00, 0.00, 3870.00, 25370.00, 'virement', 'payee', 'validee', '2026-10-14 22:56:46', NULL, NULL, '2026-10-14 21:56:46', '2026-10-14 21:56:46'),
(132, 'VTE-2026-000132', NULL, 1, 108200.00, 0.00, 19476.00, 127676.00, 'carte', 'payee', 'validee', '2026-10-15 01:35:20', NULL, NULL, '2026-10-15 00:35:20', '2026-10-15 00:35:20'),
(133, 'VTE-2026-000133', 28, 1, 42500.00, 0.00, 7650.00, 50150.00, 'virement', 'payee', 'validee', '2026-10-15 01:46:12', NULL, NULL, '2026-10-15 00:46:12', '2026-10-15 00:46:12'),
(134, 'VTE-2026-000134', 34, 2, 256100.00, 0.00, 46098.00, 302198.00, 'carte', 'payee', 'validee', '2026-10-15 13:43:51', NULL, NULL, '2026-10-15 12:43:51', '2026-10-15 12:43:51'),
(135, 'VTE-2026-000135', NULL, 3, 3300.00, 0.00, 594.00, 3894.00, 'virement', 'payee', 'validee', '2026-10-16 01:26:16', NULL, NULL, '2026-10-16 00:26:16', '2026-10-16 00:26:16'),
(136, 'VTE-2026-000136', 19, 1, 25000.00, 0.00, 4500.00, 29500.00, 'mobile_money', 'payee', 'validee', '2026-10-17 18:20:24', NULL, NULL, '2026-10-17 17:20:24', '2026-10-17 17:20:24'),
(137, 'VTE-2026-000137', NULL, 2, 32000.00, 0.00, 5760.00, 37760.00, 'carte', 'payee', 'validee', '2026-10-18 00:59:31', NULL, NULL, '2026-10-17 23:59:31', '2026-10-17 23:59:31'),
(138, 'VTE-2026-000138', 37, 1, 35000.00, 0.00, 6300.00, 41300.00, 'especes', 'payee', 'validee', '2026-10-18 05:48:27', NULL, NULL, '2026-10-18 04:48:27', '2026-10-18 04:48:27'),
(139, 'VTE-2026-000139', 37, 3, 187200.00, 0.00, 33696.00, 220896.00, 'especes', 'payee', 'validee', '2026-10-18 10:21:01', NULL, NULL, '2026-10-18 09:21:01', '2026-10-18 09:21:01'),
(140, 'VTE-2026-000140', 33, 1, 163600.00, 0.00, 29448.00, 193048.00, 'virement', 'en_attente', 'validee', '2026-10-20 21:41:40', NULL, NULL, '2026-10-20 20:41:40', '2026-10-20 20:41:40'),
(141, 'VTE-2026-000141', 30, 1, 43500.00, 0.00, 7830.00, 51330.00, 'virement', 'payee', 'validee', '2026-10-21 03:59:02', NULL, NULL, '2026-10-21 02:59:02', '2026-10-21 02:59:02'),
(142, 'VTE-2026-000142', NULL, 2, 102500.00, 0.00, 18450.00, 120950.00, 'virement', 'payee', 'validee', '2026-10-22 08:39:09', NULL, NULL, '2026-10-22 07:39:09', '2026-10-22 07:39:09'),
(143, 'VTE-2026-000143', 24, 1, 186000.00, 0.00, 33480.00, 219480.00, 'carte', 'payee', 'validee', '2026-10-23 08:41:06', NULL, NULL, '2026-10-23 07:41:06', '2026-10-23 07:41:06'),
(144, 'VTE-2026-000144', 1, 1, 40900.00, 0.00, 7362.00, 48262.00, 'carte', 'payee', 'validee', '2026-10-23 14:55:15', NULL, NULL, '2026-10-23 13:55:15', '2026-10-23 13:55:15'),
(145, 'VTE-2026-000145', 18, 3, 154000.00, 0.00, 27720.00, 181720.00, 'mobile_money', 'payee', 'validee', '2026-10-24 06:11:48', NULL, NULL, '2026-10-24 05:11:48', '2026-10-24 05:11:48'),
(146, 'VTE-2026-000146', 11, 3, 5000.00, 0.00, 900.00, 5900.00, 'especes', 'payee', 'validee', '2026-10-24 08:37:59', NULL, NULL, '2026-10-24 07:37:59', '2026-10-24 07:37:59'),
(147, 'VTE-2026-000147', 29, 1, 105100.00, 0.00, 18918.00, 124018.00, 'especes', 'payee', 'validee', '2026-10-25 19:04:37', NULL, NULL, '2026-10-25 18:04:37', '2026-10-25 18:04:37'),
(148, 'VTE-2026-000148', 20, 1, 85400.00, 0.00, 15372.00, 100772.00, 'mobile_money', 'payee', 'validee', '2026-10-27 03:30:43', NULL, NULL, '2026-10-27 02:30:43', '2026-10-27 02:30:43'),
(149, 'VTE-2026-000149', NULL, 3, 39600.00, 0.00, 7128.00, 46728.00, 'especes', 'payee', 'validee', '2026-10-27 06:04:59', NULL, NULL, '2026-10-27 05:04:59', '2026-10-27 05:04:59'),
(150, 'VTE-2026-000150', 39, 1, 6100.00, 0.00, 1098.00, 7198.00, 'especes', 'payee', 'validee', '2026-10-27 08:53:29', NULL, NULL, '2026-10-27 07:53:29', '2026-10-27 07:53:29'),
(153, 'VTE-2026-000151', NULL, 1, 42000.00, 0.00, 7560.00, 49560.00, 'especes', 'payee', 'validee', '2026-10-27 23:19:45', NULL, NULL, '2026-10-27 22:19:45', '2026-10-27 22:19:45');

-- --------------------------------------------------------

--
-- Structure de la table `sale_items`
--

CREATE TABLE `sale_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `sale_id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `quantity` int(10) UNSIGNED NOT NULL,
  `unit_price` decimal(12,2) NOT NULL,
  `line_total` decimal(14,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `sale_items`
--

INSERT INTO `sale_items` (`id`, `sale_id`, `product_id`, `quantity`, `unit_price`, `line_total`, `created_at`, `updated_at`) VALUES
(1, 1, 34, 2, 3800.00, 7600.00, '2026-04-28 21:06:51', '2026-04-28 21:06:51'),
(2, 2, 41, 1, 5500.00, 5500.00, '2026-04-29 12:32:12', '2026-04-29 12:32:12'),
(3, 2, 2, 1, 18500.00, 18500.00, '2026-04-29 12:32:12', '2026-04-29 12:32:12'),
(4, 2, 57, 3, 11500.00, 34500.00, '2026-04-29 12:32:12', '2026-04-29 12:32:12'),
(5, 2, 55, 3, 9500.00, 28500.00, '2026-04-29 12:32:12', '2026-04-29 12:32:12'),
(6, 3, 28, 1, 14000.00, 14000.00, '2026-05-01 18:56:02', '2026-05-01 18:56:02'),
(7, 4, 39, 1, 4200.00, 4200.00, '2026-05-03 05:27:34', '2026-05-03 05:27:34'),
(8, 4, 49, 2, 2200.00, 4400.00, '2026-05-03 05:27:34', '2026-05-03 05:27:34'),
(9, 4, 18, 1, 4500.00, 4500.00, '2026-05-03 05:27:34', '2026-05-03 05:27:34'),
(10, 4, 45, 2, 7500.00, 15000.00, '2026-05-03 05:27:34', '2026-05-03 05:27:34'),
(11, 4, 42, 3, 15500.00, 46500.00, '2026-05-03 05:27:34', '2026-05-03 05:27:34'),
(12, 5, 43, 1, 28000.00, 28000.00, '2026-05-05 09:30:22', '2026-05-05 09:30:22'),
(13, 5, 21, 1, 9500.00, 9500.00, '2026-05-05 09:30:22', '2026-05-05 09:30:22'),
(14, 5, 5, 1, 15000.00, 15000.00, '2026-05-05 09:30:22', '2026-05-05 09:30:22'),
(15, 5, 50, 3, 1200.00, 3600.00, '2026-05-05 09:30:22', '2026-05-05 09:30:22'),
(16, 6, 20, 1, 5000.00, 5000.00, '2026-05-05 11:55:38', '2026-05-05 11:55:38'),
(17, 6, 18, 3, 4500.00, 13500.00, '2026-05-05 11:55:38', '2026-05-05 11:55:38'),
(18, 7, 24, 2, 17500.00, 35000.00, '2026-05-07 23:31:03', '2026-05-07 23:31:03'),
(19, 7, 25, 3, 6000.00, 18000.00, '2026-05-07 23:31:03', '2026-05-07 23:31:03'),
(20, 7, 33, 1, 42000.00, 42000.00, '2026-05-07 23:31:03', '2026-05-07 23:31:03'),
(21, 7, 43, 2, 28000.00, 56000.00, '2026-05-07 23:31:03', '2026-05-07 23:31:03'),
(22, 7, 57, 1, 11500.00, 11500.00, '2026-05-07 23:31:03', '2026-05-07 23:31:03'),
(23, 8, 29, 3, 19500.00, 58500.00, '2026-05-09 06:18:57', '2026-05-09 06:18:57'),
(24, 8, 10, 1, 14500.00, 14500.00, '2026-05-09 06:18:57', '2026-05-09 06:18:57'),
(25, 9, 5, 1, 15000.00, 15000.00, '2026-05-09 14:05:08', '2026-05-09 14:05:08'),
(26, 9, 34, 3, 3800.00, 11400.00, '2026-05-09 14:05:08', '2026-05-09 14:05:08'),
(27, 9, 40, 2, 24500.00, 49000.00, '2026-05-09 14:05:08', '2026-05-09 14:05:08'),
(28, 9, 10, 2, 14500.00, 29000.00, '2026-05-09 14:05:08', '2026-05-09 14:05:08'),
(29, 9, 55, 3, 9500.00, 28500.00, '2026-05-09 14:05:08', '2026-05-09 14:05:08'),
(30, 10, 49, 1, 2200.00, 2200.00, '2026-05-09 20:11:04', '2026-05-09 20:11:04'),
(31, 10, 36, 2, 1800.00, 3600.00, '2026-05-09 20:11:04', '2026-05-09 20:11:04'),
(32, 11, 51, 1, 3500.00, 3500.00, '2026-05-10 04:10:09', '2026-05-10 04:10:09'),
(33, 11, 43, 2, 28000.00, 56000.00, '2026-05-10 04:10:09', '2026-05-10 04:10:09'),
(34, 11, 34, 3, 3800.00, 11400.00, '2026-05-10 04:10:09', '2026-05-10 04:10:09'),
(35, 12, 20, 2, 5000.00, 10000.00, '2026-05-12 18:56:04', '2026-05-12 18:56:04'),
(36, 12, 1, 2, 25000.00, 50000.00, '2026-05-12 18:56:04', '2026-05-12 18:56:04'),
(37, 12, 37, 3, 58000.00, 174000.00, '2026-05-12 18:56:04', '2026-05-12 18:56:04'),
(38, 12, 36, 1, 1800.00, 1800.00, '2026-05-12 18:56:04', '2026-05-12 18:56:04'),
(39, 13, 44, 3, 18500.00, 55500.00, '2026-05-12 22:32:47', '2026-05-12 22:32:47'),
(40, 13, 53, 2, 1500.00, 3000.00, '2026-05-12 22:32:47', '2026-05-12 22:32:47'),
(41, 13, 34, 1, 3800.00, 3800.00, '2026-05-12 22:32:47', '2026-05-12 22:32:47'),
(42, 13, 21, 2, 9500.00, 19000.00, '2026-05-12 22:32:47', '2026-05-12 22:32:47'),
(43, 14, 27, 3, 12500.00, 37500.00, '2026-05-13 00:42:36', '2026-05-13 00:42:36'),
(44, 14, 15, 3, 45000.00, 135000.00, '2026-05-13 00:42:36', '2026-05-13 00:42:36'),
(45, 15, 25, 1, 6000.00, 6000.00, '2026-05-15 05:47:56', '2026-05-15 05:47:56'),
(46, 15, 58, 2, 3500.00, 7000.00, '2026-05-15 05:47:56', '2026-05-15 05:47:56'),
(47, 15, 38, 3, 35000.00, 105000.00, '2026-05-15 05:47:56', '2026-05-15 05:47:56'),
(48, 15, 36, 3, 1800.00, 5400.00, '2026-05-15 05:47:56', '2026-05-15 05:47:56'),
(49, 15, 31, 2, 65000.00, 130000.00, '2026-05-15 05:47:56', '2026-05-15 05:47:56'),
(50, 16, 8, 1, 8000.00, 8000.00, '2026-05-16 03:31:36', '2026-05-16 03:31:36'),
(51, 16, 29, 1, 19500.00, 19500.00, '2026-05-16 03:31:36', '2026-05-16 03:31:36'),
(52, 16, 10, 2, 14500.00, 29000.00, '2026-05-16 03:31:36', '2026-05-16 03:31:36'),
(53, 17, 59, 2, 95000.00, 190000.00, '2026-05-18 22:25:39', '2026-05-18 22:25:39'),
(54, 17, 12, 2, 52000.00, 104000.00, '2026-05-18 22:25:39', '2026-05-18 22:25:39'),
(55, 18, 42, 2, 15500.00, 31000.00, '2026-05-19 19:25:09', '2026-05-19 19:25:09'),
(56, 18, 35, 1, 2500.00, 2500.00, '2026-05-19 19:25:09', '2026-05-19 19:25:09'),
(57, 18, 27, 2, 12500.00, 25000.00, '2026-05-19 19:25:09', '2026-05-19 19:25:09'),
(58, 19, 16, 2, 48000.00, 96000.00, '2026-05-21 16:39:41', '2026-05-21 16:39:41'),
(59, 20, 9, 1, 32000.00, 32000.00, '2026-05-22 04:40:17', '2026-05-22 04:40:17'),
(60, 20, 21, 3, 9500.00, 28500.00, '2026-05-22 04:40:17', '2026-05-22 04:40:17'),
(61, 20, 39, 1, 4200.00, 4200.00, '2026-05-22 04:40:17', '2026-05-22 04:40:17'),
(62, 20, 14, 2, 16500.00, 33000.00, '2026-05-22 04:40:17', '2026-05-22 04:40:17'),
(63, 21, 8, 3, 8000.00, 24000.00, '2026-05-23 01:41:39', '2026-05-23 01:41:39'),
(64, 22, 36, 3, 1800.00, 5400.00, '2026-05-29 10:49:44', '2026-05-29 10:49:44'),
(65, 23, 42, 1, 15500.00, 15500.00, '2026-05-30 20:23:58', '2026-05-30 20:23:58'),
(66, 24, 34, 1, 3800.00, 3800.00, '2026-06-01 08:32:42', '2026-06-01 08:32:42'),
(67, 24, 9, 2, 32000.00, 64000.00, '2026-06-01 08:32:42', '2026-06-01 08:32:42'),
(68, 24, 18, 1, 4500.00, 4500.00, '2026-06-01 08:32:42', '2026-06-01 08:32:42'),
(69, 24, 29, 3, 19500.00, 58500.00, '2026-06-01 08:32:42', '2026-06-01 08:32:42'),
(70, 25, 34, 1, 3800.00, 3800.00, '2026-06-01 22:04:18', '2026-06-01 22:04:18'),
(71, 25, 12, 3, 52000.00, 156000.00, '2026-06-01 22:04:18', '2026-06-01 22:04:18'),
(72, 25, 8, 1, 8000.00, 8000.00, '2026-06-01 22:04:18', '2026-06-01 22:04:18'),
(73, 25, 24, 1, 17500.00, 17500.00, '2026-06-01 22:04:18', '2026-06-01 22:04:18'),
(74, 25, 49, 1, 2200.00, 2200.00, '2026-06-01 22:04:18', '2026-06-01 22:04:18'),
(75, 26, 40, 2, 24500.00, 49000.00, '2026-06-03 03:25:40', '2026-06-03 03:25:40'),
(76, 26, 43, 2, 28000.00, 56000.00, '2026-06-03 03:25:40', '2026-06-03 03:25:40'),
(77, 26, 52, 3, 4800.00, 14400.00, '2026-06-03 03:25:40', '2026-06-03 03:25:40'),
(78, 27, 46, 3, 22000.00, 66000.00, '2026-06-03 14:38:12', '2026-06-03 14:38:12'),
(79, 27, 34, 2, 3800.00, 7600.00, '2026-06-03 14:38:12', '2026-06-03 14:38:12'),
(80, 28, 15, 1, 45000.00, 45000.00, '2026-06-03 16:30:24', '2026-06-03 16:30:24'),
(81, 28, 51, 1, 3500.00, 3500.00, '2026-06-03 16:30:24', '2026-06-03 16:30:24'),
(82, 28, 10, 2, 14500.00, 29000.00, '2026-06-03 16:30:24', '2026-06-03 16:30:24'),
(83, 28, 33, 2, 42000.00, 84000.00, '2026-06-03 16:30:24', '2026-06-03 16:30:24'),
(84, 28, 8, 1, 8000.00, 8000.00, '2026-06-03 16:30:24', '2026-06-03 16:30:24'),
(85, 29, 19, 1, 2500.00, 2500.00, '2026-06-04 10:15:33', '2026-06-04 10:15:33'),
(86, 29, 39, 1, 4200.00, 4200.00, '2026-06-04 10:15:33', '2026-06-04 10:15:33'),
(87, 29, 51, 2, 3500.00, 7000.00, '2026-06-04 10:15:33', '2026-06-04 10:15:33'),
(88, 29, 35, 1, 2500.00, 2500.00, '2026-06-04 10:15:33', '2026-06-04 10:15:33'),
(89, 30, 15, 2, 45000.00, 90000.00, '2026-06-05 11:27:39', '2026-06-05 11:27:39'),
(90, 30, 20, 3, 5000.00, 15000.00, '2026-06-05 11:27:39', '2026-06-05 11:27:39'),
(91, 31, 42, 2, 15500.00, 31000.00, '2026-06-05 20:22:39', '2026-06-05 20:22:39'),
(92, 31, 16, 2, 48000.00, 96000.00, '2026-06-05 20:22:39', '2026-06-05 20:22:39'),
(93, 31, 43, 1, 28000.00, 28000.00, '2026-06-05 20:22:39', '2026-06-05 20:22:39'),
(94, 31, 29, 3, 19500.00, 58500.00, '2026-06-05 20:22:39', '2026-06-05 20:22:39'),
(95, 31, 36, 3, 1800.00, 5400.00, '2026-06-05 20:22:39', '2026-06-05 20:22:39'),
(96, 32, 39, 2, 4200.00, 8400.00, '2026-06-06 11:46:46', '2026-06-06 11:46:46'),
(97, 32, 46, 1, 22000.00, 22000.00, '2026-06-06 11:46:46', '2026-06-06 11:46:46'),
(98, 33, 51, 3, 3500.00, 10500.00, '2026-06-07 03:25:27', '2026-06-07 03:25:27'),
(99, 33, 7, 1, 12000.00, 12000.00, '2026-06-07 03:25:27', '2026-06-07 03:25:27'),
(100, 33, 2, 3, 18500.00, 55500.00, '2026-06-07 03:25:27', '2026-06-07 03:25:27'),
(101, 33, 43, 3, 28000.00, 84000.00, '2026-06-07 03:25:27', '2026-06-07 03:25:27'),
(102, 34, 50, 2, 1200.00, 2400.00, '2026-06-07 07:09:45', '2026-06-07 07:09:45'),
(103, 34, 22, 1, 12500.00, 12500.00, '2026-06-07 07:09:45', '2026-06-07 07:09:45'),
(104, 34, 33, 2, 42000.00, 84000.00, '2026-06-07 07:09:45', '2026-06-07 07:09:45'),
(105, 34, 49, 1, 2200.00, 2200.00, '2026-06-07 07:09:45', '2026-06-07 07:09:45'),
(106, 35, 40, 2, 24500.00, 49000.00, '2026-06-07 16:23:14', '2026-06-07 16:23:14'),
(107, 35, 19, 2, 2500.00, 5000.00, '2026-06-07 16:23:14', '2026-06-07 16:23:14'),
(108, 35, 9, 2, 32000.00, 64000.00, '2026-06-07 16:23:14', '2026-06-07 16:23:14'),
(109, 35, 57, 1, 11500.00, 11500.00, '2026-06-07 16:23:14', '2026-06-07 16:23:14'),
(110, 35, 55, 3, 9500.00, 28500.00, '2026-06-07 16:23:14', '2026-06-07 16:23:14'),
(111, 36, 12, 2, 52000.00, 104000.00, '2026-06-08 01:37:15', '2026-06-08 01:37:15'),
(112, 36, 34, 1, 3800.00, 3800.00, '2026-06-08 01:37:15', '2026-06-08 01:37:15'),
(113, 36, 52, 3, 4800.00, 14400.00, '2026-06-08 01:37:15', '2026-06-08 01:37:15'),
(114, 37, 3, 3, 6500.00, 19500.00, '2026-06-10 10:08:45', '2026-06-10 10:08:45'),
(115, 37, 34, 3, 3800.00, 11400.00, '2026-06-10 10:08:45', '2026-06-10 10:08:45'),
(116, 37, 22, 1, 12500.00, 12500.00, '2026-06-10 10:08:45', '2026-06-10 10:08:45'),
(117, 37, 33, 1, 42000.00, 42000.00, '2026-06-10 10:08:45', '2026-06-10 10:08:45'),
(118, 38, 33, 2, 42000.00, 84000.00, '2026-06-12 00:03:28', '2026-06-12 00:03:28'),
(119, 38, 12, 2, 52000.00, 104000.00, '2026-06-12 00:03:28', '2026-06-12 00:03:28'),
(120, 38, 5, 3, 15000.00, 45000.00, '2026-06-12 00:03:28', '2026-06-12 00:03:28'),
(121, 38, 7, 2, 12000.00, 24000.00, '2026-06-12 00:03:28', '2026-06-12 00:03:28'),
(122, 39, 54, 2, 1100.00, 2200.00, '2026-06-13 06:30:02', '2026-06-13 06:30:02'),
(123, 40, 15, 2, 45000.00, 90000.00, '2026-06-13 09:10:48', '2026-06-13 09:10:48'),
(124, 40, 25, 2, 6000.00, 12000.00, '2026-06-13 09:10:48', '2026-06-13 09:10:48'),
(125, 40, 5, 1, 15000.00, 15000.00, '2026-06-13 09:10:48', '2026-06-13 09:10:48'),
(126, 40, 13, 2, 28000.00, 56000.00, '2026-06-13 09:10:48', '2026-06-13 09:10:48'),
(127, 40, 45, 1, 7500.00, 7500.00, '2026-06-13 09:10:48', '2026-06-13 09:10:48'),
(128, 41, 20, 1, 5000.00, 5000.00, '2026-06-13 15:30:45', '2026-06-13 15:30:45'),
(129, 41, 1, 2, 25000.00, 50000.00, '2026-06-13 15:30:45', '2026-06-13 15:30:45'),
(130, 41, 14, 2, 16500.00, 33000.00, '2026-06-13 15:30:45', '2026-06-13 15:30:45'),
(131, 41, 12, 1, 52000.00, 52000.00, '2026-06-13 15:30:45', '2026-06-13 15:30:45'),
(132, 42, 18, 3, 4500.00, 13500.00, '2026-06-15 07:05:22', '2026-06-15 07:05:22'),
(133, 42, 50, 3, 1200.00, 3600.00, '2026-06-15 07:05:22', '2026-06-15 07:05:22'),
(134, 42, 49, 3, 2200.00, 6600.00, '2026-06-15 07:05:22', '2026-06-15 07:05:22'),
(135, 42, 26, 3, 22000.00, 66000.00, '2026-06-15 07:05:22', '2026-06-15 07:05:22'),
(136, 42, 33, 2, 42000.00, 84000.00, '2026-06-15 07:05:22', '2026-06-15 07:05:22'),
(137, 43, 36, 3, 1800.00, 5400.00, '2026-06-15 22:04:41', '2026-06-15 22:04:41'),
(138, 43, 55, 3, 9500.00, 28500.00, '2026-06-15 22:04:41', '2026-06-15 22:04:41'),
(139, 43, 5, 1, 15000.00, 15000.00, '2026-06-15 22:04:41', '2026-06-15 22:04:41'),
(140, 43, 43, 3, 28000.00, 84000.00, '2026-06-15 22:04:41', '2026-06-15 22:04:41'),
(141, 43, 34, 3, 3800.00, 11400.00, '2026-06-15 22:04:41', '2026-06-15 22:04:41'),
(142, 44, 4, 3, 3500.00, 10500.00, '2026-06-16 22:43:32', '2026-06-16 22:43:32'),
(143, 44, 22, 1, 12500.00, 12500.00, '2026-06-16 22:43:32', '2026-06-16 22:43:32'),
(144, 44, 50, 3, 1200.00, 3600.00, '2026-06-16 22:43:32', '2026-06-16 22:43:32'),
(145, 44, 41, 3, 5500.00, 16500.00, '2026-06-16 22:43:32', '2026-06-16 22:43:32'),
(146, 45, 15, 2, 45000.00, 90000.00, '2026-06-21 09:45:14', '2026-06-21 09:45:14'),
(147, 46, 1, 1, 25000.00, 25000.00, '2026-06-22 07:28:16', '2026-06-22 07:28:16'),
(148, 46, 42, 2, 15500.00, 31000.00, '2026-06-22 07:28:16', '2026-06-22 07:28:16'),
(149, 46, 48, 1, 4500.00, 4500.00, '2026-06-22 07:28:16', '2026-06-22 07:28:16'),
(150, 46, 22, 1, 12500.00, 12500.00, '2026-06-22 07:28:16', '2026-06-22 07:28:16'),
(151, 46, 49, 1, 2200.00, 2200.00, '2026-06-22 07:28:16', '2026-06-22 07:28:16'),
(152, 47, 23, 3, 4000.00, 12000.00, '2026-06-27 00:12:53', '2026-06-27 00:12:53'),
(153, 47, 45, 2, 7500.00, 15000.00, '2026-06-27 00:12:53', '2026-06-27 00:12:53'),
(154, 47, 11, 3, 85000.00, 255000.00, '2026-06-27 00:12:53', '2026-06-27 00:12:53'),
(155, 47, 34, 2, 3800.00, 7600.00, '2026-06-27 00:12:53', '2026-06-27 00:12:53'),
(156, 47, 9, 1, 32000.00, 32000.00, '2026-06-27 00:12:53', '2026-06-27 00:12:53'),
(157, 48, 35, 1, 2500.00, 2500.00, '2026-07-02 20:42:43', '2026-07-02 20:42:43'),
(158, 48, 48, 1, 4500.00, 4500.00, '2026-07-02 20:42:43', '2026-07-02 20:42:43'),
(159, 48, 29, 2, 19500.00, 39000.00, '2026-07-02 20:42:43', '2026-07-02 20:42:43'),
(160, 49, 49, 1, 2200.00, 2200.00, '2026-07-03 02:42:13', '2026-07-03 02:42:13'),
(161, 49, 9, 2, 32000.00, 64000.00, '2026-07-03 02:42:13', '2026-07-03 02:42:13'),
(162, 50, 60, 1, 13500.00, 13500.00, '2026-07-04 17:48:34', '2026-07-04 17:48:34'),
(163, 50, 48, 1, 4500.00, 4500.00, '2026-07-04 17:48:34', '2026-07-04 17:48:34'),
(164, 50, 54, 3, 1100.00, 3300.00, '2026-07-04 17:48:34', '2026-07-04 17:48:34'),
(165, 50, 3, 1, 6500.00, 6500.00, '2026-07-04 17:48:34', '2026-07-04 17:48:34'),
(166, 50, 51, 1, 3500.00, 3500.00, '2026-07-04 17:48:34', '2026-07-04 17:48:34'),
(167, 51, 20, 2, 5000.00, 10000.00, '2026-07-06 10:21:59', '2026-07-06 10:21:59'),
(168, 51, 10, 1, 14500.00, 14500.00, '2026-07-06 10:21:59', '2026-07-06 10:21:59'),
(169, 51, 39, 1, 4200.00, 4200.00, '2026-07-06 10:21:59', '2026-07-06 10:21:59'),
(170, 51, 46, 1, 22000.00, 22000.00, '2026-07-06 10:21:59', '2026-07-06 10:21:59'),
(171, 51, 57, 2, 11500.00, 23000.00, '2026-07-06 10:21:59', '2026-07-06 10:21:59'),
(172, 52, 31, 3, 65000.00, 195000.00, '2026-07-07 13:54:59', '2026-07-07 13:54:59'),
(173, 52, 56, 3, 32000.00, 96000.00, '2026-07-07 13:54:59', '2026-07-07 13:54:59'),
(174, 52, 5, 2, 15000.00, 30000.00, '2026-07-07 13:54:59', '2026-07-07 13:54:59'),
(175, 52, 46, 2, 22000.00, 44000.00, '2026-07-07 13:54:59', '2026-07-07 13:54:59'),
(176, 53, 45, 3, 7500.00, 22500.00, '2026-07-10 13:43:44', '2026-07-10 13:43:44'),
(177, 53, 51, 2, 3500.00, 7000.00, '2026-07-10 13:43:44', '2026-07-10 13:43:44'),
(178, 53, 30, 1, 16000.00, 16000.00, '2026-07-10 13:43:44', '2026-07-10 13:43:44'),
(179, 53, 57, 2, 11500.00, 23000.00, '2026-07-10 13:43:44', '2026-07-10 13:43:44'),
(180, 53, 1, 3, 25000.00, 75000.00, '2026-07-10 13:43:44', '2026-07-10 13:43:44'),
(181, 54, 24, 2, 17500.00, 35000.00, '2026-07-10 22:51:34', '2026-07-10 22:51:34'),
(182, 54, 48, 2, 4500.00, 9000.00, '2026-07-10 22:51:34', '2026-07-10 22:51:34'),
(183, 54, 55, 2, 9500.00, 19000.00, '2026-07-10 22:51:34', '2026-07-10 22:51:34'),
(184, 54, 39, 3, 4200.00, 12600.00, '2026-07-10 22:51:34', '2026-07-10 22:51:34'),
(185, 54, 54, 1, 1100.00, 1100.00, '2026-07-10 22:51:34', '2026-07-10 22:51:34'),
(186, 55, 18, 1, 4500.00, 4500.00, '2026-07-13 17:43:32', '2026-07-13 17:43:32'),
(187, 56, 15, 2, 45000.00, 90000.00, '2026-07-16 01:10:52', '2026-07-16 01:10:52'),
(188, 56, 22, 1, 12500.00, 12500.00, '2026-07-16 01:10:52', '2026-07-16 01:10:52'),
(189, 56, 4, 1, 3500.00, 3500.00, '2026-07-16 01:10:52', '2026-07-16 01:10:52'),
(190, 56, 18, 1, 4500.00, 4500.00, '2026-07-16 01:10:52', '2026-07-16 01:10:52'),
(191, 56, 20, 2, 5000.00, 10000.00, '2026-07-16 01:10:52', '2026-07-16 01:10:52'),
(192, 57, 10, 1, 14500.00, 14500.00, '2026-07-20 04:52:03', '2026-07-20 04:52:03'),
(193, 57, 60, 1, 13500.00, 13500.00, '2026-07-20 04:52:03', '2026-07-20 04:52:03'),
(194, 58, 26, 1, 22000.00, 22000.00, '2026-07-22 15:05:52', '2026-07-22 15:05:52'),
(195, 58, 42, 3, 15500.00, 46500.00, '2026-07-22 15:05:52', '2026-07-22 15:05:52'),
(196, 59, 9, 1, 32000.00, 32000.00, '2026-07-23 07:05:07', '2026-07-23 07:05:07'),
(197, 59, 3, 2, 6500.00, 13000.00, '2026-07-23 07:05:07', '2026-07-23 07:05:07'),
(198, 59, 55, 2, 9500.00, 19000.00, '2026-07-23 07:05:07', '2026-07-23 07:05:07'),
(199, 59, 50, 1, 1200.00, 1200.00, '2026-07-23 07:05:07', '2026-07-23 07:05:07'),
(200, 59, 36, 1, 1800.00, 1800.00, '2026-07-23 07:05:07', '2026-07-23 07:05:07'),
(201, 60, 42, 2, 15500.00, 31000.00, '2026-07-23 16:01:16', '2026-07-23 16:01:16'),
(202, 60, 54, 3, 1100.00, 3300.00, '2026-07-23 16:01:16', '2026-07-23 16:01:16'),
(203, 60, 8, 2, 8000.00, 16000.00, '2026-07-23 16:01:16', '2026-07-23 16:01:16'),
(204, 61, 18, 1, 4500.00, 4500.00, '2026-07-23 21:46:28', '2026-07-23 21:46:28'),
(205, 62, 20, 3, 5000.00, 15000.00, '2026-07-25 10:22:43', '2026-07-25 10:22:43'),
(206, 63, 24, 2, 17500.00, 35000.00, '2026-07-27 05:59:20', '2026-07-27 05:59:20'),
(207, 63, 20, 3, 5000.00, 15000.00, '2026-07-27 05:59:20', '2026-07-27 05:59:20'),
(208, 63, 7, 2, 12000.00, 24000.00, '2026-07-27 05:59:20', '2026-07-27 05:59:20'),
(209, 64, 9, 1, 32000.00, 32000.00, '2026-07-27 12:06:53', '2026-07-27 12:06:53'),
(210, 64, 8, 2, 8000.00, 16000.00, '2026-07-27 12:06:53', '2026-07-27 12:06:53'),
(211, 65, 12, 3, 52000.00, 156000.00, '2026-07-27 22:49:19', '2026-07-27 22:49:19'),
(212, 65, 21, 1, 9500.00, 9500.00, '2026-07-27 22:49:19', '2026-07-27 22:49:19'),
(213, 65, 45, 1, 7500.00, 7500.00, '2026-07-27 22:49:19', '2026-07-27 22:49:19'),
(214, 65, 40, 3, 24500.00, 73500.00, '2026-07-27 22:49:19', '2026-07-27 22:49:19'),
(215, 66, 21, 2, 9500.00, 19000.00, '2026-07-28 08:06:02', '2026-07-28 08:06:02'),
(216, 66, 26, 2, 22000.00, 44000.00, '2026-07-28 08:06:02', '2026-07-28 08:06:02'),
(217, 67, 9, 2, 32000.00, 64000.00, '2026-08-02 05:22:51', '2026-08-02 05:22:51'),
(218, 67, 16, 2, 48000.00, 96000.00, '2026-08-02 05:22:51', '2026-08-02 05:22:51'),
(219, 68, 14, 3, 16500.00, 49500.00, '2026-08-05 09:08:01', '2026-08-05 09:08:01'),
(220, 68, 21, 3, 9500.00, 28500.00, '2026-08-05 09:08:01', '2026-08-05 09:08:01'),
(221, 69, 16, 1, 48000.00, 48000.00, '2026-08-05 18:27:21', '2026-08-05 18:27:21'),
(222, 69, 11, 3, 85000.00, 255000.00, '2026-08-05 18:27:21', '2026-08-05 18:27:21'),
(223, 69, 42, 1, 15500.00, 15500.00, '2026-08-05 18:27:21', '2026-08-05 18:27:21'),
(224, 69, 45, 2, 7500.00, 15000.00, '2026-08-05 18:27:21', '2026-08-05 18:27:21'),
(225, 70, 27, 3, 12500.00, 37500.00, '2026-08-11 01:22:08', '2026-08-11 01:22:08'),
(226, 71, 26, 3, 22000.00, 66000.00, '2026-08-12 01:29:26', '2026-08-12 01:29:26'),
(227, 72, 3, 1, 6500.00, 6500.00, '2026-08-13 20:31:40', '2026-08-13 20:31:40'),
(228, 72, 34, 1, 3800.00, 3800.00, '2026-08-13 20:31:40', '2026-08-13 20:31:40'),
(229, 73, 46, 2, 22000.00, 44000.00, '2026-08-15 23:20:49', '2026-08-15 23:20:49'),
(230, 73, 39, 1, 4200.00, 4200.00, '2026-08-15 23:20:49', '2026-08-15 23:20:49'),
(231, 74, 60, 3, 13500.00, 40500.00, '2026-08-20 20:56:22', '2026-08-20 20:56:22'),
(232, 75, 27, 1, 12500.00, 12500.00, '2026-08-21 06:08:40', '2026-08-21 06:08:40'),
(233, 76, 19, 1, 2500.00, 2500.00, '2026-08-21 07:10:22', '2026-08-21 07:10:22'),
(234, 77, 55, 1, 9500.00, 9500.00, '2026-08-22 15:18:37', '2026-08-22 15:18:37'),
(235, 77, 54, 3, 1100.00, 3300.00, '2026-08-22 15:18:37', '2026-08-22 15:18:37'),
(236, 78, 2, 2, 18500.00, 37000.00, '2026-08-24 10:52:06', '2026-08-24 10:52:06'),
(237, 78, 42, 2, 15500.00, 31000.00, '2026-08-24 10:52:06', '2026-08-24 10:52:06'),
(238, 78, 18, 2, 4500.00, 9000.00, '2026-08-24 10:52:06', '2026-08-24 10:52:06'),
(239, 78, 7, 2, 12000.00, 24000.00, '2026-08-24 10:52:06', '2026-08-24 10:52:06'),
(240, 78, 36, 3, 1800.00, 5400.00, '2026-08-24 10:52:06', '2026-08-24 10:52:06'),
(241, 79, 48, 3, 4500.00, 13500.00, '2026-08-25 13:38:56', '2026-08-25 13:38:56'),
(242, 80, 7, 2, 12000.00, 24000.00, '2026-08-26 16:13:21', '2026-08-26 16:13:21'),
(243, 80, 26, 2, 22000.00, 44000.00, '2026-08-26 16:13:21', '2026-08-26 16:13:21'),
(244, 80, 51, 1, 3500.00, 3500.00, '2026-08-26 16:13:21', '2026-08-26 16:13:21'),
(245, 80, 9, 3, 32000.00, 96000.00, '2026-08-26 16:13:21', '2026-08-26 16:13:21'),
(246, 80, 4, 1, 3500.00, 3500.00, '2026-08-26 16:13:21', '2026-08-26 16:13:21'),
(247, 81, 1, 1, 25000.00, 25000.00, '2026-08-29 01:05:14', '2026-08-29 01:05:14'),
(248, 81, 20, 2, 5000.00, 10000.00, '2026-08-29 01:05:14', '2026-08-29 01:05:14'),
(249, 81, 14, 3, 16500.00, 49500.00, '2026-08-29 01:05:14', '2026-08-29 01:05:14'),
(250, 81, 43, 1, 28000.00, 28000.00, '2026-08-29 01:05:14', '2026-08-29 01:05:14'),
(251, 81, 2, 1, 18500.00, 18500.00, '2026-08-29 01:05:14', '2026-08-29 01:05:14'),
(252, 82, 8, 1, 8000.00, 8000.00, '2026-08-31 09:45:37', '2026-08-31 09:45:37'),
(253, 82, 46, 3, 22000.00, 66000.00, '2026-08-31 09:45:37', '2026-08-31 09:45:37'),
(254, 82, 2, 3, 18500.00, 55500.00, '2026-08-31 09:45:37', '2026-08-31 09:45:37'),
(255, 82, 50, 2, 1200.00, 2400.00, '2026-08-31 09:45:37', '2026-08-31 09:45:37'),
(256, 83, 10, 1, 14500.00, 14500.00, '2026-09-01 09:36:17', '2026-09-01 09:36:17'),
(257, 83, 18, 1, 4500.00, 4500.00, '2026-09-01 09:36:17', '2026-09-01 09:36:17'),
(258, 83, 3, 2, 6500.00, 13000.00, '2026-09-01 09:36:17', '2026-09-01 09:36:17'),
(259, 83, 35, 2, 2500.00, 5000.00, '2026-09-01 09:36:17', '2026-09-01 09:36:17'),
(260, 84, 56, 3, 32000.00, 96000.00, '2026-09-07 14:01:43', '2026-09-07 14:01:43'),
(261, 84, 52, 3, 4800.00, 14400.00, '2026-09-07 14:01:43', '2026-09-07 14:01:43'),
(262, 84, 58, 1, 3500.00, 3500.00, '2026-09-07 14:01:43', '2026-09-07 14:01:43'),
(263, 84, 25, 1, 6000.00, 6000.00, '2026-09-07 14:01:43', '2026-09-07 14:01:43'),
(264, 84, 26, 2, 22000.00, 44000.00, '2026-09-07 14:01:43', '2026-09-07 14:01:43'),
(265, 85, 45, 3, 7500.00, 22500.00, '2026-09-08 11:39:27', '2026-09-08 11:39:27'),
(266, 85, 59, 1, 95000.00, 95000.00, '2026-09-08 11:39:27', '2026-09-08 11:39:27'),
(267, 85, 2, 1, 18500.00, 18500.00, '2026-09-08 11:39:27', '2026-09-08 11:39:27'),
(268, 86, 39, 3, 4200.00, 12600.00, '2026-09-11 01:20:14', '2026-09-11 01:20:14'),
(269, 86, 51, 3, 3500.00, 10500.00, '2026-09-11 01:20:14', '2026-09-11 01:20:14'),
(270, 86, 43, 1, 28000.00, 28000.00, '2026-09-11 01:20:14', '2026-09-11 01:20:14'),
(271, 87, 29, 1, 19500.00, 19500.00, '2026-09-13 00:08:47', '2026-09-13 00:08:47'),
(272, 87, 22, 3, 12500.00, 37500.00, '2026-09-13 00:08:47', '2026-09-13 00:08:47'),
(273, 87, 46, 1, 22000.00, 22000.00, '2026-09-13 00:08:47', '2026-09-13 00:08:47'),
(274, 87, 48, 2, 4500.00, 9000.00, '2026-09-13 00:08:47', '2026-09-13 00:08:47'),
(275, 87, 7, 3, 12000.00, 36000.00, '2026-09-13 00:08:47', '2026-09-13 00:08:47'),
(276, 88, 9, 2, 32000.00, 64000.00, '2026-09-13 09:34:58', '2026-09-13 09:34:58'),
(277, 88, 41, 2, 5500.00, 11000.00, '2026-09-13 09:34:58', '2026-09-13 09:34:58'),
(278, 89, 51, 3, 3500.00, 10500.00, '2026-09-16 02:21:31', '2026-09-16 02:21:31'),
(279, 90, 50, 3, 1200.00, 3600.00, '2026-09-17 18:22:10', '2026-09-17 18:22:10'),
(280, 90, 34, 1, 3800.00, 3800.00, '2026-09-17 18:22:10', '2026-09-17 18:22:10'),
(281, 90, 35, 1, 2500.00, 2500.00, '2026-09-17 18:22:10', '2026-09-17 18:22:10'),
(282, 90, 39, 2, 4200.00, 8400.00, '2026-09-17 18:22:10', '2026-09-17 18:22:10'),
(283, 90, 37, 1, 58000.00, 58000.00, '2026-09-17 18:22:10', '2026-09-17 18:22:10'),
(284, 91, 26, 2, 22000.00, 44000.00, '2026-09-20 13:14:07', '2026-09-20 13:14:07'),
(285, 91, 51, 1, 3500.00, 3500.00, '2026-09-20 13:14:07', '2026-09-20 13:14:07'),
(286, 91, 34, 2, 3800.00, 7600.00, '2026-09-20 13:14:07', '2026-09-20 13:14:07'),
(287, 92, 3, 1, 6500.00, 6500.00, '2026-09-21 11:10:57', '2026-09-21 11:10:57'),
(288, 92, 26, 2, 22000.00, 44000.00, '2026-09-21 11:10:57', '2026-09-21 11:10:57'),
(289, 93, 16, 2, 48000.00, 96000.00, '2026-09-24 13:10:56', '2026-09-24 13:10:56'),
(290, 93, 36, 3, 1800.00, 5400.00, '2026-09-24 13:10:56', '2026-09-24 13:10:56'),
(291, 94, 52, 2, 4800.00, 9600.00, '2026-09-26 06:53:45', '2026-09-26 06:53:45'),
(292, 94, 39, 1, 4200.00, 4200.00, '2026-09-26 06:53:45', '2026-09-26 06:53:45'),
(293, 95, 35, 1, 2500.00, 2500.00, '2026-09-27 00:57:32', '2026-09-27 00:57:32'),
(294, 96, 39, 2, 4200.00, 8400.00, '2026-09-27 05:26:42', '2026-09-27 05:26:42'),
(295, 96, 29, 2, 19500.00, 39000.00, '2026-09-27 05:26:42', '2026-09-27 05:26:42'),
(296, 96, 46, 2, 22000.00, 44000.00, '2026-09-27 05:26:42', '2026-09-27 05:26:42'),
(297, 97, 50, 2, 1200.00, 2400.00, '2026-09-27 21:47:49', '2026-09-27 21:47:49'),
(298, 97, 38, 1, 35000.00, 35000.00, '2026-09-27 21:47:49', '2026-09-27 21:47:49'),
(299, 97, 39, 1, 4200.00, 4200.00, '2026-09-27 21:47:49', '2026-09-27 21:47:49'),
(300, 98, 12, 3, 52000.00, 156000.00, '2026-10-01 17:35:34', '2026-10-01 17:35:34'),
(301, 99, 29, 3, 19500.00, 58500.00, '2026-10-02 03:21:30', '2026-10-02 03:21:30'),
(302, 100, 36, 1, 1800.00, 1800.00, '2026-10-03 09:17:18', '2026-10-03 09:17:18'),
(303, 100, 7, 2, 12000.00, 24000.00, '2026-10-03 09:17:18', '2026-10-03 09:17:18'),
(304, 100, 42, 2, 15500.00, 31000.00, '2026-10-03 09:17:18', '2026-10-03 09:17:18'),
(305, 101, 19, 2, 2500.00, 5000.00, '2026-10-03 12:43:40', '2026-10-03 12:43:40'),
(306, 101, 57, 2, 11500.00, 23000.00, '2026-10-03 12:43:40', '2026-10-03 12:43:40'),
(307, 102, 43, 2, 28000.00, 56000.00, '2026-10-05 00:37:47', '2026-10-05 00:37:47'),
(308, 102, 30, 2, 16000.00, 32000.00, '2026-10-05 00:37:47', '2026-10-05 00:37:47'),
(309, 102, 40, 3, 24500.00, 73500.00, '2026-10-05 00:37:47', '2026-10-05 00:37:47'),
(310, 102, 8, 1, 8000.00, 8000.00, '2026-10-05 00:37:47', '2026-10-05 00:37:47'),
(311, 102, 50, 3, 1200.00, 3600.00, '2026-10-05 00:37:47', '2026-10-05 00:37:47'),
(312, 103, 35, 1, 2500.00, 2500.00, '2026-10-05 18:17:45', '2026-10-05 18:17:45'),
(313, 103, 11, 2, 85000.00, 170000.00, '2026-10-05 18:17:45', '2026-10-05 18:17:45'),
(314, 103, 39, 2, 4200.00, 8400.00, '2026-10-05 18:17:45', '2026-10-05 18:17:45'),
(315, 103, 8, 1, 8000.00, 8000.00, '2026-10-05 18:17:45', '2026-10-05 18:17:45'),
(316, 104, 9, 3, 32000.00, 96000.00, '2026-10-06 04:30:12', '2026-10-06 04:30:12'),
(317, 105, 49, 1, 2200.00, 2200.00, '2026-10-06 16:38:49', '2026-10-06 16:38:49'),
(318, 105, 16, 1, 48000.00, 48000.00, '2026-10-06 16:38:49', '2026-10-06 16:38:49'),
(319, 105, 19, 3, 2500.00, 7500.00, '2026-10-06 16:38:49', '2026-10-06 16:38:49'),
(320, 105, 21, 2, 9500.00, 19000.00, '2026-10-06 16:38:49', '2026-10-06 16:38:49'),
(321, 105, 14, 2, 16500.00, 33000.00, '2026-10-06 16:38:49', '2026-10-06 16:38:49'),
(322, 106, 7, 3, 12000.00, 36000.00, '2026-10-06 20:58:01', '2026-10-06 20:58:01'),
(323, 106, 11, 1, 85000.00, 85000.00, '2026-10-06 20:58:01', '2026-10-06 20:58:01'),
(324, 106, 37, 1, 58000.00, 58000.00, '2026-10-06 20:58:01', '2026-10-06 20:58:01'),
(325, 106, 20, 1, 5000.00, 5000.00, '2026-10-06 20:58:01', '2026-10-06 20:58:01'),
(326, 107, 43, 2, 28000.00, 56000.00, '2026-10-07 22:30:35', '2026-10-07 22:30:35'),
(327, 107, 22, 2, 12500.00, 25000.00, '2026-10-07 22:30:35', '2026-10-07 22:30:35'),
(328, 107, 34, 3, 3800.00, 11400.00, '2026-10-07 22:30:35', '2026-10-07 22:30:35'),
(329, 107, 7, 2, 12000.00, 24000.00, '2026-10-07 22:30:35', '2026-10-07 22:30:35'),
(330, 108, 2, 3, 18500.00, 55500.00, '2026-10-08 13:17:01', '2026-10-08 13:17:01'),
(331, 108, 36, 1, 1800.00, 1800.00, '2026-10-08 13:17:01', '2026-10-08 13:17:01'),
(332, 109, 7, 3, 12000.00, 36000.00, '2026-10-08 15:58:03', '2026-10-08 15:58:03'),
(333, 109, 52, 3, 4800.00, 14400.00, '2026-10-08 15:58:03', '2026-10-08 15:58:03'),
(334, 109, 57, 3, 11500.00, 34500.00, '2026-10-08 15:58:03', '2026-10-08 15:58:03'),
(335, 110, 30, 1, 16000.00, 16000.00, '2026-10-08 22:45:11', '2026-10-08 22:45:11'),
(336, 111, 51, 1, 3500.00, 3500.00, '2026-10-09 05:22:49', '2026-10-09 05:22:49'),
(337, 111, 50, 3, 1200.00, 3600.00, '2026-10-09 05:22:49', '2026-10-09 05:22:49'),
(338, 112, 30, 2, 16000.00, 32000.00, '2026-10-09 05:43:25', '2026-10-09 05:43:25'),
(339, 112, 2, 1, 18500.00, 18500.00, '2026-10-09 05:43:25', '2026-10-09 05:43:25'),
(340, 112, 51, 2, 3500.00, 7000.00, '2026-10-09 05:43:25', '2026-10-09 05:43:25'),
(341, 112, 35, 1, 2500.00, 2500.00, '2026-10-09 05:43:25', '2026-10-09 05:43:25'),
(342, 113, 53, 1, 1500.00, 1500.00, '2026-10-09 16:24:29', '2026-10-09 16:24:29'),
(343, 114, 31, 2, 65000.00, 130000.00, '2026-10-09 16:42:39', '2026-10-09 16:42:39'),
(344, 114, 59, 2, 95000.00, 190000.00, '2026-10-09 16:42:39', '2026-10-09 16:42:39'),
(345, 114, 33, 2, 42000.00, 84000.00, '2026-10-09 16:42:39', '2026-10-09 16:42:39'),
(346, 114, 10, 3, 14500.00, 43500.00, '2026-10-09 16:42:39', '2026-10-09 16:42:39'),
(347, 114, 52, 1, 4800.00, 4800.00, '2026-10-09 16:42:39', '2026-10-09 16:42:39'),
(348, 115, 50, 3, 1200.00, 3600.00, '2026-10-09 22:55:15', '2026-10-09 22:55:15'),
(349, 116, 43, 1, 28000.00, 28000.00, '2026-10-10 08:21:08', '2026-10-10 08:21:08'),
(350, 116, 55, 1, 9500.00, 9500.00, '2026-10-10 08:21:08', '2026-10-10 08:21:08'),
(351, 116, 36, 1, 1800.00, 1800.00, '2026-10-10 08:21:08', '2026-10-10 08:21:08'),
(352, 117, 27, 2, 12500.00, 25000.00, '2026-10-10 16:28:52', '2026-10-10 16:28:52'),
(353, 118, 29, 3, 19500.00, 58500.00, '2026-10-11 06:18:54', '2026-10-11 06:18:54'),
(354, 119, 18, 3, 4500.00, 13500.00, '2026-10-11 15:10:59', '2026-10-11 15:10:59'),
(355, 119, 29, 2, 19500.00, 39000.00, '2026-10-11 15:10:59', '2026-10-11 15:10:59'),
(356, 119, 50, 1, 1200.00, 1200.00, '2026-10-11 15:10:59', '2026-10-11 15:10:59'),
(357, 119, 42, 3, 15500.00, 46500.00, '2026-10-11 15:10:59', '2026-10-11 15:10:59'),
(358, 119, 5, 2, 15000.00, 30000.00, '2026-10-11 15:10:59', '2026-10-11 15:10:59'),
(359, 120, 46, 3, 22000.00, 66000.00, '2026-10-11 18:11:21', '2026-10-11 18:11:21'),
(360, 120, 5, 1, 15000.00, 15000.00, '2026-10-11 18:11:21', '2026-10-11 18:11:21'),
(361, 120, 2, 3, 18500.00, 55500.00, '2026-10-11 18:11:21', '2026-10-11 18:11:21'),
(362, 120, 34, 3, 3800.00, 11400.00, '2026-10-11 18:11:21', '2026-10-11 18:11:21'),
(363, 121, 41, 1, 5500.00, 5500.00, '2026-10-11 20:13:50', '2026-10-11 20:13:50'),
(364, 122, 29, 2, 19500.00, 39000.00, '2026-10-12 04:12:15', '2026-10-12 04:12:15'),
(365, 122, 34, 2, 3800.00, 7600.00, '2026-10-12 04:12:15', '2026-10-12 04:12:15'),
(366, 122, 43, 2, 28000.00, 56000.00, '2026-10-12 04:12:15', '2026-10-12 04:12:15'),
(367, 122, 49, 3, 2200.00, 6600.00, '2026-10-12 04:12:15', '2026-10-12 04:12:15'),
(368, 123, 50, 3, 1200.00, 3600.00, '2026-10-12 11:29:03', '2026-10-12 11:29:03'),
(369, 123, 3, 1, 6500.00, 6500.00, '2026-10-12 11:29:03', '2026-10-12 11:29:03'),
(370, 123, 30, 1, 16000.00, 16000.00, '2026-10-12 11:29:03', '2026-10-12 11:29:03'),
(371, 123, 19, 3, 2500.00, 7500.00, '2026-10-12 11:29:03', '2026-10-12 11:29:03'),
(372, 123, 35, 1, 2500.00, 2500.00, '2026-10-12 11:29:03', '2026-10-12 11:29:03'),
(373, 124, 50, 2, 1200.00, 2400.00, '2026-10-12 12:28:52', '2026-10-12 12:28:52'),
(374, 124, 3, 3, 6500.00, 19500.00, '2026-10-12 12:28:52', '2026-10-12 12:28:52'),
(375, 124, 21, 2, 9500.00, 19000.00, '2026-10-12 12:28:52', '2026-10-12 12:28:52'),
(376, 124, 37, 1, 58000.00, 58000.00, '2026-10-12 12:28:52', '2026-10-12 12:28:52'),
(377, 125, 3, 3, 6500.00, 19500.00, '2026-10-13 01:49:21', '2026-10-13 01:49:21'),
(378, 125, 20, 1, 5000.00, 5000.00, '2026-10-13 01:49:21', '2026-10-13 01:49:21'),
(379, 125, 55, 3, 9500.00, 28500.00, '2026-10-13 01:49:21', '2026-10-13 01:49:21'),
(380, 125, 2, 3, 18500.00, 55500.00, '2026-10-13 01:49:21', '2026-10-13 01:49:21'),
(381, 125, 24, 1, 17500.00, 17500.00, '2026-10-13 01:49:21', '2026-10-13 01:49:21'),
(382, 126, 36, 3, 1800.00, 5400.00, '2026-10-13 07:56:27', '2026-10-13 07:56:27'),
(383, 126, 14, 3, 16500.00, 49500.00, '2026-10-13 07:56:27', '2026-10-13 07:56:27'),
(384, 126, 56, 1, 32000.00, 32000.00, '2026-10-13 07:56:27', '2026-10-13 07:56:27'),
(385, 126, 49, 1, 2200.00, 2200.00, '2026-10-13 07:56:27', '2026-10-13 07:56:27'),
(386, 127, 41, 1, 5500.00, 5500.00, '2026-10-13 23:46:25', '2026-10-13 23:46:25'),
(387, 128, 54, 2, 1100.00, 2200.00, '2026-10-14 03:30:02', '2026-10-14 03:30:02'),
(388, 128, 3, 2, 6500.00, 13000.00, '2026-10-14 03:30:02', '2026-10-14 03:30:02'),
(389, 128, 12, 2, 52000.00, 104000.00, '2026-10-14 03:30:02', '2026-10-14 03:30:02'),
(390, 128, 15, 1, 45000.00, 45000.00, '2026-10-14 03:30:02', '2026-10-14 03:30:02'),
(391, 128, 19, 2, 2500.00, 5000.00, '2026-10-14 03:30:02', '2026-10-14 03:30:02'),
(392, 129, 49, 3, 2200.00, 6600.00, '2026-10-14 14:14:23', '2026-10-14 14:14:23'),
(393, 129, 50, 3, 1200.00, 3600.00, '2026-10-14 14:14:23', '2026-10-14 14:14:23'),
(394, 129, 55, 3, 9500.00, 28500.00, '2026-10-14 14:14:23', '2026-10-14 14:14:23'),
(395, 129, 53, 1, 1500.00, 1500.00, '2026-10-14 14:14:23', '2026-10-14 14:14:23'),
(396, 129, 4, 3, 3500.00, 10500.00, '2026-10-14 14:14:23', '2026-10-14 14:14:23'),
(397, 130, 50, 3, 1200.00, 3600.00, '2026-10-14 19:34:16', '2026-10-14 19:34:16'),
(398, 130, 10, 3, 14500.00, 43500.00, '2026-10-14 19:34:16', '2026-10-14 19:34:16'),
(399, 131, 8, 2, 8000.00, 16000.00, '2026-10-14 21:56:46', '2026-10-14 21:56:46'),
(400, 131, 41, 1, 5500.00, 5500.00, '2026-10-14 21:56:46', '2026-10-14 21:56:46'),
(401, 132, 3, 2, 6500.00, 13000.00, '2026-10-15 00:35:20', '2026-10-15 00:35:20'),
(402, 132, 22, 2, 12500.00, 25000.00, '2026-10-15 00:35:20', '2026-10-15 00:35:20'),
(403, 132, 39, 1, 4200.00, 4200.00, '2026-10-15 00:35:20', '2026-10-15 00:35:20'),
(404, 132, 26, 3, 22000.00, 66000.00, '2026-10-15 00:35:20', '2026-10-15 00:35:20'),
(405, 133, 60, 1, 13500.00, 13500.00, '2026-10-15 00:46:12', '2026-10-15 00:46:12'),
(406, 133, 24, 1, 17500.00, 17500.00, '2026-10-15 00:46:12', '2026-10-15 00:46:12'),
(407, 133, 51, 2, 3500.00, 7000.00, '2026-10-15 00:46:12', '2026-10-15 00:46:12'),
(408, 133, 18, 1, 4500.00, 4500.00, '2026-10-15 00:46:12', '2026-10-15 00:46:12'),
(409, 134, 54, 1, 1100.00, 1100.00, '2026-10-15 12:43:51', '2026-10-15 12:43:51'),
(410, 134, 11, 3, 85000.00, 255000.00, '2026-10-15 12:43:51', '2026-10-15 12:43:51'),
(411, 135, 54, 3, 1100.00, 3300.00, '2026-10-16 00:26:16', '2026-10-16 00:26:16'),
(412, 136, 18, 1, 4500.00, 4500.00, '2026-10-17 17:20:24', '2026-10-17 17:20:24'),
(413, 136, 51, 3, 3500.00, 10500.00, '2026-10-17 17:20:24', '2026-10-17 17:20:24'),
(414, 136, 20, 2, 5000.00, 10000.00, '2026-10-17 17:20:24', '2026-10-17 17:20:24'),
(415, 137, 30, 2, 16000.00, 32000.00, '2026-10-17 23:59:31', '2026-10-17 23:59:31'),
(416, 138, 24, 2, 17500.00, 35000.00, '2026-10-18 04:48:27', '2026-10-18 04:48:27'),
(417, 139, 22, 2, 12500.00, 25000.00, '2026-10-18 09:21:01', '2026-10-18 09:21:01'),
(418, 139, 39, 1, 4200.00, 4200.00, '2026-10-18 09:21:01', '2026-10-18 09:21:01'),
(419, 139, 31, 1, 65000.00, 65000.00, '2026-10-18 09:21:01', '2026-10-18 09:21:01'),
(420, 139, 30, 3, 16000.00, 48000.00, '2026-10-18 09:21:01', '2026-10-18 09:21:01'),
(421, 139, 15, 1, 45000.00, 45000.00, '2026-10-18 09:21:01', '2026-10-18 09:21:01'),
(422, 140, 30, 1, 16000.00, 16000.00, '2026-10-20 20:41:40', '2026-10-20 20:41:40'),
(423, 140, 16, 3, 48000.00, 144000.00, '2026-10-20 20:41:40', '2026-10-20 20:41:40'),
(424, 140, 50, 3, 1200.00, 3600.00, '2026-10-20 20:41:40', '2026-10-20 20:41:40'),
(425, 141, 21, 3, 9500.00, 28500.00, '2026-10-21 02:59:02', '2026-10-21 02:59:02'),
(426, 141, 20, 3, 5000.00, 15000.00, '2026-10-21 02:59:02', '2026-10-21 02:59:02'),
(427, 142, 19, 2, 2500.00, 5000.00, '2026-10-22 07:39:09', '2026-10-22 07:39:09'),
(428, 142, 48, 2, 4500.00, 9000.00, '2026-10-22 07:39:09', '2026-10-22 07:39:09'),
(429, 142, 15, 1, 45000.00, 45000.00, '2026-10-22 07:39:09', '2026-10-22 07:39:09'),
(430, 142, 60, 2, 13500.00, 27000.00, '2026-10-22 07:39:09', '2026-10-22 07:39:09'),
(431, 142, 41, 3, 5500.00, 16500.00, '2026-10-22 07:39:09', '2026-10-22 07:39:09'),
(432, 143, 56, 3, 32000.00, 96000.00, '2026-10-23 07:41:06', '2026-10-23 07:41:06'),
(433, 143, 57, 2, 11500.00, 23000.00, '2026-10-23 07:41:06', '2026-10-23 07:41:06'),
(434, 143, 3, 1, 6500.00, 6500.00, '2026-10-23 07:41:06', '2026-10-23 07:41:06'),
(435, 143, 16, 1, 48000.00, 48000.00, '2026-10-23 07:41:06', '2026-10-23 07:41:06'),
(436, 143, 27, 1, 12500.00, 12500.00, '2026-10-23 07:41:06', '2026-10-23 07:41:06'),
(437, 144, 49, 2, 2200.00, 4400.00, '2026-10-23 13:55:15', '2026-10-23 13:55:15'),
(438, 144, 57, 1, 11500.00, 11500.00, '2026-10-23 13:55:15', '2026-10-23 13:55:15'),
(439, 144, 27, 2, 12500.00, 25000.00, '2026-10-23 13:55:15', '2026-10-23 13:55:15'),
(440, 145, 28, 1, 14000.00, 14000.00, '2026-10-24 05:11:48', '2026-10-24 05:11:48'),
(441, 145, 10, 3, 14500.00, 43500.00, '2026-10-24 05:11:48', '2026-10-24 05:11:48'),
(442, 145, 57, 2, 11500.00, 23000.00, '2026-10-24 05:11:48', '2026-10-24 05:11:48'),
(443, 145, 40, 3, 24500.00, 73500.00, '2026-10-24 05:11:48', '2026-10-24 05:11:48'),
(444, 146, 35, 2, 2500.00, 5000.00, '2026-10-24 07:37:59', '2026-10-24 07:37:59'),
(445, 147, 40, 1, 24500.00, 24500.00, '2026-10-25 18:04:37', '2026-10-25 18:04:37'),
(446, 147, 38, 1, 35000.00, 35000.00, '2026-10-25 18:04:37', '2026-10-25 18:04:37'),
(447, 147, 33, 1, 42000.00, 42000.00, '2026-10-25 18:04:37', '2026-10-25 18:04:37'),
(448, 147, 50, 3, 1200.00, 3600.00, '2026-10-25 18:04:37', '2026-10-25 18:04:37'),
(449, 148, 27, 2, 12500.00, 25000.00, '2026-10-27 02:30:43', '2026-10-27 02:30:43'),
(450, 148, 18, 3, 4500.00, 13500.00, '2026-10-27 02:30:43', '2026-10-27 02:30:43'),
(451, 148, 36, 3, 1800.00, 5400.00, '2026-10-27 02:30:43', '2026-10-27 02:30:43'),
(452, 148, 48, 3, 4500.00, 13500.00, '2026-10-27 02:30:43', '2026-10-27 02:30:43'),
(453, 148, 43, 1, 28000.00, 28000.00, '2026-10-27 02:30:43', '2026-10-27 02:30:43'),
(454, 149, 27, 2, 12500.00, 25000.00, '2026-10-27 05:04:59', '2026-10-27 05:04:59'),
(455, 149, 18, 3, 4500.00, 13500.00, '2026-10-27 05:04:59', '2026-10-27 05:04:59'),
(456, 149, 54, 1, 1100.00, 1100.00, '2026-10-27 05:04:59', '2026-10-27 05:04:59'),
(457, 150, 54, 1, 1100.00, 1100.00, '2026-10-27 07:53:29', '2026-10-27 07:53:29'),
(458, 150, 19, 2, 2500.00, 5000.00, '2026-10-27 07:53:29', '2026-10-27 07:53:29'),
(463, 153, 33, 1, 42000.00, 42000.00, '2026-10-27 22:19:45', '2026-10-27 22:19:45');

-- --------------------------------------------------------

--
-- Structure de la table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('PHszf9ruyslgFJyagfK69Yq0QiCDUvBA5O96wMbj', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/156.0.0.0 Safari/537.36 Edg/156.0.0.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVWF3ZTRIbFNUZFZwNUprZGhwbXdZd0l1bTFaUjdSTEZIMjVlaFdqeSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1793136282);

-- --------------------------------------------------------

--
-- Structure de la table `settings`
--

CREATE TABLE `settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `key` varchar(255) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `settings`
--

INSERT INTO `settings` (`id`, `key`, `value`, `created_at`, `updated_at`) VALUES
(1, 'company_name', 'SalesStock', '2026-10-27 20:19:04', '2026-10-27 20:19:04'),
(2, 'currency', 'FCFA', '2026-10-27 20:19:04', '2026-10-27 20:19:04'),
(3, 'currency_symbol', 'FCFA', '2026-10-27 20:19:04', '2026-10-27 20:19:04'),
(4, 'default_tax_rate', '18', '2026-10-27 20:19:04', '2026-10-27 20:19:04'),
(5, 'default_low_stock_threshold', '5', '2026-10-27 20:19:04', '2026-10-27 23:31:03');

-- --------------------------------------------------------

--
-- Structure de la table `stock_movements`
--

CREATE TABLE `stock_movements` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED NOT NULL,
  `type` enum('entree','sortie','ajustement','annulation') NOT NULL,
  `quantity` int(11) NOT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `reference` varchar(255) DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `stock_movements`
--

INSERT INTO `stock_movements` (`id`, `product_id`, `type`, `quantity`, `reason`, `reference`, `user_id`, `created_at`) VALUES
(1, 1, 'entree', 42, 'Stock initial', NULL, NULL, '2026-10-27 20:19:07'),
(2, 2, 'entree', 30, 'Stock initial', NULL, NULL, '2026-10-27 20:19:07'),
(3, 3, 'entree', 120, 'Stock initial', NULL, NULL, '2026-10-27 20:19:07'),
(4, 4, 'entree', 95, 'Stock initial', NULL, NULL, '2026-10-27 20:19:07'),
(5, 5, 'entree', 3, 'Stock initial', NULL, NULL, '2026-10-27 20:19:07'),
(6, 6, 'entree', 0, 'Stock initial', NULL, NULL, '2026-10-27 20:19:08'),
(7, 7, 'entree', 22, 'Stock initial', NULL, NULL, '2026-10-27 20:19:08'),
(8, 8, 'entree', 4, 'Stock initial', NULL, NULL, '2026-10-27 20:19:08'),
(9, 9, 'entree', 25, 'Stock initial', NULL, NULL, '2026-10-27 20:19:08'),
(10, 10, 'entree', 40, 'Stock initial', NULL, NULL, '2026-10-27 20:19:08'),
(11, 11, 'entree', 12, 'Stock initial', NULL, NULL, '2026-10-27 20:19:08'),
(12, 12, 'entree', 18, 'Stock initial', NULL, NULL, '2026-10-27 20:19:08'),
(13, 13, 'entree', 2, 'Stock initial', NULL, NULL, '2026-10-27 20:19:08'),
(14, 14, 'entree', 35, 'Stock initial', NULL, NULL, '2026-10-27 20:19:08'),
(15, 15, 'entree', 9, 'Stock initial', NULL, NULL, '2026-10-27 20:19:08'),
(16, 16, 'entree', 14, 'Stock initial', NULL, NULL, '2026-10-27 20:19:08'),
(17, 17, 'entree', 0, 'Stock initial', NULL, NULL, '2026-10-27 20:19:08'),
(18, 18, 'entree', 88, 'Stock initial', NULL, NULL, '2026-10-27 20:19:08'),
(19, 19, 'entree', 150, 'Stock initial', NULL, NULL, '2026-10-27 20:19:08'),
(20, 20, 'entree', 60, 'Stock initial', NULL, NULL, '2026-10-27 20:19:09'),
(21, 21, 'entree', 45, 'Stock initial', NULL, NULL, '2026-10-27 20:19:09'),
(22, 22, 'entree', 55, 'Stock initial', NULL, NULL, '2026-10-27 20:19:09'),
(23, 23, 'entree', 3, 'Stock initial', NULL, NULL, '2026-10-27 20:19:09'),
(24, 24, 'entree', 11, 'Stock initial', NULL, NULL, '2026-10-27 20:19:09'),
(25, 25, 'entree', 7, 'Stock initial', NULL, NULL, '2026-10-27 20:19:09'),
(26, 26, 'entree', 26, 'Stock initial', NULL, NULL, '2026-10-27 20:19:09'),
(27, 27, 'entree', 33, 'Stock initial', NULL, NULL, '2026-10-27 20:19:09'),
(28, 28, 'entree', 2, 'Stock initial', NULL, NULL, '2026-10-27 20:19:09'),
(29, 29, 'entree', 17, 'Stock initial', NULL, NULL, '2026-10-27 20:19:09'),
(30, 30, 'entree', 21, 'Stock initial', NULL, NULL, '2026-10-27 20:19:09'),
(31, 31, 'entree', 8, 'Stock initial', NULL, NULL, '2026-10-27 20:19:09'),
(32, 32, 'entree', 0, 'Stock initial', NULL, NULL, '2026-10-27 20:19:09'),
(33, 33, 'entree', 13, 'Stock initial', NULL, NULL, '2026-10-27 20:19:09'),
(34, 34, 'entree', 130, 'Stock initial', NULL, NULL, '2026-10-27 20:19:10'),
(35, 35, 'entree', 95, 'Stock initial', NULL, NULL, '2026-10-27 20:19:10'),
(36, 36, 'entree', 110, 'Stock initial', NULL, NULL, '2026-10-27 20:19:10'),
(37, 37, 'entree', 6, 'Stock initial', NULL, NULL, '2026-10-27 20:19:10'),
(38, 38, 'entree', 5, 'Stock initial', NULL, NULL, '2026-10-27 20:19:10'),
(39, 39, 'entree', 74, 'Stock initial', NULL, NULL, '2026-10-27 20:19:10'),
(40, 40, 'entree', 16, 'Stock initial', NULL, NULL, '2026-10-27 20:19:10'),
(41, 41, 'entree', 85, 'Stock initial', NULL, NULL, '2026-10-27 20:19:10'),
(42, 42, 'entree', 40, 'Stock initial', NULL, NULL, '2026-10-27 20:19:10'),
(43, 43, 'entree', 24, 'Stock initial', NULL, NULL, '2026-10-27 20:19:10'),
(44, 44, 'entree', 3, 'Stock initial', NULL, NULL, '2026-10-27 20:19:10'),
(45, 45, 'entree', 52, 'Stock initial', NULL, NULL, '2026-10-27 20:19:10'),
(46, 46, 'entree', 18, 'Stock initial', NULL, NULL, '2026-10-27 20:19:11'),
(47, 47, 'entree', 0, 'Stock initial', NULL, NULL, '2026-10-27 20:19:11'),
(48, 48, 'entree', 140, 'Stock initial', NULL, NULL, '2026-10-27 20:19:11'),
(49, 49, 'entree', 160, 'Stock initial', NULL, NULL, '2026-10-27 20:19:11'),
(50, 50, 'entree', 180, 'Stock initial', NULL, NULL, '2026-10-27 20:19:11'),
(51, 51, 'entree', 65, 'Stock initial', NULL, NULL, '2026-10-27 20:19:11'),
(52, 52, 'entree', 90, 'Stock initial', NULL, NULL, '2026-10-27 20:19:11'),
(53, 53, 'entree', 4, 'Stock initial', NULL, NULL, '2026-10-27 20:19:11'),
(54, 54, 'entree', 120, 'Stock initial', NULL, NULL, '2026-10-27 20:19:11'),
(55, 55, 'entree', 38, 'Stock initial', NULL, NULL, '2026-10-27 20:19:11'),
(56, 56, 'entree', 10, 'Stock initial', NULL, NULL, '2026-10-27 20:19:11'),
(57, 57, 'entree', 27, 'Stock initial', NULL, NULL, '2026-10-27 20:19:12'),
(58, 58, 'entree', 3, 'Stock initial', NULL, NULL, '2026-10-27 20:19:12'),
(59, 59, 'entree', 5, 'Stock initial', NULL, NULL, '2026-10-27 20:19:12'),
(60, 60, 'entree', 22, 'Stock initial', NULL, NULL, '2026-10-27 20:19:12'),
(61, 34, 'sortie', -2, 'Vente VTE-2026-000001', 'VTE-2026-000001', 3, '2026-04-28 21:06:51'),
(62, 41, 'sortie', -1, 'Vente VTE-2026-000002', 'VTE-2026-000002', 2, '2026-04-29 12:32:12'),
(63, 2, 'sortie', -1, 'Vente VTE-2026-000002', 'VTE-2026-000002', 2, '2026-04-29 12:32:12'),
(64, 57, 'sortie', -3, 'Vente VTE-2026-000002', 'VTE-2026-000002', 2, '2026-04-29 12:32:12'),
(65, 55, 'sortie', -3, 'Vente VTE-2026-000002', 'VTE-2026-000002', 2, '2026-04-29 12:32:12'),
(66, 28, 'sortie', -1, 'Vente VTE-2026-000003', 'VTE-2026-000003', 3, '2026-05-01 18:56:02'),
(67, 39, 'sortie', -1, 'Vente VTE-2026-000004', 'VTE-2026-000004', 3, '2026-05-03 05:27:34'),
(68, 49, 'sortie', -2, 'Vente VTE-2026-000004', 'VTE-2026-000004', 3, '2026-05-03 05:27:34'),
(69, 18, 'sortie', -1, 'Vente VTE-2026-000004', 'VTE-2026-000004', 3, '2026-05-03 05:27:34'),
(70, 45, 'sortie', -2, 'Vente VTE-2026-000004', 'VTE-2026-000004', 3, '2026-05-03 05:27:34'),
(71, 42, 'sortie', -3, 'Vente VTE-2026-000004', 'VTE-2026-000004', 3, '2026-05-03 05:27:34'),
(72, 43, 'sortie', -1, 'Vente VTE-2026-000005', 'VTE-2026-000005', 2, '2026-05-05 09:30:22'),
(73, 21, 'sortie', -1, 'Vente VTE-2026-000005', 'VTE-2026-000005', 2, '2026-05-05 09:30:22'),
(74, 5, 'sortie', -1, 'Vente VTE-2026-000005', 'VTE-2026-000005', 2, '2026-05-05 09:30:22'),
(75, 50, 'sortie', -3, 'Vente VTE-2026-000005', 'VTE-2026-000005', 2, '2026-05-05 09:30:22'),
(76, 20, 'sortie', -1, 'Vente VTE-2026-000006', 'VTE-2026-000006', 2, '2026-05-05 11:55:38'),
(77, 18, 'sortie', -3, 'Vente VTE-2026-000006', 'VTE-2026-000006', 2, '2026-05-05 11:55:38'),
(78, 29, 'sortie', -3, 'Vente VTE-2026-000008', 'VTE-2026-000008', 2, '2026-05-09 06:18:57'),
(79, 10, 'sortie', -1, 'Vente VTE-2026-000008', 'VTE-2026-000008', 2, '2026-05-09 06:18:57'),
(80, 5, 'sortie', -1, 'Vente VTE-2026-000009', 'VTE-2026-000009', 1, '2026-05-09 14:05:08'),
(81, 34, 'sortie', -3, 'Vente VTE-2026-000009', 'VTE-2026-000009', 1, '2026-05-09 14:05:08'),
(82, 40, 'sortie', -2, 'Vente VTE-2026-000009', 'VTE-2026-000009', 1, '2026-05-09 14:05:08'),
(83, 10, 'sortie', -2, 'Vente VTE-2026-000009', 'VTE-2026-000009', 1, '2026-05-09 14:05:08'),
(84, 55, 'sortie', -3, 'Vente VTE-2026-000009', 'VTE-2026-000009', 1, '2026-05-09 14:05:08'),
(85, 20, 'sortie', -2, 'Vente VTE-2026-000012', 'VTE-2026-000012', 1, '2026-05-12 18:56:04'),
(86, 1, 'sortie', -2, 'Vente VTE-2026-000012', 'VTE-2026-000012', 1, '2026-05-12 18:56:04'),
(87, 37, 'sortie', -3, 'Vente VTE-2026-000012', 'VTE-2026-000012', 1, '2026-05-12 18:56:04'),
(88, 36, 'sortie', -1, 'Vente VTE-2026-000012', 'VTE-2026-000012', 1, '2026-05-12 18:56:04'),
(89, 27, 'sortie', -3, 'Vente VTE-2026-000014', 'VTE-2026-000014', 1, '2026-05-13 00:42:36'),
(90, 15, 'sortie', -3, 'Vente VTE-2026-000014', 'VTE-2026-000014', 1, '2026-05-13 00:42:36'),
(91, 25, 'sortie', -1, 'Vente VTE-2026-000015', 'VTE-2026-000015', 2, '2026-05-15 05:47:56'),
(92, 58, 'sortie', -2, 'Vente VTE-2026-000015', 'VTE-2026-000015', 2, '2026-05-15 05:47:56'),
(93, 38, 'sortie', -3, 'Vente VTE-2026-000015', 'VTE-2026-000015', 2, '2026-05-15 05:47:56'),
(94, 36, 'sortie', -3, 'Vente VTE-2026-000015', 'VTE-2026-000015', 2, '2026-05-15 05:47:56'),
(95, 31, 'sortie', -2, 'Vente VTE-2026-000015', 'VTE-2026-000015', 2, '2026-05-15 05:47:56'),
(96, 8, 'sortie', -1, 'Vente VTE-2026-000016', 'VTE-2026-000016', 1, '2026-05-16 03:31:36'),
(97, 29, 'sortie', -1, 'Vente VTE-2026-000016', 'VTE-2026-000016', 1, '2026-05-16 03:31:36'),
(98, 10, 'sortie', -2, 'Vente VTE-2026-000016', 'VTE-2026-000016', 1, '2026-05-16 03:31:36'),
(99, 59, 'sortie', -2, 'Vente VTE-2026-000017', 'VTE-2026-000017', 3, '2026-05-18 22:25:39'),
(100, 12, 'sortie', -2, 'Vente VTE-2026-000017', 'VTE-2026-000017', 3, '2026-05-18 22:25:39'),
(101, 42, 'sortie', -2, 'Vente VTE-2026-000018', 'VTE-2026-000018', 1, '2026-05-19 19:25:09'),
(102, 35, 'sortie', -1, 'Vente VTE-2026-000018', 'VTE-2026-000018', 1, '2026-05-19 19:25:09'),
(103, 27, 'sortie', -2, 'Vente VTE-2026-000018', 'VTE-2026-000018', 1, '2026-05-19 19:25:09'),
(104, 16, 'sortie', -2, 'Vente VTE-2026-000019', 'VTE-2026-000019', 2, '2026-05-21 16:39:41'),
(105, 9, 'sortie', -1, 'Vente VTE-2026-000020', 'VTE-2026-000020', 3, '2026-05-22 04:40:17'),
(106, 21, 'sortie', -3, 'Vente VTE-2026-000020', 'VTE-2026-000020', 3, '2026-05-22 04:40:17'),
(107, 39, 'sortie', -1, 'Vente VTE-2026-000020', 'VTE-2026-000020', 3, '2026-05-22 04:40:17'),
(108, 14, 'sortie', -2, 'Vente VTE-2026-000020', 'VTE-2026-000020', 3, '2026-05-22 04:40:17'),
(109, 8, 'sortie', -3, 'Vente VTE-2026-000021', 'VTE-2026-000021', 2, '2026-05-23 01:41:39'),
(110, 36, 'sortie', -3, 'Vente VTE-2026-000022', 'VTE-2026-000022', 1, '2026-05-29 10:49:44'),
(111, 42, 'sortie', -1, 'Vente VTE-2026-000023', 'VTE-2026-000023', 3, '2026-05-30 20:23:58'),
(112, 34, 'sortie', -1, 'Vente VTE-2026-000024', 'VTE-2026-000024', 3, '2026-06-01 08:32:42'),
(113, 9, 'sortie', -2, 'Vente VTE-2026-000024', 'VTE-2026-000024', 3, '2026-06-01 08:32:42'),
(114, 18, 'sortie', -1, 'Vente VTE-2026-000024', 'VTE-2026-000024', 3, '2026-06-01 08:32:42'),
(115, 29, 'sortie', -3, 'Vente VTE-2026-000024', 'VTE-2026-000024', 3, '2026-06-01 08:32:42'),
(116, 34, 'sortie', -1, 'Vente VTE-2026-000025', 'VTE-2026-000025', 1, '2026-06-01 22:04:18'),
(117, 12, 'sortie', -3, 'Vente VTE-2026-000025', 'VTE-2026-000025', 1, '2026-06-01 22:04:18'),
(118, 8, 'sortie', -1, 'Vente VTE-2026-000025', 'VTE-2026-000025', 1, '2026-06-01 22:04:18'),
(119, 24, 'sortie', -1, 'Vente VTE-2026-000025', 'VTE-2026-000025', 1, '2026-06-01 22:04:18'),
(120, 49, 'sortie', -1, 'Vente VTE-2026-000025', 'VTE-2026-000025', 1, '2026-06-01 22:04:18'),
(121, 40, 'sortie', -2, 'Vente VTE-2026-000026', 'VTE-2026-000026', 2, '2026-06-03 03:25:40'),
(122, 43, 'sortie', -2, 'Vente VTE-2026-000026', 'VTE-2026-000026', 2, '2026-06-03 03:25:40'),
(123, 52, 'sortie', -3, 'Vente VTE-2026-000026', 'VTE-2026-000026', 2, '2026-06-03 03:25:40'),
(124, 46, 'sortie', -3, 'Vente VTE-2026-000027', 'VTE-2026-000027', 3, '2026-06-03 14:38:12'),
(125, 34, 'sortie', -2, 'Vente VTE-2026-000027', 'VTE-2026-000027', 3, '2026-06-03 14:38:12'),
(126, 15, 'sortie', -1, 'Vente VTE-2026-000028', 'VTE-2026-000028', 3, '2026-06-03 16:30:24'),
(127, 51, 'sortie', -1, 'Vente VTE-2026-000028', 'VTE-2026-000028', 3, '2026-06-03 16:30:24'),
(128, 10, 'sortie', -2, 'Vente VTE-2026-000028', 'VTE-2026-000028', 3, '2026-06-03 16:30:24'),
(129, 33, 'sortie', -2, 'Vente VTE-2026-000028', 'VTE-2026-000028', 3, '2026-06-03 16:30:24'),
(130, 8, 'sortie', -1, 'Vente VTE-2026-000028', 'VTE-2026-000028', 3, '2026-06-03 16:30:24'),
(131, 19, 'sortie', -1, 'Vente VTE-2026-000029', 'VTE-2026-000029', 3, '2026-06-04 10:15:33'),
(132, 39, 'sortie', -1, 'Vente VTE-2026-000029', 'VTE-2026-000029', 3, '2026-06-04 10:15:33'),
(133, 51, 'sortie', -2, 'Vente VTE-2026-000029', 'VTE-2026-000029', 3, '2026-06-04 10:15:33'),
(134, 35, 'sortie', -1, 'Vente VTE-2026-000029', 'VTE-2026-000029', 3, '2026-06-04 10:15:33'),
(135, 15, 'sortie', -2, 'Vente VTE-2026-000030', 'VTE-2026-000030', 3, '2026-06-05 11:27:39'),
(136, 20, 'sortie', -3, 'Vente VTE-2026-000030', 'VTE-2026-000030', 3, '2026-06-05 11:27:39'),
(137, 42, 'sortie', -2, 'Vente VTE-2026-000031', 'VTE-2026-000031', 2, '2026-06-05 20:22:39'),
(138, 16, 'sortie', -2, 'Vente VTE-2026-000031', 'VTE-2026-000031', 2, '2026-06-05 20:22:39'),
(139, 43, 'sortie', -1, 'Vente VTE-2026-000031', 'VTE-2026-000031', 2, '2026-06-05 20:22:39'),
(140, 29, 'sortie', -3, 'Vente VTE-2026-000031', 'VTE-2026-000031', 2, '2026-06-05 20:22:39'),
(141, 36, 'sortie', -3, 'Vente VTE-2026-000031', 'VTE-2026-000031', 2, '2026-06-05 20:22:39'),
(142, 39, 'sortie', -2, 'Vente VTE-2026-000032', 'VTE-2026-000032', 2, '2026-06-06 11:46:46'),
(143, 46, 'sortie', -1, 'Vente VTE-2026-000032', 'VTE-2026-000032', 2, '2026-06-06 11:46:46'),
(144, 51, 'sortie', -3, 'Vente VTE-2026-000033', 'VTE-2026-000033', 2, '2026-06-07 03:25:27'),
(145, 7, 'sortie', -1, 'Vente VTE-2026-000033', 'VTE-2026-000033', 2, '2026-06-07 03:25:27'),
(146, 2, 'sortie', -3, 'Vente VTE-2026-000033', 'VTE-2026-000033', 2, '2026-06-07 03:25:27'),
(147, 43, 'sortie', -3, 'Vente VTE-2026-000033', 'VTE-2026-000033', 2, '2026-06-07 03:25:27'),
(148, 50, 'sortie', -2, 'Vente VTE-2026-000034', 'VTE-2026-000034', 3, '2026-06-07 07:09:45'),
(149, 22, 'sortie', -1, 'Vente VTE-2026-000034', 'VTE-2026-000034', 3, '2026-06-07 07:09:45'),
(150, 33, 'sortie', -2, 'Vente VTE-2026-000034', 'VTE-2026-000034', 3, '2026-06-07 07:09:45'),
(151, 49, 'sortie', -1, 'Vente VTE-2026-000034', 'VTE-2026-000034', 3, '2026-06-07 07:09:45'),
(152, 40, 'sortie', -2, 'Vente VTE-2026-000035', 'VTE-2026-000035', 1, '2026-06-07 16:23:14'),
(153, 19, 'sortie', -2, 'Vente VTE-2026-000035', 'VTE-2026-000035', 1, '2026-06-07 16:23:14'),
(154, 9, 'sortie', -2, 'Vente VTE-2026-000035', 'VTE-2026-000035', 1, '2026-06-07 16:23:14'),
(155, 57, 'sortie', -1, 'Vente VTE-2026-000035', 'VTE-2026-000035', 1, '2026-06-07 16:23:14'),
(156, 55, 'sortie', -3, 'Vente VTE-2026-000035', 'VTE-2026-000035', 1, '2026-06-07 16:23:14'),
(157, 12, 'sortie', -2, 'Vente VTE-2026-000036', 'VTE-2026-000036', 3, '2026-06-08 01:37:15'),
(158, 34, 'sortie', -1, 'Vente VTE-2026-000036', 'VTE-2026-000036', 3, '2026-06-08 01:37:15'),
(159, 52, 'sortie', -3, 'Vente VTE-2026-000036', 'VTE-2026-000036', 3, '2026-06-08 01:37:15'),
(160, 3, 'sortie', -3, 'Vente VTE-2026-000037', 'VTE-2026-000037', 2, '2026-06-10 10:08:45'),
(161, 34, 'sortie', -3, 'Vente VTE-2026-000037', 'VTE-2026-000037', 2, '2026-06-10 10:08:45'),
(162, 22, 'sortie', -1, 'Vente VTE-2026-000037', 'VTE-2026-000037', 2, '2026-06-10 10:08:45'),
(163, 33, 'sortie', -1, 'Vente VTE-2026-000037', 'VTE-2026-000037', 2, '2026-06-10 10:08:45'),
(164, 33, 'sortie', -2, 'Vente VTE-2026-000038', 'VTE-2026-000038', 3, '2026-06-12 00:03:28'),
(165, 12, 'sortie', -2, 'Vente VTE-2026-000038', 'VTE-2026-000038', 3, '2026-06-12 00:03:28'),
(166, 5, 'sortie', -3, 'Vente VTE-2026-000038', 'VTE-2026-000038', 3, '2026-06-12 00:03:28'),
(167, 7, 'sortie', -2, 'Vente VTE-2026-000038', 'VTE-2026-000038', 3, '2026-06-12 00:03:28'),
(168, 54, 'sortie', -2, 'Vente VTE-2026-000039', 'VTE-2026-000039', 2, '2026-06-13 06:30:02'),
(169, 15, 'sortie', -2, 'Vente VTE-2026-000040', 'VTE-2026-000040', 1, '2026-06-13 09:10:48'),
(170, 25, 'sortie', -2, 'Vente VTE-2026-000040', 'VTE-2026-000040', 1, '2026-06-13 09:10:48'),
(171, 5, 'sortie', -1, 'Vente VTE-2026-000040', 'VTE-2026-000040', 1, '2026-06-13 09:10:48'),
(172, 13, 'sortie', -2, 'Vente VTE-2026-000040', 'VTE-2026-000040', 1, '2026-06-13 09:10:48'),
(173, 45, 'sortie', -1, 'Vente VTE-2026-000040', 'VTE-2026-000040', 1, '2026-06-13 09:10:48'),
(174, 20, 'sortie', -1, 'Vente VTE-2026-000041', 'VTE-2026-000041', 1, '2026-06-13 15:30:45'),
(175, 1, 'sortie', -2, 'Vente VTE-2026-000041', 'VTE-2026-000041', 1, '2026-06-13 15:30:45'),
(176, 14, 'sortie', -2, 'Vente VTE-2026-000041', 'VTE-2026-000041', 1, '2026-06-13 15:30:45'),
(177, 12, 'sortie', -1, 'Vente VTE-2026-000041', 'VTE-2026-000041', 1, '2026-06-13 15:30:45'),
(178, 18, 'sortie', -3, 'Vente VTE-2026-000042', 'VTE-2026-000042', 1, '2026-06-15 07:05:22'),
(179, 50, 'sortie', -3, 'Vente VTE-2026-000042', 'VTE-2026-000042', 1, '2026-06-15 07:05:22'),
(180, 49, 'sortie', -3, 'Vente VTE-2026-000042', 'VTE-2026-000042', 1, '2026-06-15 07:05:22'),
(181, 26, 'sortie', -3, 'Vente VTE-2026-000042', 'VTE-2026-000042', 1, '2026-06-15 07:05:22'),
(182, 33, 'sortie', -2, 'Vente VTE-2026-000042', 'VTE-2026-000042', 1, '2026-06-15 07:05:22'),
(183, 36, 'sortie', -3, 'Vente VTE-2026-000043', 'VTE-2026-000043', 1, '2026-06-15 22:04:41'),
(184, 55, 'sortie', -3, 'Vente VTE-2026-000043', 'VTE-2026-000043', 1, '2026-06-15 22:04:41'),
(185, 5, 'sortie', -1, 'Vente VTE-2026-000043', 'VTE-2026-000043', 1, '2026-06-15 22:04:41'),
(186, 43, 'sortie', -3, 'Vente VTE-2026-000043', 'VTE-2026-000043', 1, '2026-06-15 22:04:41'),
(187, 34, 'sortie', -3, 'Vente VTE-2026-000043', 'VTE-2026-000043', 1, '2026-06-15 22:04:41'),
(188, 4, 'sortie', -3, 'Vente VTE-2026-000044', 'VTE-2026-000044', 3, '2026-06-16 22:43:32'),
(189, 22, 'sortie', -1, 'Vente VTE-2026-000044', 'VTE-2026-000044', 3, '2026-06-16 22:43:32'),
(190, 50, 'sortie', -3, 'Vente VTE-2026-000044', 'VTE-2026-000044', 3, '2026-06-16 22:43:32'),
(191, 41, 'sortie', -3, 'Vente VTE-2026-000044', 'VTE-2026-000044', 3, '2026-06-16 22:43:32'),
(192, 15, 'sortie', -2, 'Vente VTE-2026-000045', 'VTE-2026-000045', 2, '2026-06-21 09:45:14'),
(193, 1, 'sortie', -1, 'Vente VTE-2026-000046', 'VTE-2026-000046', 3, '2026-06-22 07:28:16'),
(194, 42, 'sortie', -2, 'Vente VTE-2026-000046', 'VTE-2026-000046', 3, '2026-06-22 07:28:16'),
(195, 48, 'sortie', -1, 'Vente VTE-2026-000046', 'VTE-2026-000046', 3, '2026-06-22 07:28:16'),
(196, 22, 'sortie', -1, 'Vente VTE-2026-000046', 'VTE-2026-000046', 3, '2026-06-22 07:28:16'),
(197, 49, 'sortie', -1, 'Vente VTE-2026-000046', 'VTE-2026-000046', 3, '2026-06-22 07:28:16'),
(198, 23, 'sortie', -3, 'Vente VTE-2026-000047', 'VTE-2026-000047', 1, '2026-06-27 00:12:53'),
(199, 45, 'sortie', -2, 'Vente VTE-2026-000047', 'VTE-2026-000047', 1, '2026-06-27 00:12:53'),
(200, 11, 'sortie', -3, 'Vente VTE-2026-000047', 'VTE-2026-000047', 1, '2026-06-27 00:12:53'),
(201, 34, 'sortie', -2, 'Vente VTE-2026-000047', 'VTE-2026-000047', 1, '2026-06-27 00:12:53'),
(202, 9, 'sortie', -1, 'Vente VTE-2026-000047', 'VTE-2026-000047', 1, '2026-06-27 00:12:53'),
(203, 35, 'sortie', -1, 'Vente VTE-2026-000048', 'VTE-2026-000048', 1, '2026-07-02 20:42:43'),
(204, 48, 'sortie', -1, 'Vente VTE-2026-000048', 'VTE-2026-000048', 1, '2026-07-02 20:42:43'),
(205, 29, 'sortie', -2, 'Vente VTE-2026-000048', 'VTE-2026-000048', 1, '2026-07-02 20:42:43'),
(206, 49, 'sortie', -1, 'Vente VTE-2026-000049', 'VTE-2026-000049', 1, '2026-07-03 02:42:13'),
(207, 9, 'sortie', -2, 'Vente VTE-2026-000049', 'VTE-2026-000049', 1, '2026-07-03 02:42:13'),
(208, 60, 'sortie', -1, 'Vente VTE-2026-000050', 'VTE-2026-000050', 3, '2026-07-04 17:48:34'),
(209, 48, 'sortie', -1, 'Vente VTE-2026-000050', 'VTE-2026-000050', 3, '2026-07-04 17:48:34'),
(210, 54, 'sortie', -3, 'Vente VTE-2026-000050', 'VTE-2026-000050', 3, '2026-07-04 17:48:34'),
(211, 3, 'sortie', -1, 'Vente VTE-2026-000050', 'VTE-2026-000050', 3, '2026-07-04 17:48:34'),
(212, 51, 'sortie', -1, 'Vente VTE-2026-000050', 'VTE-2026-000050', 3, '2026-07-04 17:48:34'),
(213, 31, 'sortie', -3, 'Vente VTE-2026-000052', 'VTE-2026-000052', 1, '2026-07-07 13:54:59'),
(214, 56, 'sortie', -3, 'Vente VTE-2026-000052', 'VTE-2026-000052', 1, '2026-07-07 13:54:59'),
(215, 5, 'sortie', -2, 'Vente VTE-2026-000052', 'VTE-2026-000052', 1, '2026-07-07 13:54:59'),
(216, 46, 'sortie', -2, 'Vente VTE-2026-000052', 'VTE-2026-000052', 1, '2026-07-07 13:54:59'),
(217, 45, 'sortie', -3, 'Vente VTE-2026-000053', 'VTE-2026-000053', 3, '2026-07-10 13:43:44'),
(218, 51, 'sortie', -2, 'Vente VTE-2026-000053', 'VTE-2026-000053', 3, '2026-07-10 13:43:44'),
(219, 30, 'sortie', -1, 'Vente VTE-2026-000053', 'VTE-2026-000053', 3, '2026-07-10 13:43:44'),
(220, 57, 'sortie', -2, 'Vente VTE-2026-000053', 'VTE-2026-000053', 3, '2026-07-10 13:43:44'),
(221, 1, 'sortie', -3, 'Vente VTE-2026-000053', 'VTE-2026-000053', 3, '2026-07-10 13:43:44'),
(222, 24, 'sortie', -2, 'Vente VTE-2026-000054', 'VTE-2026-000054', 3, '2026-07-10 22:51:34'),
(223, 48, 'sortie', -2, 'Vente VTE-2026-000054', 'VTE-2026-000054', 3, '2026-07-10 22:51:34'),
(224, 55, 'sortie', -2, 'Vente VTE-2026-000054', 'VTE-2026-000054', 3, '2026-07-10 22:51:34'),
(225, 39, 'sortie', -3, 'Vente VTE-2026-000054', 'VTE-2026-000054', 3, '2026-07-10 22:51:34'),
(226, 54, 'sortie', -1, 'Vente VTE-2026-000054', 'VTE-2026-000054', 3, '2026-07-10 22:51:34'),
(227, 18, 'sortie', -1, 'Vente VTE-2026-000055', 'VTE-2026-000055', 1, '2026-07-13 17:43:32'),
(228, 15, 'sortie', -2, 'Vente VTE-2026-000056', 'VTE-2026-000056', 1, '2026-07-16 01:10:52'),
(229, 22, 'sortie', -1, 'Vente VTE-2026-000056', 'VTE-2026-000056', 1, '2026-07-16 01:10:52'),
(230, 4, 'sortie', -1, 'Vente VTE-2026-000056', 'VTE-2026-000056', 1, '2026-07-16 01:10:52'),
(231, 18, 'sortie', -1, 'Vente VTE-2026-000056', 'VTE-2026-000056', 1, '2026-07-16 01:10:52'),
(232, 20, 'sortie', -2, 'Vente VTE-2026-000056', 'VTE-2026-000056', 1, '2026-07-16 01:10:52'),
(233, 10, 'sortie', -1, 'Vente VTE-2026-000057', 'VTE-2026-000057', 1, '2026-07-20 04:52:03'),
(234, 60, 'sortie', -1, 'Vente VTE-2026-000057', 'VTE-2026-000057', 1, '2026-07-20 04:52:03'),
(235, 26, 'sortie', -1, 'Vente VTE-2026-000058', 'VTE-2026-000058', 3, '2026-07-22 15:05:52'),
(236, 42, 'sortie', -3, 'Vente VTE-2026-000058', 'VTE-2026-000058', 3, '2026-07-22 15:05:52'),
(237, 9, 'sortie', -1, 'Vente VTE-2026-000059', 'VTE-2026-000059', 3, '2026-07-23 07:05:07'),
(238, 3, 'sortie', -2, 'Vente VTE-2026-000059', 'VTE-2026-000059', 3, '2026-07-23 07:05:07'),
(239, 55, 'sortie', -2, 'Vente VTE-2026-000059', 'VTE-2026-000059', 3, '2026-07-23 07:05:07'),
(240, 50, 'sortie', -1, 'Vente VTE-2026-000059', 'VTE-2026-000059', 3, '2026-07-23 07:05:07'),
(241, 36, 'sortie', -1, 'Vente VTE-2026-000059', 'VTE-2026-000059', 3, '2026-07-23 07:05:07'),
(242, 42, 'sortie', -2, 'Vente VTE-2026-000060', 'VTE-2026-000060', 1, '2026-07-23 16:01:16'),
(243, 54, 'sortie', -3, 'Vente VTE-2026-000060', 'VTE-2026-000060', 1, '2026-07-23 16:01:16'),
(244, 8, 'sortie', -2, 'Vente VTE-2026-000060', 'VTE-2026-000060', 1, '2026-07-23 16:01:16'),
(245, 18, 'sortie', -1, 'Vente VTE-2026-000061', 'VTE-2026-000061', 2, '2026-07-23 21:46:28'),
(246, 20, 'sortie', -3, 'Vente VTE-2026-000062', 'VTE-2026-000062', 2, '2026-07-25 10:22:43'),
(247, 24, 'sortie', -2, 'Vente VTE-2026-000063', 'VTE-2026-000063', 3, '2026-07-27 05:59:20'),
(248, 20, 'sortie', -3, 'Vente VTE-2026-000063', 'VTE-2026-000063', 3, '2026-07-27 05:59:20'),
(249, 7, 'sortie', -2, 'Vente VTE-2026-000063', 'VTE-2026-000063', 3, '2026-07-27 05:59:20'),
(250, 9, 'sortie', -1, 'Vente VTE-2026-000064', 'VTE-2026-000064', 2, '2026-07-27 12:06:53'),
(251, 8, 'sortie', -2, 'Vente VTE-2026-000064', 'VTE-2026-000064', 2, '2026-07-27 12:06:53'),
(252, 12, 'sortie', -3, 'Vente VTE-2026-000065', 'VTE-2026-000065', 1, '2026-07-27 22:49:19'),
(253, 21, 'sortie', -1, 'Vente VTE-2026-000065', 'VTE-2026-000065', 1, '2026-07-27 22:49:19'),
(254, 45, 'sortie', -1, 'Vente VTE-2026-000065', 'VTE-2026-000065', 1, '2026-07-27 22:49:19'),
(255, 40, 'sortie', -3, 'Vente VTE-2026-000065', 'VTE-2026-000065', 1, '2026-07-27 22:49:19'),
(256, 21, 'sortie', -2, 'Vente VTE-2026-000066', 'VTE-2026-000066', 3, '2026-07-28 08:06:02'),
(257, 26, 'sortie', -2, 'Vente VTE-2026-000066', 'VTE-2026-000066', 3, '2026-07-28 08:06:02'),
(258, 9, 'sortie', -2, 'Vente VTE-2026-000067', 'VTE-2026-000067', 3, '2026-08-02 05:22:51'),
(259, 16, 'sortie', -2, 'Vente VTE-2026-000067', 'VTE-2026-000067', 3, '2026-08-02 05:22:51'),
(260, 14, 'sortie', -3, 'Vente VTE-2026-000068', 'VTE-2026-000068', 1, '2026-08-05 09:08:01'),
(261, 21, 'sortie', -3, 'Vente VTE-2026-000068', 'VTE-2026-000068', 1, '2026-08-05 09:08:01'),
(262, 16, 'sortie', -1, 'Vente VTE-2026-000069', 'VTE-2026-000069', 1, '2026-08-05 18:27:21'),
(263, 11, 'sortie', -3, 'Vente VTE-2026-000069', 'VTE-2026-000069', 1, '2026-08-05 18:27:21'),
(264, 42, 'sortie', -1, 'Vente VTE-2026-000069', 'VTE-2026-000069', 1, '2026-08-05 18:27:21'),
(265, 45, 'sortie', -2, 'Vente VTE-2026-000069', 'VTE-2026-000069', 1, '2026-08-05 18:27:21'),
(266, 27, 'sortie', -3, 'Vente VTE-2026-000070', 'VTE-2026-000070', 2, '2026-08-11 01:22:08'),
(267, 26, 'sortie', -3, 'Vente VTE-2026-000071', 'VTE-2026-000071', 1, '2026-08-12 01:29:26'),
(268, 3, 'sortie', -1, 'Vente VTE-2026-000072', 'VTE-2026-000072', 1, '2026-08-13 20:31:40'),
(269, 34, 'sortie', -1, 'Vente VTE-2026-000072', 'VTE-2026-000072', 1, '2026-08-13 20:31:40'),
(270, 46, 'sortie', -2, 'Vente VTE-2026-000073', 'VTE-2026-000073', 1, '2026-08-15 23:20:49'),
(271, 39, 'sortie', -1, 'Vente VTE-2026-000073', 'VTE-2026-000073', 1, '2026-08-15 23:20:49'),
(272, 60, 'sortie', -3, 'Vente VTE-2026-000074', 'VTE-2026-000074', 1, '2026-08-20 20:56:22'),
(273, 27, 'sortie', -1, 'Vente VTE-2026-000075', 'VTE-2026-000075', 2, '2026-08-21 06:08:40'),
(274, 19, 'sortie', -1, 'Vente VTE-2026-000076', 'VTE-2026-000076', 3, '2026-08-21 07:10:22'),
(275, 2, 'sortie', -2, 'Vente VTE-2026-000078', 'VTE-2026-000078', 1, '2026-08-24 10:52:06'),
(276, 42, 'sortie', -2, 'Vente VTE-2026-000078', 'VTE-2026-000078', 1, '2026-08-24 10:52:06'),
(277, 18, 'sortie', -2, 'Vente VTE-2026-000078', 'VTE-2026-000078', 1, '2026-08-24 10:52:06'),
(278, 7, 'sortie', -2, 'Vente VTE-2026-000078', 'VTE-2026-000078', 1, '2026-08-24 10:52:06'),
(279, 36, 'sortie', -3, 'Vente VTE-2026-000078', 'VTE-2026-000078', 1, '2026-08-24 10:52:06'),
(280, 48, 'sortie', -3, 'Vente VTE-2026-000079', 'VTE-2026-000079', 1, '2026-08-25 13:38:56'),
(281, 7, 'sortie', -2, 'Vente VTE-2026-000080', 'VTE-2026-000080', 1, '2026-08-26 16:13:21'),
(282, 26, 'sortie', -2, 'Vente VTE-2026-000080', 'VTE-2026-000080', 1, '2026-08-26 16:13:21'),
(283, 51, 'sortie', -1, 'Vente VTE-2026-000080', 'VTE-2026-000080', 1, '2026-08-26 16:13:21'),
(284, 9, 'sortie', -3, 'Vente VTE-2026-000080', 'VTE-2026-000080', 1, '2026-08-26 16:13:21'),
(285, 4, 'sortie', -1, 'Vente VTE-2026-000080', 'VTE-2026-000080', 1, '2026-08-26 16:13:21'),
(286, 1, 'sortie', -1, 'Vente VTE-2026-000081', 'VTE-2026-000081', 2, '2026-08-29 01:05:14'),
(287, 20, 'sortie', -2, 'Vente VTE-2026-000081', 'VTE-2026-000081', 2, '2026-08-29 01:05:14'),
(288, 14, 'sortie', -3, 'Vente VTE-2026-000081', 'VTE-2026-000081', 2, '2026-08-29 01:05:14'),
(289, 43, 'sortie', -1, 'Vente VTE-2026-000081', 'VTE-2026-000081', 2, '2026-08-29 01:05:14'),
(290, 2, 'sortie', -1, 'Vente VTE-2026-000081', 'VTE-2026-000081', 2, '2026-08-29 01:05:14'),
(291, 8, 'sortie', -1, 'Vente VTE-2026-000082', 'VTE-2026-000082', 3, '2026-08-31 09:45:37'),
(292, 46, 'sortie', -3, 'Vente VTE-2026-000082', 'VTE-2026-000082', 3, '2026-08-31 09:45:37'),
(293, 2, 'sortie', -3, 'Vente VTE-2026-000082', 'VTE-2026-000082', 3, '2026-08-31 09:45:37'),
(294, 50, 'sortie', -2, 'Vente VTE-2026-000082', 'VTE-2026-000082', 3, '2026-08-31 09:45:37'),
(295, 56, 'sortie', -3, 'Vente VTE-2026-000084', 'VTE-2026-000084', 3, '2026-09-07 14:01:43'),
(296, 52, 'sortie', -3, 'Vente VTE-2026-000084', 'VTE-2026-000084', 3, '2026-09-07 14:01:43'),
(297, 58, 'sortie', -1, 'Vente VTE-2026-000084', 'VTE-2026-000084', 3, '2026-09-07 14:01:43'),
(298, 25, 'sortie', -1, 'Vente VTE-2026-000084', 'VTE-2026-000084', 3, '2026-09-07 14:01:43'),
(299, 26, 'sortie', -2, 'Vente VTE-2026-000084', 'VTE-2026-000084', 3, '2026-09-07 14:01:43'),
(300, 45, 'sortie', -3, 'Vente VTE-2026-000085', 'VTE-2026-000085', 2, '2026-09-08 11:39:27'),
(301, 59, 'sortie', -1, 'Vente VTE-2026-000085', 'VTE-2026-000085', 2, '2026-09-08 11:39:27'),
(302, 2, 'sortie', -1, 'Vente VTE-2026-000085', 'VTE-2026-000085', 2, '2026-09-08 11:39:27'),
(303, 39, 'sortie', -3, 'Vente VTE-2026-000086', 'VTE-2026-000086', 1, '2026-09-11 01:20:14'),
(304, 51, 'sortie', -3, 'Vente VTE-2026-000086', 'VTE-2026-000086', 1, '2026-09-11 01:20:14'),
(305, 43, 'sortie', -1, 'Vente VTE-2026-000086', 'VTE-2026-000086', 1, '2026-09-11 01:20:14'),
(306, 29, 'sortie', -1, 'Vente VTE-2026-000087', 'VTE-2026-000087', 1, '2026-09-13 00:08:47'),
(307, 22, 'sortie', -3, 'Vente VTE-2026-000087', 'VTE-2026-000087', 1, '2026-09-13 00:08:47'),
(308, 46, 'sortie', -1, 'Vente VTE-2026-000087', 'VTE-2026-000087', 1, '2026-09-13 00:08:47'),
(309, 48, 'sortie', -2, 'Vente VTE-2026-000087', 'VTE-2026-000087', 1, '2026-09-13 00:08:47'),
(310, 7, 'sortie', -3, 'Vente VTE-2026-000087', 'VTE-2026-000087', 1, '2026-09-13 00:08:47'),
(311, 51, 'sortie', -3, 'Vente VTE-2026-000089', 'VTE-2026-000089', 2, '2026-09-16 02:21:31'),
(312, 50, 'sortie', -3, 'Vente VTE-2026-000090', 'VTE-2026-000090', 1, '2026-09-17 18:22:10'),
(313, 34, 'sortie', -1, 'Vente VTE-2026-000090', 'VTE-2026-000090', 1, '2026-09-17 18:22:10'),
(314, 35, 'sortie', -1, 'Vente VTE-2026-000090', 'VTE-2026-000090', 1, '2026-09-17 18:22:10'),
(315, 39, 'sortie', -2, 'Vente VTE-2026-000090', 'VTE-2026-000090', 1, '2026-09-17 18:22:10'),
(316, 37, 'sortie', -1, 'Vente VTE-2026-000090', 'VTE-2026-000090', 1, '2026-09-17 18:22:10'),
(317, 26, 'sortie', -2, 'Vente VTE-2026-000091', 'VTE-2026-000091', 1, '2026-09-20 13:14:07'),
(318, 51, 'sortie', -1, 'Vente VTE-2026-000091', 'VTE-2026-000091', 1, '2026-09-20 13:14:07'),
(319, 34, 'sortie', -2, 'Vente VTE-2026-000091', 'VTE-2026-000091', 1, '2026-09-20 13:14:07'),
(320, 3, 'sortie', -1, 'Vente VTE-2026-000092', 'VTE-2026-000092', 2, '2026-09-21 11:10:57'),
(321, 26, 'sortie', -2, 'Vente VTE-2026-000092', 'VTE-2026-000092', 2, '2026-09-21 11:10:57'),
(322, 16, 'sortie', -2, 'Vente VTE-2026-000093', 'VTE-2026-000093', 3, '2026-09-24 13:10:56'),
(323, 36, 'sortie', -3, 'Vente VTE-2026-000093', 'VTE-2026-000093', 3, '2026-09-24 13:10:56'),
(324, 52, 'sortie', -2, 'Vente VTE-2026-000094', 'VTE-2026-000094', 3, '2026-09-26 06:53:45'),
(325, 39, 'sortie', -1, 'Vente VTE-2026-000094', 'VTE-2026-000094', 3, '2026-09-26 06:53:45'),
(326, 35, 'sortie', -1, 'Vente VTE-2026-000095', 'VTE-2026-000095', 1, '2026-09-27 00:57:32'),
(327, 39, 'sortie', -2, 'Vente VTE-2026-000096', 'VTE-2026-000096', 1, '2026-09-27 05:26:42'),
(328, 29, 'sortie', -2, 'Vente VTE-2026-000096', 'VTE-2026-000096', 1, '2026-09-27 05:26:42'),
(329, 46, 'sortie', -2, 'Vente VTE-2026-000096', 'VTE-2026-000096', 1, '2026-09-27 05:26:42'),
(330, 50, 'sortie', -2, 'Vente VTE-2026-000097', 'VTE-2026-000097', 2, '2026-09-27 21:47:49'),
(331, 38, 'sortie', -1, 'Vente VTE-2026-000097', 'VTE-2026-000097', 2, '2026-09-27 21:47:49'),
(332, 39, 'sortie', -1, 'Vente VTE-2026-000097', 'VTE-2026-000097', 2, '2026-09-27 21:47:49'),
(333, 12, 'sortie', -3, 'Vente VTE-2026-000098', 'VTE-2026-000098', 3, '2026-10-01 17:35:34'),
(334, 29, 'sortie', -3, 'Vente VTE-2026-000099', 'VTE-2026-000099', 2, '2026-10-02 03:21:30'),
(335, 36, 'sortie', -1, 'Vente VTE-2026-000100', 'VTE-2026-000100', 3, '2026-10-03 09:17:18'),
(336, 7, 'sortie', -2, 'Vente VTE-2026-000100', 'VTE-2026-000100', 3, '2026-10-03 09:17:18'),
(337, 42, 'sortie', -2, 'Vente VTE-2026-000100', 'VTE-2026-000100', 3, '2026-10-03 09:17:18'),
(338, 19, 'sortie', -2, 'Vente VTE-2026-000101', 'VTE-2026-000101', 2, '2026-10-03 12:43:40'),
(339, 57, 'sortie', -2, 'Vente VTE-2026-000101', 'VTE-2026-000101', 2, '2026-10-03 12:43:40'),
(340, 43, 'sortie', -2, 'Vente VTE-2026-000102', 'VTE-2026-000102', 1, '2026-10-05 00:37:47'),
(341, 30, 'sortie', -2, 'Vente VTE-2026-000102', 'VTE-2026-000102', 1, '2026-10-05 00:37:47'),
(342, 40, 'sortie', -3, 'Vente VTE-2026-000102', 'VTE-2026-000102', 1, '2026-10-05 00:37:47'),
(343, 8, 'sortie', -1, 'Vente VTE-2026-000102', 'VTE-2026-000102', 1, '2026-10-05 00:37:47'),
(344, 50, 'sortie', -3, 'Vente VTE-2026-000102', 'VTE-2026-000102', 1, '2026-10-05 00:37:47'),
(345, 35, 'sortie', -1, 'Vente VTE-2026-000103', 'VTE-2026-000103', 2, '2026-10-05 18:17:45'),
(346, 11, 'sortie', -2, 'Vente VTE-2026-000103', 'VTE-2026-000103', 2, '2026-10-05 18:17:45'),
(347, 39, 'sortie', -2, 'Vente VTE-2026-000103', 'VTE-2026-000103', 2, '2026-10-05 18:17:45'),
(348, 8, 'sortie', -1, 'Vente VTE-2026-000103', 'VTE-2026-000103', 2, '2026-10-05 18:17:45'),
(349, 9, 'sortie', -3, 'Vente VTE-2026-000104', 'VTE-2026-000104', 1, '2026-10-06 04:30:12'),
(350, 7, 'sortie', -3, 'Vente VTE-2026-000106', 'VTE-2026-000106', 2, '2026-10-06 20:58:01'),
(351, 11, 'sortie', -1, 'Vente VTE-2026-000106', 'VTE-2026-000106', 2, '2026-10-06 20:58:01'),
(352, 37, 'sortie', -1, 'Vente VTE-2026-000106', 'VTE-2026-000106', 2, '2026-10-06 20:58:01'),
(353, 20, 'sortie', -1, 'Vente VTE-2026-000106', 'VTE-2026-000106', 2, '2026-10-06 20:58:01'),
(354, 43, 'sortie', -2, 'Vente VTE-2026-000107', 'VTE-2026-000107', 1, '2026-10-07 22:30:35'),
(355, 22, 'sortie', -2, 'Vente VTE-2026-000107', 'VTE-2026-000107', 1, '2026-10-07 22:30:35'),
(356, 34, 'sortie', -3, 'Vente VTE-2026-000107', 'VTE-2026-000107', 1, '2026-10-07 22:30:35'),
(357, 7, 'sortie', -2, 'Vente VTE-2026-000107', 'VTE-2026-000107', 1, '2026-10-07 22:30:35'),
(358, 2, 'sortie', -3, 'Vente VTE-2026-000108', 'VTE-2026-000108', 3, '2026-10-08 13:17:01'),
(359, 36, 'sortie', -1, 'Vente VTE-2026-000108', 'VTE-2026-000108', 3, '2026-10-08 13:17:01'),
(360, 7, 'sortie', -3, 'Vente VTE-2026-000109', 'VTE-2026-000109', 2, '2026-10-08 15:58:03'),
(361, 52, 'sortie', -3, 'Vente VTE-2026-000109', 'VTE-2026-000109', 2, '2026-10-08 15:58:03'),
(362, 57, 'sortie', -3, 'Vente VTE-2026-000109', 'VTE-2026-000109', 2, '2026-10-08 15:58:03'),
(363, 30, 'sortie', -1, 'Vente VTE-2026-000110', 'VTE-2026-000110', 1, '2026-10-08 22:45:11'),
(364, 51, 'sortie', -1, 'Vente VTE-2026-000111', 'VTE-2026-000111', 1, '2026-10-09 05:22:49'),
(365, 50, 'sortie', -3, 'Vente VTE-2026-000111', 'VTE-2026-000111', 1, '2026-10-09 05:22:49'),
(366, 30, 'sortie', -2, 'Vente VTE-2026-000112', 'VTE-2026-000112', 1, '2026-10-09 05:43:25'),
(367, 2, 'sortie', -1, 'Vente VTE-2026-000112', 'VTE-2026-000112', 1, '2026-10-09 05:43:25'),
(368, 51, 'sortie', -2, 'Vente VTE-2026-000112', 'VTE-2026-000112', 1, '2026-10-09 05:43:25'),
(369, 35, 'sortie', -1, 'Vente VTE-2026-000112', 'VTE-2026-000112', 1, '2026-10-09 05:43:25'),
(370, 53, 'sortie', -1, 'Vente VTE-2026-000113', 'VTE-2026-000113', 1, '2026-10-09 16:24:29'),
(371, 31, 'sortie', -2, 'Vente VTE-2026-000114', 'VTE-2026-000114', 1, '2026-10-09 16:42:39'),
(372, 59, 'sortie', -2, 'Vente VTE-2026-000114', 'VTE-2026-000114', 1, '2026-10-09 16:42:39'),
(373, 33, 'sortie', -2, 'Vente VTE-2026-000114', 'VTE-2026-000114', 1, '2026-10-09 16:42:39'),
(374, 10, 'sortie', -3, 'Vente VTE-2026-000114', 'VTE-2026-000114', 1, '2026-10-09 16:42:39'),
(375, 52, 'sortie', -1, 'Vente VTE-2026-000114', 'VTE-2026-000114', 1, '2026-10-09 16:42:39'),
(376, 50, 'sortie', -3, 'Vente VTE-2026-000115', 'VTE-2026-000115', 2, '2026-10-09 22:55:15'),
(377, 43, 'sortie', -1, 'Vente VTE-2026-000116', 'VTE-2026-000116', 2, '2026-10-10 08:21:08'),
(378, 55, 'sortie', -1, 'Vente VTE-2026-000116', 'VTE-2026-000116', 2, '2026-10-10 08:21:08'),
(379, 36, 'sortie', -1, 'Vente VTE-2026-000116', 'VTE-2026-000116', 2, '2026-10-10 08:21:08'),
(380, 29, 'sortie', -3, 'Vente VTE-2026-000118', 'VTE-2026-000118', 2, '2026-10-11 06:18:54'),
(381, 18, 'sortie', -3, 'Vente VTE-2026-000119', 'VTE-2026-000119', 1, '2026-10-11 15:10:59'),
(382, 29, 'sortie', -2, 'Vente VTE-2026-000119', 'VTE-2026-000119', 1, '2026-10-11 15:10:59'),
(383, 50, 'sortie', -1, 'Vente VTE-2026-000119', 'VTE-2026-000119', 1, '2026-10-11 15:10:59'),
(384, 42, 'sortie', -3, 'Vente VTE-2026-000119', 'VTE-2026-000119', 1, '2026-10-11 15:10:59'),
(385, 5, 'sortie', -2, 'Vente VTE-2026-000119', 'VTE-2026-000119', 1, '2026-10-11 15:10:59'),
(386, 41, 'sortie', -1, 'Vente VTE-2026-000121', 'VTE-2026-000121', 2, '2026-10-11 20:13:50'),
(387, 29, 'sortie', -2, 'Vente VTE-2026-000122', 'VTE-2026-000122', 3, '2026-10-12 04:12:15'),
(388, 34, 'sortie', -2, 'Vente VTE-2026-000122', 'VTE-2026-000122', 3, '2026-10-12 04:12:15'),
(389, 43, 'sortie', -2, 'Vente VTE-2026-000122', 'VTE-2026-000122', 3, '2026-10-12 04:12:15'),
(390, 49, 'sortie', -3, 'Vente VTE-2026-000122', 'VTE-2026-000122', 3, '2026-10-12 04:12:15'),
(391, 50, 'sortie', -3, 'Vente VTE-2026-000123', 'VTE-2026-000123', 3, '2026-10-12 11:29:03'),
(392, 3, 'sortie', -1, 'Vente VTE-2026-000123', 'VTE-2026-000123', 3, '2026-10-12 11:29:03'),
(393, 30, 'sortie', -1, 'Vente VTE-2026-000123', 'VTE-2026-000123', 3, '2026-10-12 11:29:03'),
(394, 19, 'sortie', -3, 'Vente VTE-2026-000123', 'VTE-2026-000123', 3, '2026-10-12 11:29:03'),
(395, 35, 'sortie', -1, 'Vente VTE-2026-000123', 'VTE-2026-000123', 3, '2026-10-12 11:29:03'),
(396, 50, 'sortie', -2, 'Vente VTE-2026-000124', 'VTE-2026-000124', 3, '2026-10-12 12:28:52'),
(397, 3, 'sortie', -3, 'Vente VTE-2026-000124', 'VTE-2026-000124', 3, '2026-10-12 12:28:52'),
(398, 21, 'sortie', -2, 'Vente VTE-2026-000124', 'VTE-2026-000124', 3, '2026-10-12 12:28:52'),
(399, 37, 'sortie', -1, 'Vente VTE-2026-000124', 'VTE-2026-000124', 3, '2026-10-12 12:28:52'),
(400, 3, 'sortie', -3, 'Vente VTE-2026-000125', 'VTE-2026-000125', 1, '2026-10-13 01:49:21'),
(401, 20, 'sortie', -1, 'Vente VTE-2026-000125', 'VTE-2026-000125', 1, '2026-10-13 01:49:21'),
(402, 55, 'sortie', -3, 'Vente VTE-2026-000125', 'VTE-2026-000125', 1, '2026-10-13 01:49:21'),
(403, 2, 'sortie', -3, 'Vente VTE-2026-000125', 'VTE-2026-000125', 1, '2026-10-13 01:49:21'),
(404, 24, 'sortie', -1, 'Vente VTE-2026-000125', 'VTE-2026-000125', 1, '2026-10-13 01:49:21'),
(405, 36, 'sortie', -3, 'Vente VTE-2026-000126', 'VTE-2026-000126', 3, '2026-10-13 07:56:27'),
(406, 14, 'sortie', -3, 'Vente VTE-2026-000126', 'VTE-2026-000126', 3, '2026-10-13 07:56:27'),
(407, 56, 'sortie', -1, 'Vente VTE-2026-000126', 'VTE-2026-000126', 3, '2026-10-13 07:56:27'),
(408, 49, 'sortie', -1, 'Vente VTE-2026-000126', 'VTE-2026-000126', 3, '2026-10-13 07:56:27'),
(409, 41, 'sortie', -1, 'Vente VTE-2026-000127', 'VTE-2026-000127', 1, '2026-10-13 23:46:25'),
(410, 54, 'sortie', -2, 'Vente VTE-2026-000128', 'VTE-2026-000128', 3, '2026-10-14 03:30:02'),
(411, 3, 'sortie', -2, 'Vente VTE-2026-000128', 'VTE-2026-000128', 3, '2026-10-14 03:30:02'),
(412, 12, 'sortie', -2, 'Vente VTE-2026-000128', 'VTE-2026-000128', 3, '2026-10-14 03:30:02'),
(413, 15, 'sortie', -1, 'Vente VTE-2026-000128', 'VTE-2026-000128', 3, '2026-10-14 03:30:02'),
(414, 19, 'sortie', -2, 'Vente VTE-2026-000128', 'VTE-2026-000128', 3, '2026-10-14 03:30:02'),
(415, 50, 'sortie', -3, 'Vente VTE-2026-000130', 'VTE-2026-000130', 3, '2026-10-14 19:34:16'),
(416, 10, 'sortie', -3, 'Vente VTE-2026-000130', 'VTE-2026-000130', 3, '2026-10-14 19:34:16'),
(417, 8, 'sortie', -2, 'Vente VTE-2026-000131', 'VTE-2026-000131', 3, '2026-10-14 21:56:46'),
(418, 41, 'sortie', -1, 'Vente VTE-2026-000131', 'VTE-2026-000131', 3, '2026-10-14 21:56:46'),
(419, 3, 'sortie', -2, 'Vente VTE-2026-000132', 'VTE-2026-000132', 1, '2026-10-15 00:35:20'),
(420, 22, 'sortie', -2, 'Vente VTE-2026-000132', 'VTE-2026-000132', 1, '2026-10-15 00:35:20'),
(421, 39, 'sortie', -1, 'Vente VTE-2026-000132', 'VTE-2026-000132', 1, '2026-10-15 00:35:20'),
(422, 26, 'sortie', -3, 'Vente VTE-2026-000132', 'VTE-2026-000132', 1, '2026-10-15 00:35:20'),
(423, 60, 'sortie', -1, 'Vente VTE-2026-000133', 'VTE-2026-000133', 1, '2026-10-15 00:46:12'),
(424, 24, 'sortie', -1, 'Vente VTE-2026-000133', 'VTE-2026-000133', 1, '2026-10-15 00:46:12'),
(425, 51, 'sortie', -2, 'Vente VTE-2026-000133', 'VTE-2026-000133', 1, '2026-10-15 00:46:12'),
(426, 18, 'sortie', -1, 'Vente VTE-2026-000133', 'VTE-2026-000133', 1, '2026-10-15 00:46:12'),
(427, 54, 'sortie', -1, 'Vente VTE-2026-000134', 'VTE-2026-000134', 2, '2026-10-15 12:43:51'),
(428, 11, 'sortie', -3, 'Vente VTE-2026-000134', 'VTE-2026-000134', 2, '2026-10-15 12:43:51'),
(429, 54, 'sortie', -3, 'Vente VTE-2026-000135', 'VTE-2026-000135', 3, '2026-10-16 00:26:16'),
(430, 18, 'sortie', -1, 'Vente VTE-2026-000136', 'VTE-2026-000136', 1, '2026-10-17 17:20:24'),
(431, 51, 'sortie', -3, 'Vente VTE-2026-000136', 'VTE-2026-000136', 1, '2026-10-17 17:20:24'),
(432, 20, 'sortie', -2, 'Vente VTE-2026-000136', 'VTE-2026-000136', 1, '2026-10-17 17:20:24'),
(433, 30, 'sortie', -2, 'Vente VTE-2026-000137', 'VTE-2026-000137', 2, '2026-10-17 23:59:31'),
(434, 24, 'sortie', -2, 'Vente VTE-2026-000138', 'VTE-2026-000138', 1, '2026-10-18 04:48:27'),
(435, 22, 'sortie', -2, 'Vente VTE-2026-000139', 'VTE-2026-000139', 3, '2026-10-18 09:21:01'),
(436, 39, 'sortie', -1, 'Vente VTE-2026-000139', 'VTE-2026-000139', 3, '2026-10-18 09:21:01'),
(437, 31, 'sortie', -1, 'Vente VTE-2026-000139', 'VTE-2026-000139', 3, '2026-10-18 09:21:01'),
(438, 30, 'sortie', -3, 'Vente VTE-2026-000139', 'VTE-2026-000139', 3, '2026-10-18 09:21:01'),
(439, 15, 'sortie', -1, 'Vente VTE-2026-000139', 'VTE-2026-000139', 3, '2026-10-18 09:21:01'),
(440, 30, 'sortie', -1, 'Vente VTE-2026-000140', 'VTE-2026-000140', 1, '2026-10-20 20:41:40'),
(441, 16, 'sortie', -3, 'Vente VTE-2026-000140', 'VTE-2026-000140', 1, '2026-10-20 20:41:40'),
(442, 50, 'sortie', -3, 'Vente VTE-2026-000140', 'VTE-2026-000140', 1, '2026-10-20 20:41:40'),
(443, 21, 'sortie', -3, 'Vente VTE-2026-000141', 'VTE-2026-000141', 1, '2026-10-21 02:59:02'),
(444, 20, 'sortie', -3, 'Vente VTE-2026-000141', 'VTE-2026-000141', 1, '2026-10-21 02:59:02'),
(445, 19, 'sortie', -2, 'Vente VTE-2026-000142', 'VTE-2026-000142', 2, '2026-10-22 07:39:09'),
(446, 48, 'sortie', -2, 'Vente VTE-2026-000142', 'VTE-2026-000142', 2, '2026-10-22 07:39:09'),
(447, 15, 'sortie', -1, 'Vente VTE-2026-000142', 'VTE-2026-000142', 2, '2026-10-22 07:39:09'),
(448, 60, 'sortie', -2, 'Vente VTE-2026-000142', 'VTE-2026-000142', 2, '2026-10-22 07:39:09'),
(449, 41, 'sortie', -3, 'Vente VTE-2026-000142', 'VTE-2026-000142', 2, '2026-10-22 07:39:09'),
(450, 56, 'sortie', -3, 'Vente VTE-2026-000143', 'VTE-2026-000143', 1, '2026-10-23 07:41:06'),
(451, 57, 'sortie', -2, 'Vente VTE-2026-000143', 'VTE-2026-000143', 1, '2026-10-23 07:41:06'),
(452, 3, 'sortie', -1, 'Vente VTE-2026-000143', 'VTE-2026-000143', 1, '2026-10-23 07:41:06'),
(453, 16, 'sortie', -1, 'Vente VTE-2026-000143', 'VTE-2026-000143', 1, '2026-10-23 07:41:06'),
(454, 27, 'sortie', -1, 'Vente VTE-2026-000143', 'VTE-2026-000143', 1, '2026-10-23 07:41:06'),
(455, 49, 'sortie', -2, 'Vente VTE-2026-000144', 'VTE-2026-000144', 1, '2026-10-23 13:55:15'),
(456, 57, 'sortie', -1, 'Vente VTE-2026-000144', 'VTE-2026-000144', 1, '2026-10-23 13:55:15'),
(457, 27, 'sortie', -2, 'Vente VTE-2026-000144', 'VTE-2026-000144', 1, '2026-10-23 13:55:15'),
(458, 28, 'sortie', -1, 'Vente VTE-2026-000145', 'VTE-2026-000145', 3, '2026-10-24 05:11:48'),
(459, 10, 'sortie', -3, 'Vente VTE-2026-000145', 'VTE-2026-000145', 3, '2026-10-24 05:11:48'),
(460, 57, 'sortie', -2, 'Vente VTE-2026-000145', 'VTE-2026-000145', 3, '2026-10-24 05:11:48'),
(461, 40, 'sortie', -3, 'Vente VTE-2026-000145', 'VTE-2026-000145', 3, '2026-10-24 05:11:48'),
(462, 35, 'sortie', -2, 'Vente VTE-2026-000146', 'VTE-2026-000146', 3, '2026-10-24 07:37:59'),
(463, 40, 'sortie', -1, 'Vente VTE-2026-000147', 'VTE-2026-000147', 1, '2026-10-25 18:04:37'),
(464, 38, 'sortie', -1, 'Vente VTE-2026-000147', 'VTE-2026-000147', 1, '2026-10-25 18:04:37'),
(465, 33, 'sortie', -1, 'Vente VTE-2026-000147', 'VTE-2026-000147', 1, '2026-10-25 18:04:37'),
(466, 50, 'sortie', -3, 'Vente VTE-2026-000147', 'VTE-2026-000147', 1, '2026-10-25 18:04:37'),
(467, 27, 'sortie', -2, 'Vente VTE-2026-000148', 'VTE-2026-000148', 1, '2026-10-27 02:30:43'),
(468, 18, 'sortie', -3, 'Vente VTE-2026-000148', 'VTE-2026-000148', 1, '2026-10-27 02:30:43'),
(469, 36, 'sortie', -3, 'Vente VTE-2026-000148', 'VTE-2026-000148', 1, '2026-10-27 02:30:43'),
(470, 48, 'sortie', -3, 'Vente VTE-2026-000148', 'VTE-2026-000148', 1, '2026-10-27 02:30:43'),
(471, 43, 'sortie', -1, 'Vente VTE-2026-000148', 'VTE-2026-000148', 1, '2026-10-27 02:30:43'),
(472, 27, 'sortie', -2, 'Vente VTE-2026-000149', 'VTE-2026-000149', 3, '2026-10-27 05:04:59'),
(473, 18, 'sortie', -3, 'Vente VTE-2026-000149', 'VTE-2026-000149', 3, '2026-10-27 05:04:59'),
(474, 54, 'sortie', -1, 'Vente VTE-2026-000149', 'VTE-2026-000149', 3, '2026-10-27 05:04:59'),
(475, 54, 'sortie', -1, 'Vente VTE-2026-000150', 'VTE-2026-000150', 1, '2026-10-27 07:53:29'),
(476, 19, 'sortie', -2, 'Vente VTE-2026-000150', 'VTE-2026-000150', 1, '2026-10-27 07:53:29'),
(477, 26, 'entree', 32, 'Réapprovisionnement fournisseur', NULL, 3, '2026-04-30 17:03:07'),
(478, 19, 'entree', 40, 'Réapprovisionnement fournisseur', NULL, 1, '2026-08-30 01:43:35'),
(479, 49, 'entree', 18, 'Réapprovisionnement fournisseur', NULL, 2, '2026-06-04 23:25:06'),
(480, 29, 'ajustement', 4, 'Correction d\'inventaire', NULL, 3, '2026-10-09 19:00:44'),
(481, 9, 'entree', 58, 'Réapprovisionnement fournisseur', NULL, 2, '2026-05-06 08:58:18'),
(482, 39, 'entree', 46, 'Réapprovisionnement fournisseur', NULL, 1, '2026-07-02 18:56:55'),
(483, 36, 'ajustement', -2, 'Correction d\'inventaire', NULL, 2, '2026-04-29 01:18:04'),
(484, 48, 'ajustement', 2, 'Correction d\'inventaire', NULL, 1, '2026-05-06 01:24:46'),
(485, 36, 'entree', 15, 'Réapprovisionnement fournisseur', NULL, 2, '2026-05-07 08:48:16'),
(486, 36, 'entree', 12, 'Réapprovisionnement fournisseur', NULL, 3, '2026-09-15 15:40:10'),
(487, 26, 'entree', 37, 'Réapprovisionnement fournisseur', NULL, 3, '2026-09-22 16:17:47'),
(488, 15, 'entree', 26, 'Réapprovisionnement fournisseur', NULL, 3, '2026-06-19 23:04:05'),
(489, 55, 'entree', 29, 'Réapprovisionnement fournisseur', NULL, 2, '2026-08-07 16:17:49'),
(490, 4, 'entree', 37, 'Réapprovisionnement fournisseur', NULL, 3, '2026-10-25 09:50:35'),
(491, 42, 'entree', 51, 'Réapprovisionnement fournisseur', NULL, 3, '2026-07-24 01:29:55'),
(492, 29, 'entree', 44, 'Réapprovisionnement fournisseur', NULL, 1, '2026-08-02 10:45:31'),
(493, 8, 'entree', 11, 'Réapprovisionnement fournisseur', NULL, 2, '2026-07-20 11:54:03'),
(494, 9, 'entree', 28, 'Réapprovisionnement fournisseur', NULL, 1, '2026-06-24 11:24:50'),
(495, 39, 'entree', 22, 'Réapprovisionnement fournisseur', NULL, 3, '2026-09-28 11:35:43'),
(496, 27, 'entree', 54, 'Réapprovisionnement fournisseur', NULL, 3, '2026-06-12 22:28:26'),
(497, 57, 'entree', 50, 'Réapprovisionnement fournisseur', NULL, 1, '2026-05-19 02:05:16'),
(498, 21, 'ajustement', -4, 'Correction d\'inventaire', NULL, 3, '2026-10-08 17:21:56'),
(499, 5, 'entree', 40, 'Réapprovisionnement fournisseur', NULL, 2, '2026-08-24 05:49:38'),
(500, 39, 'entree', 41, 'Réapprovisionnement fournisseur', NULL, 1, '2026-09-24 18:26:53'),
(511, 33, 'sortie', -1, 'Vente VTE-2026-000151', 'VTE-2026-000151', 1, '2026-10-27 22:19:45');

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','vendeur') NOT NULL DEFAULT 'vendeur',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `role`, `is_active`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Aminata Koné', 'admin@salesstock.test', '2026-10-27 20:19:04', '$2y$12$2CDNjNqKdNIuBNcla9SQB.gmZK8da80qS7rau4O60i8VFDmC9fSza', 'admin', 1, NULL, '2026-10-27 20:19:04', '2026-10-27 20:19:04'),
(2, 'Yao Kouassi', 'vendeur@salesstock.test', '2026-10-27 20:19:05', '$2y$12$a0qH3wdooqR0GRv8mb4emu1hgwic/QLN7mzyEuEoHTReaNqEzD43C', 'vendeur', 1, NULL, '2026-10-27 20:19:05', '2026-10-27 20:19:05'),
(3, 'Fatou Diallo', 'vendeur2@salesstock.test', '2026-10-27 20:19:05', '$2y$12$PZ1DKCwSyMriw5tVt8Hb1uJ5LW6duEpUbjEpFubjYogypEhR8re0a', 'vendeur', 1, NULL, '2026-10-27 20:19:05', '2026-10-27 20:19:05');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Index pour la table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Index pour la table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `categories_slug_unique` (`slug`);

--
-- Index pour la table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `customers_email_unique` (`email`),
  ADD KEY `customers_name_index` (`name`);

--
-- Index pour la table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Index pour la table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Index pour la table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Index pour la table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  ADD KEY `personal_access_tokens_expires_at_index` (`expires_at`);

--
-- Index pour la table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `products_sku_unique` (`sku`),
  ADD KEY `products_name_index` (`name`),
  ADD KEY `products_category_id_index` (`category_id`),
  ADD KEY `products_is_active_index` (`is_active`);

--
-- Index pour la table `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sales_reference_unique` (`reference`),
  ADD KEY `sales_status_index` (`status`),
  ADD KEY `sales_customer_id_index` (`customer_id`),
  ADD KEY `sales_user_id_index` (`user_id`),
  ADD KEY `sales_payment_method_index` (`payment_method`),
  ADD KEY `sales_sold_at_index` (`sold_at`);

--
-- Index pour la table `sale_items`
--
ALTER TABLE `sale_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sale_items_sale_id_index` (`sale_id`),
  ADD KEY `sale_items_product_id_index` (`product_id`);

--
-- Index pour la table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Index pour la table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `settings_key_unique` (`key`);

--
-- Index pour la table `stock_movements`
--
ALTER TABLE `stock_movements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `stock_movements_user_id_foreign` (`user_id`),
  ADD KEY `stock_movements_product_id_index` (`product_id`),
  ADD KEY `stock_movements_type_index` (`type`),
  ADD KEY `stock_movements_created_at_index` (`created_at`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT pour la table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT pour la table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT pour la table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT pour la table `products`
--
ALTER TABLE `products`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT pour la table `sales`
--
ALTER TABLE `sales`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=154;

--
-- AUTO_INCREMENT pour la table `sale_items`
--
ALTER TABLE `sale_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=464;

--
-- AUTO_INCREMENT pour la table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT pour la table `stock_movements`
--
ALTER TABLE `stock_movements`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=512;

--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`);

--
-- Contraintes pour la table `sales`
--
ALTER TABLE `sales`
  ADD CONSTRAINT `sales_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `sales_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Contraintes pour la table `sale_items`
--
ALTER TABLE `sale_items`
  ADD CONSTRAINT `sale_items_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `sale_items_sale_id_foreign` FOREIGN KEY (`sale_id`) REFERENCES `sales` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `stock_movements`
--
ALTER TABLE `stock_movements`
  ADD CONSTRAINT `stock_movements_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `stock_movements_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
