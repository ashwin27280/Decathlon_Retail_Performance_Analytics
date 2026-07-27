CREATE TABLE sales (

    order_id VARCHAR(20) PRIMARY KEY,
    order_date DATE,
    order_time TIME,

    customer_id VARCHAR(20),
    customer_name VARCHAR(100),

    gender VARCHAR(10),
    age INT,
    age_group VARCHAR(30),

    city VARCHAR(50),
    state VARCHAR(50),

    membership_type VARCHAR(30),
    customer_segment VARCHAR(30),

    product_id VARCHAR(20),
    product_name VARCHAR(150),
    product_category VARCHAR(100),
    brand VARCHAR(100),
    sport_type VARCHAR(100),

    quantity INT,

    unit_price NUMERIC(10,2),
    discount_percent NUMERIC(5,2),
    discount_amount NUMERIC(10,2),

    sales_amount NUMERIC(12,2),
    final_amount NUMERIC(12,2),
    cost_price NUMERIC(12,2),
    profit NUMERIC(12,2),

    store_id VARCHAR(20),
    store_name VARCHAR(100),

    sales_channel VARCHAR(30),
    payment_method VARCHAR(30),

    salesperson VARCHAR(100),

    delivery_type VARCHAR(30),
    delivery_days INT,

    customer_rating NUMERIC(3,1),

    return_status VARCHAR(20),
    return_reason VARCHAR(100),

    promotion_campaign VARCHAR(100),

    quarter VARCHAR(10),
    month VARCHAR(20),
    year INT,

    order_month VARCHAR(20),
    order_year INT,

    profit_margin NUMERIC(8,2),
    order_value VARCHAR(20),

    high_value_customer VARCHAR(10)

);


SELECT COUNT(*)
FROM sales;

select * from sales;




