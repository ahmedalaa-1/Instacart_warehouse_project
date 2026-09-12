/*
=======================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
====================================================
Script Purpose:
This stored procedure loads data into the 'bronze' schema from external CSV files.
It performs the following actions:
- Truncates the bronze tables before loading data.
- Uses the BULK INSERT' command to load data from csv Files to bronze tables.
=========================================
Parameters:
None.

This stored procedure does not accept any parameters or return any values.

Usage Example:
EXEC bronze.load_bronze;
=============================================================
*/
create or alter procedure bronze.load_bronze as
begin
	begin try

		declare @starttime datetime ,@endtime datetime,@batch_starttime datetime,@batch_endtime datetime;

		set @batch_starttime = getdate();

		print '=============================================';
		print 'Loading bronze layer...';
		print '=============================================';
	
		print '=============================================';
		print 'Loading CRM tables...';
		print '=============================================';

		print '---------------------------------------------';
		print 'truncating & inserting data into bronze.crm_cust_info...';
		print '---------------------------------------------';

		set @starttime = getdate();
		truncate table bronze.crm_cust_info;
		bulk insert bronze.crm_cust_info 
		from 'B:\baraa sql\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		with 
		( firstrow = 2,
		fieldterminator = ',',
		tablock
		);
		set @endtime = getdate();
		PRINT '>> Load Duration: '+ CAST(DATEDIFF(second, @starttime, @endtime) AS NVARCHAR) + ' seconds';
	
		print '---------------------------------------------';
		print 'truncating & inserting data into bronze.crm_prd_info...';
		print '---------------------------------------------';

		set @starttime = getdate();
		truncate table bronze.crm_prd_info;
		bulk insert bronze.crm_prd_info 
		from 'B:\baraa sql\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		with 
		( firstrow = 2,
		fieldterminator = ',',
		tablock
		);
		set @endtime = getdate();
	
		PRINT '>> Load Duration: '+ CAST(DATEDIFF(second, @starttime, @endtime) AS NVARCHAR) + ' seconds';
	
		print '---------------------------------------------';
		print 'truncating & inserting data into bronze.crm_sales_details...';
		print '---------------------------------------------';
	
		set @starttime = getdate();
		truncate table bronze.crm_sales_details;
		bulk insert bronze.crm_sales_details 
		from 'B:\baraa sql\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		with 
		( firstrow = 2,
		fieldterminator = ',',
		tablock
		);
		set @endtime = getdate();

		PRINT '>> Load Duration: '+ CAST(DATEDIFF(second, @starttime, @endtime) AS NVARCHAR) + ' seconds';

		print '=============================================';
		print 'Loading ERP tables...';
		print '=============================================';

		print '---------------------------------------------';
		print 'truncating & inserting data into bronze.erp_cust_az12...';
		print '---------------------------------------------';

		set @starttime = getdate();
		truncate table bronze.erp_cust_az12;
		bulk insert bronze.erp_cust_az12 
		from 'B:\baraa sql\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		with 
		( firstrow = 2,
		fieldterminator = ',',
		tablock
		);
		set @endtime = getdate();
	
		PRINT '>> Load Duration: '+ CAST(DATEDIFF(second, @starttime, @endtime) AS NVARCHAR) + ' seconds';
	
		print '---------------------------------------------';
		print 'truncating & inserting data into bronze.erp_loc_a101...';
		print '---------------------------------------------';

		set @starttime = getdate();
		truncate table bronze.erp_loc_a101;
		bulk insert bronze.erp_loc_a101 
		from 'B:\baraa sql\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		with 
		( firstrow = 2,
		fieldterminator = ',',
		tablock
		);
		set @endtime = getdate();

		PRINT '>> Load Duration: '+ CAST(DATEDIFF(second, @starttime, @endtime) AS NVARCHAR) + ' seconds';

		print '---------------------------------------------';
		print 'truncating & inserting data into bronze.erp_PX_CAT_G1V2...';
		print '---------------------------------------------';

		set @starttime = getdate();
		truncate table bronze.erp_px_cat_g1V2;
		bulk insert bronze.erp_px_cat_g1V2 
		from 'B:\baraa sql\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		with 
		( firstrow = 2,
		fieldterminator = ',',
		tablock
		);
		set @endtime = getdate();
	
		PRINT '>> Load Duration: '+ CAST(DATEDIFF(second, @starttime, @endtime) AS NVARCHAR) + ' seconds';

		set @batch_endtime = getdate();

		PRINT '=============================================';
		PRINT 'Bronze layer load completed successfully!';
		PRINT '>> Batch Duration: '+ CAST(DATEDIFF(second, @batch_starttime, @batch_endtime) AS NVARCHAR) + ' seconds';
		PRINT '=============================================';
	end try 
	begin catch
		PRINT '=============================================';
		PRINT 'Error occurred during bronze layer load!';
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT '=============================================';
	end catch
end
