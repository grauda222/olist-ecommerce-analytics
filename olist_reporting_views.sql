-- Olist E-Commerce Analytics
-- PostgreSQL views and indexes used for Power BI analysis

-- Preventing errors when re-running

drop view if exists gmv_over_time;
drop view if exists seller_and_carrier_performance;
drop view if exists customer_type_and_spending;

-- Ensuring price has 2-decimal numeric precision for
-- accurate currency aggregation in the views below

alter table olist_order_items_dataset
alter column price type numeric(12,2);

-- ============================================
-- View: gmv_over_time
-- ============================================

create view gmv_over_time as
select i.order_id, i.order_item_id, i.price, o.order_status, o.order_purchase_timestamp, 
	o.order_delivered_customer_date, c.customer_city, c.customer_state,
	case
	when t.product_category_name_english is null then p.product_category_name
	else t.product_category_name_english 
	end as product_category_name_translated
from olist_order_items_dataset as i
join olist_orders_dataset as o
	on i.order_id = o.order_id
join olist_customers_dataset as c
	on o.customer_id = c.customer_id
join olist_products_dataset as p
	on i.product_id = p.product_id
left join product_category_name_translation as t
	on p.product_category_name = t.product_category_name;

-- ============================================
-- View: seller_and_carrier_performance
-- ============================================

create view seller_and_carrier_performance as
select i.seller_id, i.order_id, i.order_item_id, i.price, i.shipping_limit_date,
	s.seller_city, s.seller_state, o.order_delivered_carrier_date, o.order_status, 
	o.order_purchase_timestamp, o.order_estimated_delivery_date, o.order_delivered_customer_date,
	r.review_score, c.customer_city, c.customer_state
from olist_order_items_dataset as i
join olist_sellers_dataset as s
	on i.seller_id = s.seller_id
join olist_orders_dataset as o
	on i.order_id = o.order_id
left join olist_order_reviews_dataset as r
	on i.order_id = r.order_id
join olist_customers_dataset as c
	on o.customer_id = c.customer_id;

-- ============================================
-- View: customer_type_and_spending
-- ============================================

create view customer_type_and_spending as
with customer_grouping as (
	select c.customer_unique_id, c.customer_city, c.customer_state, 
		count(distinct o.order_id) as count_of_orders,
		case when count(distinct o.order_id) > 1 then 'repeat' else 'one-time' end as customer_type, 
		sum(i.price) as amount_spent
	from olist_orders_dataset as o
	join olist_customers_dataset as c
		on o.customer_id = c.customer_id
	join olist_order_items_dataset as i
		on o.order_id = i.order_id
	where o.order_status = 'delivered'
	group by (customer_unique_id, customer_state, customer_city)
)
select customer_unique_id, customer_city, customer_state,
	count_of_orders, customer_type, amount_spent,
	case when amount_spent > avg(amount_spent) over() then 'yes' else 'no' end as above_average_spending 
from customer_grouping;

-- ============================================
-- Indexes
-- ============================================

create index if not exists idx_order_items_order_id on olist_order_items_dataset(order_id);
create index if not exists idx_order_items_product_id on olist_order_items_dataset(product_id);
create index if not exists idx_order_items_seller_id on olist_order_items_dataset(seller_id);
create index if not exists idx_orders_customer_id on olist_orders_dataset(customer_id);
create index if not exists idx_reviews_order_id on olist_order_reviews_dataset(order_id);
create index if not exists idx_products_product_id on olist_products_dataset(product_id);
create index if not exists idx_customers_customer_id on olist_customers_dataset(customer_id);
create index if not exists idx_sellers_seller_id on olist_sellers_dataset(seller_id);
