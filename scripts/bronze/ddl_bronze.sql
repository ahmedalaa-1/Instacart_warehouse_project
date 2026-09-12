-- creating the tables 

create table bronze.crm_cust_info
(
    cst_id int,
    cst_key varchar(50),
    cst_firstname varchar(100),
    cst_lastname varchar(100),
    cst_marital_status varchar(1),
    cst_gndr varchar(1),
    cst_create_date date
);
go
create table bronze.crm_prd_info
(
    prd_id	int,
    prd_key	varchar(100),
    prd_nm	varchar(100),
    prd_cost decimal(10,2),
    prd_line	varchar(10),
    prd_start_dt	date,
    prd_end_dt	date
); 
go
create table bronze.crm_sales_details
(
    sls_ord_num	varchar(100),
    sls_prd_key	varchar(100),
    sls_cust_id	int,
    sls_order_dt int,
    sls_ship_dt	int,
    sls_due_dt	int,
    sls_sales	decimal(10,2),
    sls_quantity	int,
    sls_price	decimal(10,2)
); 
go
create table bronze.erp_cust_az12
(
    CID varchar(50),	
    BDATE date,	
    GEN varchar(20),
); 
go
create table bronze.erp_loc_a101
(
    CID varchar(100),	
   CNTRY varchar(100)
);
go
create table bronze.erp_px_cat_g1V2
(
    ID	varchar(50),
    CAT	varchar(100),
    SUBCAT	varchar(100),
    MAINTENANCE	varchar(20)
);


