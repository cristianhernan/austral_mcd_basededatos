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
    count(*) cantidad_vendida
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