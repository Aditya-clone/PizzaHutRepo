-- % of each category towards revenue

SELECT 
    pizza_types.category,
    SUM(pizzas.price * order_details.quantity) / (SELECT 
            ROUND(SUM(order_details.quantity * pizzas.price),
                        2) AS Total_Sales
        FROM
            order_details
                JOIN
            pizzas ON pizzas.pizza_id = order_details.pizza_id) * 100 AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC;

-- cumulative revenue over time

select 
	order_date, 
	sum(revenue) over (order by order_date) as cumulative 
from (SELECT 
    orders.order_date,
    SUM(pizzas.price * order_details.quantity) AS revenue
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
        JOIN
    orders ON orders.order_id = order_details.order_id
    group by orders.order_date) as sales;
    
-- Top 3 pizza types based on revenue

select 
	name, category, revenue 
from ( SELECT 
	category, name, revenue,
    rank() over(partition by category order by revenue desc) as rn 
from (select
    pizza_types.category, pizza_types.name,
    SUM(pizzas.price * order_details.quantity) AS revenue
FROM pizza_types
        JOIN pizzas 
	ON pizza_types.pizza_type_id = pizzas.pizza_type_id
		join  order_details
	on order_details.pizza_id = pizzas.pizza_id
	group by pizza_types.category, pizza_types.name) as a) as b
where rn <= 3;


