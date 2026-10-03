CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN

    DECLARE
        @start_time DATETIME,
        @end_time DATETIME,
        @batch_start_time DATETIME,
        @batch_end_time DATETIME,
        @load_duration INT,
        @error_message NVARCHAR(4000),
        @error_number INT,
        @error_state INT;

    BEGIN TRY

        SET @batch_start_time = GETDATE();

        RAISERROR('================================================', 0, 1) WITH NOWAIT;
        RAISERROR('Loading Bronze Data', 0, 1) WITH NOWAIT;
        RAISERROR('================================================', 0, 1) WITH NOWAIT;


        /* =========================================================
           Load: bronze.aisles
           ========================================================= */

        SET @start_time = GETDATE();

        RAISERROR('>> Truncating Table: bronze.aisles', 0, 1) WITH NOWAIT;

        TRUNCATE TABLE bronze.aisles;

        RAISERROR('>> Inserting Data Into: bronze.aisles', 0, 1) WITH NOWAIT;

        INSERT INTO bronze.aisles
        SELECT *
        FROM dq.raw_aisles_messy;

        SET @end_time = GETDATE();

        SET @load_duration = DATEDIFF(SECOND, @start_time, @end_time);

        RAISERROR('>> Load Duration: %d seconds', 0, 1, @load_duration) WITH NOWAIT;


        /* =========================================================
           Load: bronze.departments
           ========================================================= */

        SET @start_time = GETDATE();

        RAISERROR('>> Truncating Table: bronze.departments', 0, 1) WITH NOWAIT;

        TRUNCATE TABLE bronze.departments;

        RAISERROR('>> Inserting Data Into: bronze.departments', 0, 1) WITH NOWAIT;

        INSERT INTO bronze.departments
        SELECT *
        FROM dq.raw_departments_messy;

        SET @end_time = GETDATE();

        SET @load_duration = DATEDIFF(SECOND, @start_time, @end_time);

        RAISERROR('>> Load Duration: %d seconds', 0, 1, @load_duration) WITH NOWAIT;


        /* =========================================================
           Load: bronze.order_products_prior
           ========================================================= */

        SET @start_time = GETDATE();

        RAISERROR('>> Truncating Table: bronze.order_products_prior', 0, 1) WITH NOWAIT;

        TRUNCATE TABLE bronze.order_products_prior;

        RAISERROR('>> Inserting Data Into: bronze.order_products_prior', 0, 1) WITH NOWAIT;

        INSERT INTO bronze.order_products_prior
        SELECT *
        FROM dq.raw_order_products_prior_messy;

        SET @end_time = GETDATE();

        SET @load_duration = DATEDIFF(SECOND, @start_time, @end_time);

        RAISERROR('>> Load Duration: %d seconds', 0, 1, @load_duration) WITH NOWAIT;


        /* =========================================================
           Load: bronze.order_products_train
           ========================================================= */

        SET @start_time = GETDATE();

        RAISERROR('>> Truncating Table: bronze.order_products_train', 0, 1) WITH NOWAIT;

        TRUNCATE TABLE bronze.order_products_train;

        RAISERROR('>> Inserting Data Into: bronze.order_products_train', 0, 1) WITH NOWAIT;

        INSERT INTO bronze.order_products_train
        SELECT *
        FROM dq.raw_order_products_train_messy;

        SET @end_time = GETDATE();

        SET @load_duration = DATEDIFF(SECOND, @start_time, @end_time);

        RAISERROR('>> Load Duration: %d seconds', 0, 1, @load_duration) WITH NOWAIT;


        /* =========================================================
           Load: bronze.orders
           ========================================================= */

        SET @start_time = GETDATE();

        RAISERROR('>> Truncating Table: bronze.orders', 0, 1) WITH NOWAIT;

        TRUNCATE TABLE bronze.orders;

        RAISERROR('>> Inserting Data Into: bronze.orders', 0, 1) WITH NOWAIT;

        INSERT INTO bronze.orders
        SELECT *
        FROM dq.raw_orders_messy;

        SET @end_time = GETDATE();

        SET @load_duration = DATEDIFF(SECOND, @start_time, @end_time);

        RAISERROR('>> Load Duration: %d seconds', 0, 1, @load_duration) WITH NOWAIT;


        /* =========================================================
           Load: bronze.products
           ========================================================= */

        SET @start_time = GETDATE();

        RAISERROR('>> Truncating Table: bronze.products', 0, 1) WITH NOWAIT;

        TRUNCATE TABLE bronze.products;

        RAISERROR('>> Inserting Data Into: bronze.products', 0, 1) WITH NOWAIT;

        INSERT INTO bronze.products
        SELECT *
        FROM dq.raw_products_messy;

        SET @end_time = GETDATE();

        SET @load_duration = DATEDIFF(SECOND, @start_time, @end_time);

        RAISERROR('>> Load Duration: %d seconds', 0, 1, @load_duration) WITH NOWAIT;


        /* =========================================================
           Batch Completion
           ========================================================= */

        SET @batch_end_time = GETDATE();

        SET @load_duration =
            DATEDIFF(SECOND, @batch_start_time, @batch_end_time);

        RAISERROR('==========================================', 0, 1) WITH NOWAIT;
        RAISERROR('Loading Bronze Data is Completed', 0, 1) WITH NOWAIT;
        RAISERROR('   - Total Load Duration: %d seconds', 0, 1, @load_duration) WITH NOWAIT;
        RAISERROR('==========================================', 0, 1) WITH NOWAIT;


    END TRY

    BEGIN CATCH

        SELECT
            @error_message = ERROR_MESSAGE(),
            @error_number = ERROR_NUMBER(),
            @error_state = ERROR_STATE();

        RAISERROR('==========================================', 0, 1) WITH NOWAIT;
        RAISERROR('ERROR OCCURRED DURING LOADING BRONZE DATA', 0, 1) WITH NOWAIT;

        RAISERROR('Error Message: %s', 0, 1, @error_message) WITH NOWAIT;
        RAISERROR('Error Number: %d', 0, 1, @error_number) WITH NOWAIT;
        RAISERROR('Error State: %d', 0, 1, @error_state) WITH NOWAIT;

        RAISERROR('==========================================', 0, 1) WITH NOWAIT;

    END CATCH

END;
