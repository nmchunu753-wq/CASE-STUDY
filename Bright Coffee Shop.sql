---1. QUERY FOR EXPLORING THE TABLE(COLUMNS)
SELECT *
FROM `workspace`.`default`.`1773682225332_bright_coffee_shop_analysis_case_study_1_1`;

---2. NAMES OF STORES.
---We have Lower Manhattan, Hell's Kitchen and Astoria
SELECT DISTINCT store_location
FROM `workspace`.`default`.`1773682225332_bright_coffee_shop_analysis_case_study_1_1`;

---3 THE NUMBER OF STORES
---We have 3 stores
SELECT COUNT( DISTINCT store_location) AS number_of_stores
FROM `workspace`.`default`.`1773682225332_bright_coffee_shop_analysis_case_study_1_1`;

---4. PRODUCT SOLD
SELECT DISTINCT product_category
FROM `workspace`.`default`.`1773682225332_bright_coffee_shop_analysis_case_study_1_1`;


---5. PRODUCT DETAILS
SELECT DISTINCT product_detail
FROM `workspace`.`default`.`1773682225332_bright_coffee_shop_analysis_case_study_1_1`;

---6. Aliases for multiple columns.
SELECT product_category AS category,
       product_detail AS product_name
FROM `workspace`.`default`.`1773682225332_bright_coffee_shop_analysis_case_study_1_1`;

-----------------------------------------------------------------
---7 EXPENSIVE AND  CHEAP PRODUCTS
-----------------------------------------------------------------
SELECT MIN(unit_price) AS cheap_product
FROM `workspace`.`default`.`1773682225332_bright_coffee_shop_analysis_case_study_1_1`;

SELECT MAX(unit_price) AS expensive_product
FROM `workspace`.`default`.`1773682225332_bright_coffee_shop_analysis_case_study_1_1`;

---8. TOTAL REVENUE FROM JANUARY TO JUNE
SELECT 
    SUM(transaction_qty * unit_price) AS total_sales_Jan_to_June
FROM `workspace`.`default`.`1773682225332_bright_coffee_shop_analysis_case_study_1_1`
WHERE transaction_date BETWEEN '2023-01-01' AND '2023-06-30';

---9. FINDING THE TOTAL REVENUE FOR EACH LOCATION
SELECT 
    store_location,
    SUM(transaction_qty * unit_price) AS total_sales_per_coffee_shop,

FROM `workspace`.`default`.`1773682225332_bright_coffee_shop_analysis_case_study_1_1`
GROUP BY store_location;


---10. NUMBER OF TRANSATIONS PER MONTH
SELECT 
      CASE
      WHEN  transaction_date  BETWEEN '2023-01-01' AND '2023-01-31' THEN 'JAN'
      WHEN transaction_date BETWEEN '2023-02-01' AND '2023-02-28' THEN 'FEB'
      WHEN transaction_date BETWEEN '2023-03-01' AND '2023-03-31' THEN 'MAR'
      WHEN transaction_date BETWEEN '2023-04-01' AND '2023-04-30' THEN 'APR'
      WHEN transaction_date BETWEEN '2023-05-01' AND '2023-05-31' THEN 'MAY'
      WHEN transaction_date BETWEEN '2023-06-01' AND '2023-06-30' THEN 'JUNE'
      END AS transaction_month,
      COUNT(*) AS total_transaction
FROM `workspace`.`default`.`1773682225332_bright_coffee_shop_analysis_case_study_1_3` 
GROUP BY transaction_month
ORDER BY transaction_month DESC ;



-------------------------------------------------------------------------
---11. AGGREGATION
------------------------------------------------------------------------
SELECT 
---DATES
    transaction_date,
       Dayname(transaction_date) AS Day_name,
       Monthname(transaction_date) AS Month_name,
       Dayofmonth(transaction_date) AS Day_of_month,

       CASE 
           WHEN Day_name IN ('Sun', 'Sat') THEN 'Weekend'
           ELSE 'Weekday'
           END Day_classication,
       date_format(transaction_time, 'HH:mm:ss') AS purchase_time,

        CASE
        WHEN  date_format(transaction_time, 'HH:mm:ss') BETWEEN '06:00:00' AND '09:00:00' THEN 'MORNING RUSH'
        WHEN  date_format(transaction_time, 'HH:mm:ss') BETWEEN '09:00:01' AND '12:00:00' THEN 'MID MORNING'
        WHEN  date_format(transaction_time, 'HH:mm:ss') BETWEEN '12:00:01' AND '16:00:00' THEN 'AFTERNOON'
        WHEN  date_format(transaction_time, 'HH:mm:ss') BETWEEN '16:00:01' AND '17:00:00' THEN 'PEAK AFTERNOON RUSH'
        WHEN  date_format(transaction_time, 'HH:mm:ss') BETWEEN '17:00:01' AND '21:00:00' THEN 'EVENING'
    END time_bucket,
       ---COUNTS
       COUNT(DISTINCT transaction_id) AS Number_of_Sales,
       COUNT (DISTINCT product_id) AS Number_of_products,
       COUNT (DISTINCT store_id) Number_of_stores,

       ---REVENUE
       SUM(transaction_qty * unit_price) Revenue_per_day,

      CASE 
    WHEN SUM(transaction_qty * unit_price) <= 50 THEN 'Low Spend'
    WHEN SUM(transaction_qty * unit_price) <= 100 THEN 'Medium Spend'
    ELSE 'High Spend'
