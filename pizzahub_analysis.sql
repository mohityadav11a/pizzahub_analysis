-- What is the total count of all orders?

select count(order_id) as orders_count from orders;


-- Determine the total revenue from pizza sales.

SELECT 
    ROUND(SUM(orders_details.quantity * pizzas.price),
            2) AS revenue
FROM
    orders_details
        JOIN
    pizzas ON pizzas.pizza_id = orders_details.pizza_id

-- Find the most expensive pizza.

SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;

-- Determine the most frequently ordered pizza size.

SELECT 
    pizzas.size,
    COUNT(orders_details.order_details_id) AS order_count
FROM
    pizzas
        JOIN
    orders_details ON pizzas.pizza_id = orders_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC
LIMIT 3;

-- Show the top 5 most popular pizza types and the number of times each was ordered.

SELECT 
    pizza_types.name, SUM(orders_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC
LIMIT 5;

-- Combine the relevant tables to determine the total quantity ordered for each pizza category.

SELECT 
    pizza_types.category,
    SUM(orders_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY quantity DESC;

-- Examine how orders are distributed across different hours in a day.

SELECT 
    HOUR(order_time) AS hour, COUNT(order_id) AS order_count
FROM
    orders
GROUP BY HOUR(order_time);

-- Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;


-- Aggregate the orders by date and compute the daily average of pizzas ordered.

SELECT 
    ROUND(AVG(quantity), 0) AS average_pizza_ordered
FROM
    (SELECT 
        orders.order_date, SUM(orders_details.quantity) AS quantity
    FROM
        orders
    JOIN orders_details ON orders.order_id = orders_details.order_id
    GROUP BY orders.order_date) AS total_quantity;

-- Identify the top three pizza types with the highest revenue from orders.

SELECT 
    pizza_types.name,
    ROUND(SUM(orders_details.quantity * pizzas.price),
            2) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;

-- Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    pizza_types.category,
    (SUM(orders_details.quantity * pizzas.price) / (SELECT 
            ROUND(SUM(orders_details.quantity * pizzas.price),
                        2)
        FROM
            orders_details
                JOIN
            pizzas ON pizzas.pizza_id = orders_details.pizza_id)) * 100 AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    orders_details ON orders_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue;

-- Analyze the cumulative revenue generated over time.

SELECT 
    order_date,
    ROUND(SUM(revenue) OVER (ORDER BY order_date), 2) AS cum_revenue
FROM (
    SELECT 
        orders.order_date,
        SUM(orders_details.quantity * pizzas.price) AS revenue
    FROM 
        orders_details
    JOIN 
        pizzas ON orders_details.pizza_id = pizzas.pizza_id
    JOIN 
        orders ON orders.order_id = orders_details.order_id
    GROUP BY 
        orders.order_date
) AS sales;


-- Identify the top three pizza types with the highest revenue within each pizza category. 
SELECT 
name, revenue 
FROM (
    SELECT 
        category, name, revenue,
        RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS rn
    FROM (
        SELECT 
            pizza_types.category, pizza_types.name,
            SUM(orders_details.quantity * pizzas.price) AS revenue
        FROM 
            pizza_types
        JOIN 
            pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN 
            orders_details ON orders_details.pizza_id = pizzas.pizza_id
        GROUP BY 
            pizza_types.category, pizza_types.name
    ) AS a
 ) AS b 
 WHERE rn <= 3;




