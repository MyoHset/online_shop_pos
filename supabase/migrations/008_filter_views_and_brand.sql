-- Create view for product categories
create or replace view product_categories as
select distinct shop_id, category
from products
where category is not null and is_active = true
order by category;

-- Create view for product brands
create or replace view product_brands as
select distinct shop_id, brand
from products
where brand is not null and is_active = true
order by brand;

-- Update variant_details to include brand
create or replace view variant_details as
select
  p.shop_id,
  p.name as product_name,
  p.category,
  p.brand,
  v.id as variant_id,
  v.sku,
  v.size,
  v.color,
  coalesce(v.price_override, p.base_price) as final_price,
  v.stock_quantity - v.stock_reserved as available_stock,
  (select image_url from variant_images where variant_id = v.id and is_primary = true limit 1) as primary_image
from product_variants v
join products p on p.id = v.product_id
where v.is_active = true;
