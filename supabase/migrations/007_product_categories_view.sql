create view product_categories as
select distinct shop_id, category
from products
where category is not null and is_active = true
order by category;