END AS spend_bucket,



       ---CATEGORICAL COLUMNS
       store_location,
       product_category,
       product_detail

FROM `workspace`.`default`.`1773682225332_bright_coffee_shop_analysis_case_study_1_3` 
GROUP BY transaction_date,
        Day_name,
        Month_name,
       store_location,
       product_category,
       product_detail,
       transaction_time,
       time_bucket,
       Day_of_month;


---12 START DATE FOR DATA COLLECTION 
SELECT MIN(transaction_date) AS min_date
FROM `workspace`.`default`.`1773682225332_bright_coffee_shop_analysis_case_study_1_1`;
---Data was collected from 2023-01-01


---13 THE LAST DATE FOR DATA COLLECTION
SELECT MAX(transaction_date) AS max_date
FROM `workspace`.`default`.`1773682225332_bright_coffee_shop_analysis_case_study_1_1`;
---Data was lastly collected in 2023-06-30, therefore, our data is for six months.

---4. VIEWING STORE LOCATIONS
---We have Lower Manhattan, Hell's Kitchen and Astoria.
SELECT DISTINCT store_location
FROM `workspace`.`default`.`1773682225332_bright_coffee_shop_analysis_case_study_1_1`;


---8. PRODUCT TYPES
SELECT DISTINCT product_type
FROM `workspace`.`default`.`1773682225332_bright_coffee_shop_analysis_case_study_1_1`;



---9. CHEAPEST PRODUCT
SELECT 
    product_category,
    MIN(unit_price) AS cheapest_price
FROM `workspace`.`default`.`1773682225332_bright_coffee_shop_analysis_case_study_1_1`
GROUP BY product_category
ORDER BY cheapest_price ASC
LIMIT 3;

--- 4. THREE WORST SELLING PRODUCTS FROM JANUARY TO JUNE
SELECT product_category,
COUNT(*) AS Number_of_Sales
FROM `workspace`.`default`.`1773682225332_bright_coffee_shop_analysis_case_study_1_1`
WHERE transaction_date BETWEEN '2023-01-01' AND '2023-06-30'
GROUP BY product_category
ORDER BY COUNT(*) ASC
---ASC to start with the smallest amount
LIMIT 3;

---10. EXPLENSIVE PRODUCT
SELECT 
    product_category,
    MAX(unit_price) AS highest_price
FROM `workspace`.`default`.`1773682225332_bright_coffee_shop_analysis_case_study_1_1`
GROUP BY product_category
ORDER BY highest_price DESC
LIMIT 3;

--- 3. 3 BEST SELLING PRODUCT FROM JANUARY TO JUNE
SELECT product_category,
COUNT(*) AS Number_of_Sales
FROM `workspace`.`default`.`1773682225332_bright_coffee_shop_analysis_case_study_1_1`
WHERE transaction_date BETWEEN '2023-01-01' AND '2023-06-30'
GROUP BY product_category
ORDER BY COUNT(*) DESC
---DESC to start with the highest number of sales.
LIMIT 3;


---11. NUMBER OF ROWS
SELECT COUNT(*)
FROM `workspace`.`default`.`1773682225332_bright_coffee_shop_analysis_case_study_1_1`;


