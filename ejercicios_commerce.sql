/*
commerce.customer (code,name,city)
commerce.supplier (code,name,city)
commerce.warehouse (code,name,city)
commerce.product (code,name,cost,price)
commerce.store (code,name,city)
commerce.stock (product_code,warehouse_code,quantity)
commerce.product_supplier (product_code,supplier_code)
commerce.sale (code,customer_code,store_code,sale_date,delivery,discount)
commerce.sale_item (sale_code,product_code,quantity,cost,price)
*/

select commerce.product.name from commerce.product;
 
select commerce.product.name 
from commerce.product
where commerce.product.price > 500;

3- select commerce.product.name 
from commerce.product
where commerce.product.price between 300 and 550;

4- select commerce.product.name 
from commerce.product
where commerce.product.name like 'F%';

5- select commerce.product.name 
from commerce.product
where commerce.product.name like '%e%';

6- select commerce.product.name 
from commerce.product
where commerce.product.name like '_a%';

select commerce.product.code 
from commerce.sale_item
INNER JOIN commerce.product ON product_code = commerce.product.code;
