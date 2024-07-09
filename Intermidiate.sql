-- Find total quantity of each pizza category

SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS total_qty
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY pizza_types.category
ORDER BY total_qty DESC;

-- Determine the distribution of order by hour of the day
SELECT 
    HOUR(orders.order_time) AS hour,
    COUNT(order_id) AS countOrders
FROM
    orders
GROUP BY hour
ORDER BY countOrders DESC;

-- Category Wise Distiribution of Pizzas
SELECT 
    category, COUNT(name) AS Avg_pizzas_Per_Day
FROM
    pizza_types
GROUP BY category;

-- Avg pizzas sold per day
SELECT 
    ROUND(AVG(quantity), 0)
FROM
    (SELECT 
        orders.order_date, SUM(order_details.quantity) AS quantity
    FROM
        orders
    JOIN order_details ON order_details.order_id = orders.order_id
    GROUP BY orders.order_date) AS order_quantity;
    
-- Top 3 most pizza type based on revenue

SELECT 
    SUM(pizzas.price * order_details.quantity) AS Sale,
    pizza_types.name
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY sale DESC
LIMIT 3;