---14. NUMBER OF SALES AND TOTAL REVENUE PER DAY
SELECT 
    transaction_date,
    DAYNAME(transaction_date) AS Day_name,
    MONTHNAME(transaction_date) AS Month_name,

    CASE 
        WHEN  date_format(transaction_time, 'HH:mm:ss') BETWEEN '06:00:00' AND '09:00:00' THEN 'MORNING RUSH'
        WHEN  date_format(transaction_time, 'HH:mm:ss') BETWEEN '09:00:01' AND '12:00:00' THEN 'MID MORNING'
        WHEN  date_format(transaction_time, 'HH:mm:ss') BETWEEN '12:00:01' AND '16:00:00' THEN 'AFTERNOON'
        WHEN  date_format(transaction_time, 'HH:mm:ss') BETWEEN '16:00:01' AND '17:00:00' THEN 'PEAK AFTERNOON RUSH'
        WHEN  date_format(transaction_time, 'HH:mm:ss') BETWEEN '17:00:01' AND '21:00:00' THEN 'EVENING'
    END AS time_buckets,
    COUNT(DISTINCT transaction_id) AS Number_of_sales,
    SUM(transaction_qty * unit_price) AS revenue_per_day

FROM `workspace`.`default`.`1773682225332_bright_coffee_shop_analysis_case_study_1_1`

GROUP BY 
    transaction_date,
    Day_name,
    Month_name,
    time_buckets;


    ---REVENUE PER TIME SPLITS
SELECT
 CASE 
        WHEN  date_format(transaction_time, 'HH:mm:ss') BETWEEN '06:00:00' AND '09:00:00' THEN 'MORNING RUSH'
        WHEN  date_format(transaction_time, 'HH:mm:ss') BETWEEN '09:00:01' AND '12:00:00' THEN 'MID MORNING'
        WHEN  date_format(transaction_time, 'HH:mm:ss') BETWEEN '12:00:01' AND '16:00:00' THEN 'AFTERNOON'
        WHEN  date_format(transaction_time, 'HH:mm:ss') BETWEEN '16:00:01' AND '17:00:00' THEN 'PEAK AFTERNOON RUSH'
        WHEN  date_format(transaction_time, 'HH:mm:ss') BETWEEN '17:00:01' AND '21:00:00' THEN 'EVENING'
    END AS time_buckets,
    SUM(transaction_qty * unit_price) AS total_revenue
    FROM `workspace`.`default`.`1773682225332_bright_coffee_shop_analysis_case_study_1_3` 
    GROUP BY time_buckets
    ORDER BY time_buckets ASC;

---TOTAL REVENUE PER DAY FOR 6 MONTHS
    SELECT   DAYNAME(transaction_date) AS Day_name,
     SUM(transaction_qty * unit_price) AS revenue_per_day
     FROM `workspace`.`default`.`1773682225332_bright_coffee_shop_analysis_case_study_1_3` 
     GROUP BY   Day_name;



             

--TOTAL SALES
SELECT 
    store_location,
    SUM(transaction_qty * unit_price) AS total_sales_per_coffee_shop,

FROM `workspace`.`default`.`1773682225332_bright_coffee_shop_analysis_case_study_1_1`
GROUP BY store_location;

---13. MONEY MADE PER MONTH
SELECT   store_location,
         SUM(transaction_qty * unit_price) AS Total_revenue_per_day,
      CASE
      WHEN  transaction_date  BETWEEN '2023-01-01' AND '2023-01-31' THEN 'JAN'
      WHEN transaction_date BETWEEN '2023-02-01' AND '2023-02-28' THEN 'FEB'
      WHEN transaction_date BETWEEN '2023-03-01' AND '2023-03-31' THEN 'MAR'
      WHEN transaction_date BETWEEN '2023-04-01' AND '2023-04-30' THEN 'APR'
      WHEN transaction_date BETWEEN '2023-05-01' AND '2023-05-31' THEN 'MAY'
      WHEN transaction_date BETWEEN '2023-06-01' AND '2023-06-30' THEN 'JUNE'
      END AS transaction_month
FROM `workspace`.`default`.`1773682225332_bright_coffee_shop_analysis_case_study_1_3` 
GROUP BY transaction_month,
          store_location;



---HIGH AND LOW PERFORMING PRODUCTS
--- 3. SIX BEST SELLING PRODUCT FROM JANUARY TO JUNE
SELECT product_category,
COUNT(*) AS Number_of_Sales
FROM `workspace`.`default`.`1773682225332_bright_coffee_shop_analysis_case_study_1_1`
WHERE transaction_date BETWEEN '2023-01-01' AND '2023-06-30'
GROUP BY product_category
ORDER BY COUNT(*) DESC
---DESC to start with the highest number of sales.
LIMIT 6;


--- THE NUMBER OF SALES FOR EACH PRODUCT.
SELECT 
    product_category,
    SUM(transaction_qty) AS Total_Quantity_Sold
FROM `workspace`.`default`.`1773682225332_bright_coffee_shop_analysis_case_study_1_1`
GROUP BY product_category
ORDER BY Total_Quantity_Sold DESC;









