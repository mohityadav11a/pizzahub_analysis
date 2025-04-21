The PizzaHub database consists of four interconnected tables: orders, order_details, pizzas, and pizza_types. The orders table contains information about each customer order, including a unique order_id and the order_date indicating when the order was placed. This table helps track the volume and timing of customer activity.

The order_details table provides a breakdown of the items included in each order. It links to the orders table via the order_id and includes the pizza_id and quantity, showing which pizzas were ordered and in what amounts. This table is essential for analyzing product-level sales performance.

The pizzas table includes pricing and size information for individual pizzas. Each row represents a specific size of a pizza type and includes a pizza_id, pizza_type_id, size, and price. This table allows for revenue calculations and comparisons between different pizza sizes.

Finally, the pizza_types table holds the broader classification and descriptive data for each pizza, including the pizza_type_id, pizza name, category (such as Classic, Veggie, or Supreme), and a list of ingredients. This table is useful for analyzing pizza preferences across categories and understanding product composition.

Together, these four tables form a relational structure that supports comprehensive analysis of PizzaHub’s sales, revenue trends, product popularity, and customer behavior.
