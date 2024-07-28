--1- Cambiar el nombre de la columna weight a atomic_mass
ALTER TABLE properties RENAME COLUMN weight TO atomic_mass;

--2- Cambiar nombre columnas melting_point a melting_point_celsius y boiling_point a boiling_point_celsius
ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius;
ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius;

--3- las columnsa melting_point_celsius, boiling_point_celsius no deben aceptar nulos
ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL;
ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL;

--4- las columnas symbol y name deberian ser unicas en la tabla elements
ALTER TABLE elements ADD UNIQUE(symbol);
ALTER TABLE elements ADD UNIQUE(name);

--5- las columnas symbol y name deberian ser no nulas
ALTER TABLE elements ALTER COLUMN symbol SET NOT NULL;
ALTER TABLE elements ALTER COLUMN name SET NOT NULL;

--6- La columna atomic_number deberia ser una foreign key que referencia a la columna del mismo nombre en la tabla elements
ALTER TABLE properties ADD FOREIGN KEY(atomic_number) REFERENCES elements(atomic_number);


--7, 8, 9- crear una tabla types que sera la referencia para la tabla de propiedades en cuanto a tipos

CREATE TABLE types (
	type_id SERIAL PRIMARY KEY,
	type VARCHAR(50) NOT NULL
);
--10- la tabla types deberia tener tres tipos de datos, segun vemos en la tabla elements
INSERT INTO types(type) VALUES ('nonmetal'), ('metal'), ('metalloid');

--11- La tabla propiedades debe tener una foreign key que haga referencia a la columna type_id de types. Deberia ser int no nula
--Una vez creada esta tabla, puedo usarla como referencia para la tabla properties
--Pero primero debo crear una nueva columna para los types_id en properties
ALTER TABLE properties ADD COLUMN type_id INT REFERENCES types(type_id);

--No puedo pedirle a la nueva columna type_id que sea NOT NULL, pues al agregarse a una tabla que ya tiene cosas, es inevitable
--que esas filas se llenen con null.

--Primero debo llenar adecuadamente las filas con valores de los id_types segun el tipo de elemento que sea
--12- cada columna en type_id debe tener el type_id adecuado segun su tipo en la columna type
-- Para ello uso la tabla types usando a la columna type para este update
UPDATE properties AS A
SET type_id = B.type_id
FROM types AS B
WHERE A.type = B.type;

--Ahora si puedo setear la propiedad de que la columna type_id de properties no acepte mas nulos a partir de ahora.
ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL;

--13- Debo hacer que la primer letra de la tabla elements sea mayuscula, sin tocar al resto de las letras de la palabra.
UPDATE elements
	SET symbol = UPPER(LEFT(symbol, 1)) || RIGHT(symbol, -1);

--Un hack es usar string slicing y concatenacion: Con LEFTA elegimos la primera letra y la hacemos mayuscula con UPPER. Con RIGHT, en vez de
-- empezar desde la derecha, empezamos desde la izquierda -1 y capturamos todo a derecha, y lo dejamos como esta, pues no tenemos que 
-- poner en minuscula lo que sea que viene despues de la primera letra. Con || concatenamos las strings.
