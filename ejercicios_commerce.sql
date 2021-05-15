1- select commerce.product.name from commerce.product;

2- select commerce.product.name 
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
from commerce.product
INNER JOIN commerce.sale_item ON product_code = commerce.product.code;
