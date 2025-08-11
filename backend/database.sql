CREATE TABLE `products` (
  `id` integer PRIMARY KEY,
  `category_id` integer,
  `name` varchar(255),
  `brand` varchar(255),
  `materials` varchar(255),
  `fit` varchar(255),
  `color` varchar(255),
  `image` varchar(255),
  `price` float
);

CREATE TABLE `categories` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `category` varchar(255)
);

CREATE TABLE `dimensions` (
  `product_id` integer PRIMARY KEY,
  `width` integer,
  `height` integer,
  `length` integer
);

ALTER TABLE `dimensions` ADD FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

ALTER TABLE `products` ADD FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`);
