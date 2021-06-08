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


--Obtener por cada venta-producto (sale_item) el nombre del producto, 
--su precio de venta y el promedio de venta de las dos ventas anteriores
-- y posteriores del mismo producto (utilizar la fecha de la venta
-- como orden para las ventas anteriores y posteriores) 
-- Recomendación utilizar funciones de ventana.



select
    sa.code,
    sa.sale_date,
    sa.product,
    sa.sale_amount,
    round(avg(sa.sale_amount) 
        over (partition by sa.product 
        ORDER BY sa.sale_date RANGE BETWEEN 2 PRECEDING AND 2 FOLLOWING ),2) as avg_amount
from (
    select s.code
    ,s.sale_date
    ,p.name product
    ,sum((si.price*si.quantity)-s.discount+s.delivery) sale_amount
        from
            commerce.sale s
        inner join commerce.sale_item si
            on s.code = si.sale_code
        inner join commerce.product p
            on p.code = si.product_code
        group by s.code,s.sale_date,p.name
    ) sa
group by sa.sale_date,sa.product,sa.sale_amount
order by  sa.product,sa.sale_date


select
    sa.product,
    sa.sale_amount,
    sa.sale_date,
    round(avg(sa.sale_amount) 
        over (partition by sa.product 
        ORDER BY sa.sale_date RANGE BETWEEN 2 PRECEDING AND 2 FOLLOWING ),2) as avg_amount
from (
        select 
            s.sale_date,
            p.name product,
            sum((si.price*si.quantity)-s.discount) sale_amount
        from
            commerce.sale s
        inner join commerce.sale_item si
            on s.code = si.sale_code
        inner join commerce.product p
            on p.code = si.product_code
        group by p.name, s.sale_date
    ) sa

select sa.product,
    sa.sale_amount,
    sa.sale_date,
    round(avg(sa.sale_amount) over avg_windows,2) as avg_amount
from (select s.sale_date,
            p.name product,
            sum((si.price*si.quantity)-s.discount) sale_amount
        from
            commerce.sale s
            inner join commerce.sale_item si
                on s.code = si.sale_code
            inner join commerce.product p
                on p.code = si.product_code
        group by p.name, s.sale_date) sa
WINDOW
   avg_windows AS (partition by sa.product ORDER BY sa.sale_date ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING )
order by sa.product,sa.sale_date;

select sa.product,
    sa.sale_amount,
    sa.sale_date,
    round(avg(sa.sale_amount) over avg_windows,2) as avg_amount
from (select s.sale_date,
            p.name product,
            sum((si.price*si.quantity)-s.discount) sale_amount
        from
            commerce.sale s
            inner join commerce.sale_item si
                on s.code = si.sale_code
            inner join commerce.product p
                on p.code = si.product_code
        group by p.name, s.sale_date) sa
WINDOW
   avg_windows AS (partition by sa.product ORDER BY sa.sale_date RANGE BETWEEN 2 PRECEDING AND 2 FOLLOWING )
order by sa.product,sa.sale_date

select p.name, p.price, s.sale_date,
round(AVG(SUM(x.total + s.delivery - s.discount)) OVER 
(ORDER BY s.sale_date RANGE BETWEEN 2 PRECEDING
AND 2 FOLLOWING),2)  promedio
from commerce.product p 
join (
      select si.sale_code, si.product_code, sum(si.quantity * si.price) total
      from commerce.sale_item si
      group by si.sale_code, si.product_code
      ) x on p.code = x.product_code
join commerce.sale s on x.sale_code = s.code
group by p.name, p.price, s.sale_date

SELECT 
    s.sale_date,
    p.name,
    p.price,
    round(avg(sum(si.quantity))
    OVER(PARTITION BY p.code ORDER BY s.sale_date ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING),2) as win_avg
FROM commerce.sale_item si
JOIN commerce.sale s ON s.code=si.sale_code
JOIN commerce.product p ON si.product_code=p.code
GROUP BY p.name,s.sale_date,p.price
ORDER BY p.name,s.sale_date


select 
    p.name prod_name,
    s.sale_date,
    (sum(si.quantity*si.price)-s.discount)  total
    round(AVG((sum(si.quantity*si.price)-s.discount))) OVER 
    (ORDER BY s.sale_date RANGE 2 PRECEDING),2)  promedio
from commerce.sale_item si
    inner join commerce.sale s 
        on s.code = si.sale_code
    inner join commerce.product p 
        on p.code = si.product_code
group by p.name, s.sale_date

SELECT
  empid,
  departamento,
  salario,
  edad,
  avg(salario) OVER ventana_departamento AS salario_medio 
FROM empleado 
WINDOW 
  ventana_departamento AS (PARTITION BY departamento);

select sale_prod.prod_name,sale_prod.sale_date,
round(avg(sale_prod.total) over (partition by sale_prod.sale_date)) prom
    from(
    select 
        p.name prod_name,
        s.sale_date,
       ( sum(si.quantity*si.price)-s.discount)  total
    from commerce.sale_item si
        inner join commerce.sale s on s.code = si.sale_code
        inner join commerce.product p on p.code = si.product_code
    group by p.name, s.sale_date,s.discount) sale_prod;


--2-Obtener el monto total de cada venta,
--se quiere obtener código de venta, fecha de la venta y el monto total de la misma.

select 
    s.code, 
    s.sale_date, 
    sum((si.price*si.quantity)-s.discount) total
from
    commerce.sale s
    inner join commerce.sale_item si
        on s.code = si.sale_code
group by s.code,s.sale_date;

--3-Obtener por cada producto su código, 
--su nombre y la cantidad de unidades vendidas.

select
    p.code,
    p.name,
    isnull(sum(quantity),0) cant
from 
    commerce.product p
left join commerce.sale_item si 
    on p.code = si.product_code
group by p.code, p.name;

--4-Obtener todos los proveedores (supplier) 
--que se encuentran en ciudades 
--donde existen sucursales (store) de la compañía.

--usando join
select distinct
    su.*
 from 
    commerce.supplier su
    inner join commerce.store st
        on st.city = su.city;

--usando in
select 
    su.* 
from commerce.supplier su
where su.city in 
            (select city 
                from commerce.store st 
                where st.city = su.city);

--usando exists
select 
    su.* 
from commerce.supplier su
where exists (select 1 
                from commerce.store st 
                where st.city = su.city);

--Obtener todos aquellos clientes (customer) que han realizado 
--compras en sucursales (store) de su misma ciudad (city)

select distinct
    cu.*
from commerce.customer cu
inner join commerce.sale sa
    on cu.code = sa.customer_code
inner join commerce.store st
    on sa.store_code = st.code
where 
    st.city = cu.city