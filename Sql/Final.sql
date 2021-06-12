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

--No se refiere a 2 días anteriores, sino 2 ventas anteriores, 
--ordenadas por día. De forma que si las 2 ventas anteriores fueron 1 semana antes, 
--también se las considere para calcular el promedio. Y si fueron el mismo día, también.
 --Dado que puede haber ventas con la misma fecha y hora, considerar el nro de venta (code)
 -- para ordenar y elegir las 2 ventas anteriores del mismo producto.
select
    report.sale_code
    ,report.sale_date
    ,report.product_name
    ,report.sale_amount
    ,isnull(round(avg(report.sale_amount) over avg_window ,2),0) as avg_sales
from (
    select
        sale_item.sale_code
        ,sale.sale_date
        ,product.name as product_name
        ,(sale_item.price * sale_item.quantity)+((sale.delivery -sale.discount) / sale.item_count) sale_amount
    from commerce.sale_item as sale_item
        inner join commerce.product as product
            on sale_item.product_code = product.code
        inner join (select 
                        sale.code
                        ,sale.sale_date
                        ,sale.delivery
                        ,sale.discount
                        ,(select count(*) from commerce.sale_item si where si.sale_code =sale.code) item_count
                    from commerce.sale sale
                    ) as sale
            on sale.code=sale_item.sale_code
        ) as report
window
avg_window as (partition by report.product_name order by report.sale_code
    rows between 2 preceding and 2 following exclude current row)
order by report.sale_code;


select
    report.sale_code
    ,report.sale_date
    ,report.product_name
    ,report.sale_amount
    ,isnull(round(avg(report.sale_amount) over avg_window ,2),0) as avg_sales
from (
    select
        sale_item.sale_code
        ,sale.sale_date
        ,product.name as product_name
        ,(sale_item.price * sale_item.quantity)+((sale.delivery -sale.discount) / sale.item_count) sale_amount
    from commerce.sale_item as sale_item
        inner join commerce.product as product
            on sale_item.product_code = product.code
        inner join (select 
                        sale.code
                        ,sale.sale_date
                        ,sale.delivery
                        ,sale.discount
                        ,(select count(*) from commerce.sale_item si where si.sale_code =sale.code) item_count
                    from commerce.sale sale
                    ) as sale
            on sale.code=sale_item.sale_code
        ) as report
window
avg_window as (partition by report.product_name order by report.sale_code
    rows between 2 preceding and 2 following exclude current row)
order by report.sale_code;



--2-Obtener el monto total de cada venta,
--se quiere obtener código de venta, fecha de la venta y el monto total de la misma.

select
    sale.code
    ,sale.sale_date
    ,(sale_item.gross_amount + sale.delivery - sale.discount) as total_amount
from commerce.sale as sale 
inner join
    (select 
        sale_code
        ,sum(price*quantity) gross_amount
    from commerce.sale_item
    group by sale_code
    ) as sale_item 
        on sale_item.sale_code = sale.code;

--3-Obtener por cada producto su código, 
--su nombre y la cantidad de unidades vendidas.

select
    product.code,
    product.name as product_name,
    isnull(sum(sale_item.quantity),0) quantity_solded
from 
    commerce.product as product
left join commerce.sale_item as sale_item 
    on product.code = sale_item.product_code
group by product.code, product.name;

--4-Obtener todos los proveedores (supplier) 
--que se encuentran en ciudades 
--donde existen sucursales (store) de la compañía.

--usando join
select distinct
    supplier.*
from commerce.supplier as supplier
    inner join commerce.store  as store
        on store.city = supplier.city;

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
    customer.*
from commerce.customer as  customer
    inner join commerce.sale as sale
        on customer.code = sale.customer_code
    inner join commerce.store as store
        on sale.store_code = store.code
where 
    store.city = customer.city;


select distinct
    cu.*
from commerce.customer cu
    inner join commerce.sale sa
        on cu.code = sa.customer_code
    inner join commerce.store st
        on sa.store_code = st.code
where 
    st.city = cu.city;
