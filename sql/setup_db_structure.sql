-- RESET DATABASE


SET FOREIGN_KEY_CHECKS = 0;

DROP DATABASE pizza;
CREATE DATABASE pizza;
USE pizza;

SET FOREIGN_KEY_CHECKS = 1;


-- CREATE TABLES


CREATE TABLE category (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50)
);


CREATE TABLE pizza (
  id SERIAL PRIMARY KEY,
  category_id BIGINT UNSIGNED NOT NULL,
  name VARCHAR(50),
  FOREIGN KEY(category_id) REFERENCES category(id)
);


CREATE TABLE item (
  id SERIAL PRIMARY KEY,
  pizza_id BIGINT UNSIGNED NOT NULL,
  size VARCHAR(50),
  price DECIMAL(10, 2),

  UNIQUE(pizza_id, size),
  FOREIGN KEY(pizza_id) references pizza(id)
);


CREATE TABLE ingredient (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50)
);


CREATE TABLE pizza_ingredient (
  pizza_id BIGINT UNSIGNED NOT NULL,
  ingredient_id BIGINT UNSIGNED NOT NULL,

  PRIMARY KEY (pizza_id, ingredient_id),
  FOREIGN KEY (pizza_id) REFERENCES pizza(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (ingredient_id) REFERENCES ingredient(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


CREATE TABLE ord (
  id SERIAL PRIMARY KEY,
  order_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  channel VARCHAR(50)
);


CREATE TABLE ord_item (
  ord_id BIGINT UNSIGNED NOT NULL,
  item_id BIGINT UNSIGNED NOT NULL,
  quantity INT UNSIGNED DEFAULT 1,

  PRIMARY KEY (item_id, ord_id),
  FOREIGN KEY (item_id) REFERENCES item(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (ord_id) REFERENCES ord(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


-- CREATE VIEWS 


-- This view shows full (almost)
-- info about each order
CREATE VIEW vw_ord_full AS
SELECT
  o.id AS order_id,
  o.order_time AS order_time,
  o.channel AS channel,
  SUM(oi.quantity) AS total_items,
  SUM(i.price * oi.quantity) AS bill
FROM ord_item oi
JOIN ord o ON oi.ord_id = o.id
JOIN item i ON oi.item_id = i.id
GROUP BY o.id
ORDER BY o.order_time DESC;


-- This view shows categories
-- with number of pizzas
-- which belong to this category
CREATE VIEW vw_pizza_count_by_category AS
SELECT
  c.id AS category_id,
  c.name AS category,
  COUNT(p.id) AS pizzas
FROM pizza p
RIGHT JOIN category c ON p.category_id = c.id
GROUP BY c.id
ORDER BY COUNT(p.id) DESC;


-- This view shows how many times
-- each pizza was ever ordered
CREATE VIEW vw_pizza_ord_count AS
SELECT
  p.id AS pizza_id,
  p.name AS pizza,
  SUM(oi.quantity) AS times_ordered
FROM ord_item oi
JOIN item i ON oi.item_id = i.id
JOIN pizza p ON i.pizza_id = p.id
GROUP BY p.id
ORDER BY SUM(oi.quantity) DESC;


-- CREATE INDEXES

CREATE INDEX idx_pizza_category ON pizza(category_id);
CREATE INDEX idx_item_pizza ON item(pizza_id);
CREATE INDEX idx_pizza_ingredient ON pizza_ingredient(ingredient_id);
CREATE INDEX idx_ord_time ON ord(order_time);
CREATE INDEX idx_ord_channel ON ord(channel);
CREATE INDEX idx_orditem_ord ON ord_item(ord_id);