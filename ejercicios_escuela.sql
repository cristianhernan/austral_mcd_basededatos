/*escuela.alumno (legajo,nombre,ciudad)
escuela.materia (codigo,nombre)
escuela.cursa (legajo,codigo,nota)
escuela.docente (legajo,nombre,ciudad)
escuela.dicta (legajo,codigo)*/


--1.- Listar los nombres de los alumnos (escuela.alumno.nombre)
SELECT escuela.alumno.nombre FROM escuela.alumno;

--2.- Listar los nombres de los alumnos de la ciudad de 'Buenos Aires' (escuela.alumno.nombre)
SELECT escuela.alumno.nombre 
FROM escuela.alumno
WHERE escuela.alumno.ciudad = 'Buenos Aires';

--3.- Listar los nombres de las materias que contienen la letra 'i' como segundo caracter en su nombre (escuela.materia.nombre)
SELECT escuela.materia.nombre 
FROM escuela.materia
WHERE escuela.materia.nombre like  '_i%';

--4.- Listar los nombres de los alumnos que cursan materias (escuela.alumno.nombre)
SELECT distinct escuela.alumno.nombre 
FROM escuela.alumno 
INNER JOIN escuela.cursa ON escuela.alumno.legajo=escuela.cursa.legajo;

--5.- Listar los nombres de los alumnos que no cursan materias (escuela.alumno.nombre)
SELECT distinct escuela.alumno.nombre 
FROM escuela.alumno 
WHERE escuela.alumno.legajo NOT IN (SELECT legajo FROM escuela.cursa);

--6.- Listar los nombres de las materias de los alumnos de la ciudad de 'Buenos Aires' (escuela.materia.nombre)
SELECT escuela.materia.nombre 
FROM escuela.cursa
INNER JOIN escuela.materia ON escuela.materia.codigo = escuela.cursa.codigo
INNER JOIN escuela.alumno ON escuela.alumno.legajo=escuela.cursa.legajo
WHERE escuela.alumno.ciudad = 'Buenos Aires';

--7.- Listar el promedio de nota de cada materia (escuela.materia.codigo, escuela.materia.nombre, promedio)
SELECT escuela.materia.codigo, escuela.materia.nombre, avg(escuela.cursa.nota) promedio
FROM escuela.cursa
INNER JOIN escuela.materia ON escuela.cursa.codigo = escuela.materia.codigo
GROUP BY escuela.materia.codigo,escuela.materia.nombre;

--8.- Listar las materias cuyo promedio es mayor a 8 (escuela.materia.codigo, escuela.materia.nombre, promedio)
SELECT escuela.materia.codigo, escuela.materia.nombre, avg(escuela.cursa.nota) promedio
FROM escuela.cursa
INNER JOIN escuela.materia ON escuela.cursa.codigo = escuela.materia.codigo
GROUP BY escuela.materia.codigo,escuela.materia.nombre
HAVING promedio > 8;

--9.- Listar la cantidad de materias dictadas por cada docente (escuela.docente.legajo, escuela.docente.nombre, cantidad)
SELECT escuela.docente.legajo, escuela.docente.nombre, count(escuela.dicta.codigo) cantidad
FROM escuela.docente
LEFT JOIN escuela.dicta ON escuela.dicta.legajo = escuela.docente.legajo
LEFT JOIN escuela.materia ON escuela.dicta.codigo = escuela.materia.codigo
GROUP BY escuela.docente.legajo, escuela.docente.nombre;

--10.- Listar los nombres de los alumnos que cursan materias de docentes de su ciudad (escuela.alumno.nombre)
SELECT escuela.alumno.nombre 
FROM escuela.cursa
INNER JOIN escuela.materia ON escuela.materia.codigo = escuela.cursa.codigo
INNER JOIN escuela.alumno ON escuela.alumno.legajo=escuela.cursa.legajo
INNER JOIN escuela.dicta ON escuela.dicta.codigo = escuela.materia.codigo
INNER JOIN escuela.docente ON escuela.docente.legajo = escuela.dicta.legajo
WHERE escuela.alumno.ciudad = escuela.docente.ciudad;

--11.- Listar los docentes que dictan sólo una materia (escuela.docente.legajo, escuela.docente.nombre)
SELECT  escuela.docente.legajo,escuela.docente.nombre
FROM escuela.dicta
INNER JOIN escuela.docente ON escuela.dicta.legajo = escuela.docente.legajo
GROUP BY escuela.docente.legajo, escuela.docente.nombre
HAVING count(escuela.docente.legajo) =1

--12.- Listar por cada materia la cantidad de cursantes, la nota menor, la nota mayor y la nota promedio (escuela.materia.codigo, escuela.materia.nombre, cantidad, menor, mayor, promedio)
SELECT escuela.materia.codigo
    ,escuela.materia.nombre
    ,count(escuela.cursa.codigo) cantdad
    ,min(escuela.cursa.nota) menor
    ,max(escuela.cursa.nota) mayor
    ,avg(escuela.cursa.nota) promedio
FROM escuela.cursa
INNER JOIN escuela.materia ON escuela.cursa.codigo = escuela.materia.codigo
GROUP BY escuela.materia.codigo,escuela.materia.nombre;

--13.- Listar los nombres de los alumnos que cursan todas las materias (escuela.alumno.nombre)

