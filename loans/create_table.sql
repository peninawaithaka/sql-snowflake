
CREATE DATABASE LOANS; 

CREATE TABLE "LOANS"."PUBLIC"."LOAN_PAYMENT" (
  "Loan_ID" STRING,
  "loan_status" STRING,
  "Principal" STRING,
  "terms" STRING,
  "effective_date" STRING,
  "due_date" STRING,
  "paid_off_time" STRING,
  "past_due_days" STRING,
  "age" STRING,
  "education" STRING,
  "Gender" STRING);
  


 USE DATABASE LOANS;


 //Loading the data from S3 bucket
  
 COPY INTO LOAN_PAYMENT
    FROM s3://bucketsnowflakes3/Loan_payments_data.csv
    file_format = (type = csv 
                   field_delimiter = ',' 
                   skip_header=1);
    

SELECT * FROM LOAN_PAYMENT;

 
 --create a schema for the stages

CREATE OR REPLACE SCHEMA external_stages;

--create a stage - AWS S3
CREATE OR REPLACE STAGE aws_stage
url = 's3://bucketsnowflakes3'

--describe the stage created
desc stage aws_stage;

-- list the files within the stage
list @aws_stage;

--create the table where the data will be copied into
CREATE OR REPLACE TABLE ANALYSIS.PUBLIC.ORDERS(
order_id varchar(30),
amount int,
profit int,
quantity int,
category varchar(30),
subcategory varchar(30)
)


--loading order details data from aws_stage
COPY INTO LOANS.PUBLIC.ORDERS
    FROM @LOANS.EXTERNAL_STAGES.aws_stage
    file_format = (type = csv field_delimiter= ',' skip_header=1)
    files = ('OrderDetails.csv')


select * from public.orders
limit 10