USE instacart_dw;
GO

-- =====================================================
-- Create bronze Tables
-- =====================================================

-- bronze Aisles
IF OBJECT_ID('bronze.aisles', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.aisles;
END;
GO

CREATE TABLE bronze.aisles
(
    aisle_id INT,
    aisle NVARCHAR(250)
);
GO


-- bronze Departments
IF OBJECT_ID('bronze.departments', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.departments;
END;
GO

CREATE TABLE bronze.departments
(
    department_id INT,
    department NVARCHAR(250)
);
GO


-- bronze Order Products Prior
IF OBJECT_ID('bronze.order_products_prior', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.order_products_prior;
END;
GO

CREATE TABLE bronze.order_products_prior
(
    order_id INT,
    product_id INT,
    add_to_cart_order INT,
    reordered INT
);
GO


-- bronze Order Products Train
IF OBJECT_ID('bronze.order_products_train', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.order_products_train;
END;
GO

CREATE TABLE bronze.order_products_train
(
    order_id INT,
    product_id INT,
    add_to_cart_order INT,
    reordered INT
);
GO


-- bronze Orders
IF OBJECT_ID('bronze.orders', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.orders;
END;
GO

CREATE TABLE bronze.orders
(
    order_id INT,
    user_id INT,
    eval_set VARCHAR(20),
    order_number INT,
    order_dow INT,
    order_hour_of_day INT,
    days_since_prior_order DECIMAL(10,1) NULL
);
GO


-- bronze Products
IF OBJECT_ID('bronze.products', 'U') IS NOT NULL
BEGIN
    DROP TABLE bronze.products;
END;
GO

CREATE TABLE bronze.products
(
    product_id INT,
    product_name NVARCHAR(500),
    aisle_id INT,
    department_id INT
);
GO
