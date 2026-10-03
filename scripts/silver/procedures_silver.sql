CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN
    DECLARE @start_time DATETIME2,
            @end_time DATETIME2,
            @duration INT,
            @error_number INT,
            @error_message NVARCHAR(4000),
            @error_line INT;

    BEGIN TRY

        RAISERROR('================================================', 0, 1) WITH NOWAIT;
        RAISERROR('Loading Silver Layer', 0, 1) WITH NOWAIT;
        RAISERROR('================================================', 0, 1) WITH NOWAIT;


        -- =====================================================
        -- Load silver.aisles
        -- =====================================================

        SET @start_time = GETDATE();

        RAISERROR('>> Loading silver.aisles', 0, 1) WITH NOWAIT;

        TRUNCATE TABLE silver.aisles;

        INSERT INTO silver.aisles
        (
            aisle_id,
            aisle
        )
        SELECT ba.aisle_id,
               Upper(trim(ra.aisle)) as aisle
        FROM bronze.aisles ba
        JOIN dbo.raw_aisles ra
            ON ba.aisle_id = ra.aisle_id;

        SET @end_time = GETDATE();
        SET @duration = DATEDIFF(SECOND, @start_time, @end_time);

        RAISERROR('>> silver.aisles Load Duration: %d seconds', 0, 1, @duration) WITH NOWAIT;


        -- =====================================================
        -- Load silver.departments
        -- =====================================================

        SET @start_time = GETDATE();

        RAISERROR('>> Loading silver.departments', 0, 1) WITH NOWAIT;

        TRUNCATE TABLE silver.departments;

        INSERT INTO silver.departments
        (
            department_id,
            department
        )
        SELECT bd.department_id, 
               Upper(trim(rd.department)) as department
        FROM bronze.departments bd
        JOIN dbo.raw_departments rd
            ON bd.department_id = rd.department_id;

        SET @end_time = GETDATE();
        SET @duration = DATEDIFF(SECOND, @start_time, @end_time);

        RAISERROR('>> silver.departments Load Duration: %d seconds', 0, 1, @duration) WITH NOWAIT;


        -- =====================================================
        -- Load silver.order_products_prior
        -- =====================================================

        SET @start_time = GETDATE();

        RAISERROR('>> Loading silver.order_products_prior', 0, 1) WITH NOWAIT;

        TRUNCATE TABLE silver.order_products_prior;

        INSERT INTO silver.order_products_prior
        (
            order_id,
            product_id,
            add_to_cart_order,
            reordered
        )
        SELECT DISTINCT
            op.order_id,
            op.product_id,
            CASE 
                WHEN op.add_to_cart_order >0 
                THEN op.add_to_cart_order
                ELSE NULL
                END AS add_to_cart_order,
            CASE
                WHEN op.reordered IN (0, 1)
                THEN op.reordered
                ELSE NULL
            END AS reordered
        FROM bronze.order_products_prior AS op
        INNER JOIN bronze.orders AS o
            ON o.order_id = op.order_id
        INNER JOIN bronze.products AS p
            ON p.product_id = op.product_id;

        SET @end_time = GETDATE();
        SET @duration = DATEDIFF(SECOND, @start_time, @end_time);

        RAISERROR('>> silver.order_products_prior Load Duration: %d seconds', 0, 1, @duration) WITH NOWAIT;


        -- =====================================================
        -- Load silver.order_products_train
        -- =====================================================

        SET @start_time = GETDATE();

        RAISERROR('>> Loading silver.order_products_train', 0, 1) WITH NOWAIT;

        TRUNCATE TABLE silver.order_products_train;

        INSERT INTO silver.order_products_train
        (
            order_id,
            product_id,
            add_to_cart_order,
            reordered
        )
        SELECT DISTINCT
            ot.order_id,
            ot.product_id,
            CASE 
                WHEN ot.add_to_cart_order >0 
                THEN ot.add_to_cart_order
                ELSE NULL
                END AS add_to_cart_order,
            CASE
                WHEN ot.reordered IN (0, 1)
                THEN ot.reordered
                ELSE NULL
            END AS reordered
        FROM bronze.order_products_train AS ot
        INNER JOIN bronze.orders AS o
            ON o.order_id = ot.order_id
        INNER JOIN bronze.products AS p
            ON p.product_id = ot.product_id;

        SET @end_time = GETDATE();
        SET @duration = DATEDIFF(SECOND, @start_time, @end_time);

        RAISERROR('>> silver.order_products_train Load Duration: %d seconds', 0, 1, @duration) WITH NOWAIT;


        -- =====================================================
        -- Load silver.orders
        -- =====================================================

        SET @start_time = GETDATE();

        RAISERROR('>> Loading silver.orders', 0, 1) WITH NOWAIT;

        TRUNCATE TABLE silver.orders;

        INSERT INTO silver.orders
        (
            order_id,
            user_id,
            eval_set,
            order_number,
            order_dow,
            order_hour_of_day,
            days_since_prior_order
        )
        SELECT DISTINCT
            o.order_id,
            o.user_id,
            CASE
                WHEN EXISTS (
                    SELECT 1
                    FROM bronze.order_products_prior AS op
                    WHERE op.order_id = o.order_id
                ) THEN 'prior' 
                WHEN EXISTS (
                    SELECT 1
                    FROM bronze.order_products_train AS ot
                    WHERE ot.order_id = o.order_id
                ) THEN 'train'
                ELSE 'test'
            END AS eval_set, 
            CASE 
            WHEN o.order_number >0 
            THEN o.order_number 
            ELSE NULL
            END AS order_number,
            CASE
                WHEN o.order_dow BETWEEN 0 AND 6
                THEN o.order_dow
                ELSE NULL
            END AS order_dow,
            CASE
                WHEN o.order_hour_of_day BETWEEN 0 AND 23
                THEN o.order_hour_of_day
                ELSE NULL
            END AS order_hour_of_day,
            CASE
                WHEN o.days_since_prior_order >= 0
                THEN o.days_since_prior_order
                ELSE NULL
            END AS days_since_prior_order
        FROM bronze.orders AS o;

        SET @end_time = GETDATE();
        SET @duration = DATEDIFF(SECOND, @start_time, @end_time);

        RAISERROR('>> silver.orders Load Duration: %d seconds', 0, 1, @duration) WITH NOWAIT;


        -- =====================================================
        -- Load silver.products
        -- =====================================================

        SET @start_time = GETDATE();

        RAISERROR('>> Loading silver.products', 0, 1) WITH NOWAIT;

        TRUNCATE TABLE silver.products;

        INSERT INTO silver.products
        (
            product_id,
            product_name,
            aisle_id,
            department_id
        )
        SELECT DISTINCT 
            ABS(bp.product_id) AS product_id,
            UPPER(TRIM(rp.product_name)) AS product_name,
            rp.aisle_id,
            rp.department_id
        FROM bronze.products bp
        JOIN dbo.raw_products rp
            ON bp.product_id = rp.product_id;

        SET @end_time = GETDATE();
        SET @duration = DATEDIFF(SECOND, @start_time, @end_time);

        RAISERROR('>> silver.products Load Duration: %d seconds', 0, 1, @duration) WITH NOWAIT;


        -- =====================================================
        -- Completion
        -- =====================================================

        RAISERROR('================================================', 0, 1) WITH NOWAIT;
        RAISERROR('Silver Layer Loaded Successfully', 0, 1) WITH NOWAIT;
        RAISERROR('================================================', 0, 1) WITH NOWAIT;


    END TRY

    BEGIN CATCH

        SET @error_number = ERROR_NUMBER();
        SET @error_message = ERROR_MESSAGE();
        SET @error_line = ERROR_LINE();

        RAISERROR('================================================', 0, 1) WITH NOWAIT;
        RAISERROR('ERROR OCCURRED WHILE LOADING SILVER LAYER', 0, 1) WITH NOWAIT;
        RAISERROR('Error Number: %d', 0, 1, @error_number) WITH NOWAIT;
        RAISERROR('Error Message: %s', 0, 1, @error_message) WITH NOWAIT;
        RAISERROR('Error Line: %d', 0, 1, @error_line) WITH NOWAIT;
        RAISERROR('================================================', 0, 1) WITH NOWAIT;

        THROW;

    END CATCH
END;
GO
