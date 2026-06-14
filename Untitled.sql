CREATE DATABASE DATAXSNOWFLAKE
CREATE SCHEMA BRONZE
CREATE OR REPLACE FILE FORMAT ff_csv
TYPE=CSV
SKIP_HEADER=1
FIELD_DELIMITER=','
TRIM_SPACE=TRUE

CREATE OR REPLACE STAGE stg_orders
FILE_FORMAT=ff_csv;
CREATE OR REPLACE STAGE stg_customers
FILE_FORMAT=ff_csv;

-- Create Table orders_raw
CREATE OR REPLACE TABLE orders_raw (
  order_id NUMBER,
  customer_id STRING,
  product_id STRING,
  order_ts TIMESTAMP_NTZ,
  order_amount NUMBER(10,2),
  order_status STRING
);

CREATE OR REPLACE TABLE customers_raw (
  customer_id STRING,
  customer_name STRING,
  email STRING,
  city STRING,
  updated_at TIMESTAMP_NTZ
);

copy into orders_raw from @stg_orders on_error=continue;
copy into customers_raw from @stg_customers on_error=continue;
select * from customers_raw

select * from information_schema.load_history order by last_load_time desc