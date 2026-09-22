-- Create view for product sizes
create or replace view product_sizes as
select distinct p.shop_id, v.size
from product_variants v
join products p on p.id = v.product_id
where v.size is not null and v.is_active = true
order by v.size;
