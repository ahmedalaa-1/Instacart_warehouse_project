create or alter procedure silver.load_silver as
begin
    TRUNCATE TABLE silver.crm_cust_info;
    insert into silver.crm_cust_info(
    cst_id
          ,cst_key
          ,cst_firstname
          ,cst_lastname
          ,cst_marital_status
          ,cst_gndr
          ,cst_create_date)
    select 
    cst_id,
    cst_key,
    trim(cst_firstname) as cst_firstname,
    trim(cst_lastname) as cst_lastname,
    case when Upper(trim(cst_marital_status)) = 'M' then 'Married'
	     when Upper(trim(cst_marital_status)) = 'S' then 'Single'
	     else 'N/A'
	     end as cst_marital_status,
         case when Upper(trim(cst_gndr)) = 'M' then 'Male'
	     when Upper(trim(cst_gndr)) = 'F' then 'Female'
	     else 'N/A'
	     end as cst_gndr,
    cst_create_date
    from (
    select *,row_number() over (partition by cst_id order by cst_create_date desc) as flag 
    from bronze.crm_cust_info
    where cst_id is not null
    ) as t
    where flag = 1;

    TRUNCATE TABLE silver.crm_prd_info;
    insert into silver.crm_prd_info
        (prd_id,
        cat_id,
        prd_key,
        prd_nm,
        prd_cost,
        prd_line,
        prd_start_dt,
        prd_end_dt)


    select
           prd_id
          ,REPLACE(SUBSTRING(prd_key, 1, 5), '-','_') AS cat_id
          ,REPLACE(SUBSTRING(prd_key, 7, LEN(prd_key)), '-','_') AS prd_key
          ,prd_nm
          ,isnull(prd_cost, 0) as prd_cost
          ,CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
          WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
          WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'other Sales'
          WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
          ELSE 'n/a'
          END as prd_line
          ,cast(prd_start_dt as date) as prd_start_dt
          ,cast(DATEADD(DAY,-1,LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt))AS date) as prd_end_dt
    from   bronze.crm_prd_info;

    TRUNCATE TABLE silver.crm_sales_details;
    insert into silver.crm_sales_details
    (
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
    )
    SELECT sls_ord_num
          ,sls_prd_key
          ,sls_cust_id
          ,case when sls_order_dt =0 or len(sls_order_dt) <> 8 then null
          else cast(cast(sls_order_dt as varchar) as date)
          end as sls_order_date,
          case when sls_ship_dt =0 or len(sls_ship_dt) <> 8 then null
          else cast(cast(sls_ship_dt as varchar) as date)
          end as sls_ship_date
          ,case when sls_due_dt =0 or len(sls_due_dt) <> 8 then null
          else cast(cast(sls_due_dt as varchar) as date)
          end as sls_due_date
          ,CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
           THEN sls_quantity * ABS(sls_price)
           ELSE sls_sales
           END AS sls_sales,
           sls_quantity,
           CASE WHEN sls_price iS NULL OR sls_price <= 0
           THEN sls_sales/ NULLIF(sls_quantity,0)
           ELSE sls_price
           end as sls_price
      FROM bronze.crm_sales_details;

      TRUNCATE TABLE silver.erp_cust_az12;
      INSERT INTO silver.erp_cust_az12 (cid,bdate,gen)
    SELECT
    CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
    ELSE cid
    END AS cid,
    CASE WHEN bdate > GETDATE() THEN NULL
    ELSE bdate
    END AS bdate,
    CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
    WHEN UPPER(TRIM(gen) ) IN ('M', 'MALE') THEN 'Male'
    ELSE 'n/a'
    END AS gen
    from bronze.erp_cust_az12;

    TRUNCATE TABLE silver.erp_loc_a101;
    INSERT INTO silver.erp_loc_a101
    (cid, cntry)
    SELECT
    REPLACE(cid, '-','') cid,
    CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
    WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
    WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
    ELSE TRIM(cntry)
    END AS cntry
    FROM bronze.erp_loc_a101;


    TRUNCATE TABLE silver.erp_px_cat_g1v2;
    INSERT INTO silver.erp_px_cat_g1v2
    (id, cat, subcat, maintenance)
    SELECT
    id,
    cat,
    subcat,
    maintenance
    FROM bronze.erp_px_cat_g1v2;
end
