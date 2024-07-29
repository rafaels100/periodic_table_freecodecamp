--1- Cambiar el nombre de la columna weight a atomic_mass
/*
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
*/
--6- La columna atomic_number deberia ser una foreign key que referencia a la columna del mismo nombre en la tabla elements
--ALTER TABLE properties ADD FOREIGN KEY(atomic_number) REFERENCES elements(atomic_number);

--Correr dos veces la foreign key hace que se duplique esa restriccion... la elimino a mano y ya comento el codigo
--ALTER TABLE properties DROP CONSTRAINT properties_atomic_number_fkey1;

--7- crear una tabla types que sera la referencia para la tabla de propiedades en cuanto a tipos

/*
CREATE TABLE types (
	type_id SERIAL PRIMARY KEY,
	type VARCHAR(50) NOT NULL
);

INSERT INTO types(type) VALUES ('nonmetal'), ('metal'), ('metalloid');
*/
--Una vez creada esta tabla, puedo usarla como referencia para la tabla properties
--Pero primero debo crear una nueva columna para los types_id en properties
--ALTER TABLE properties ADD COLUMN type_id INT REFERENCES types(type_id);

--ALTER TABLE properties ADD FOREIGN KEY(type_id) REFERENCES types(type_id);

--SELECT A.type_id FROM types AS A RIGHT JOIN properties AS B USING(type);
/*
UPDATE properties AS A
SET type_id = B.type_id
FROM types AS B
WHERE A.type = B.type;
*/
--SELECT * FROM types;
--SELECT * FROM properties;
--SELECT * FROM elements;

--Chequeo que no pueda insertar nulls en la columna de types, pues la foreign key no permite nulls
--INSERT INTO properties(atomic_number, type, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id) 
--VALUES (10, 'nonmetal', 1, 1, 1, NULL)

--Necesito un nuevo elemento en la tabla elements para hacer esta prueba..
--INSERT INTO elements(atomic_number, symbol, name) VALUES (9, 'D', 'Locatio');

--INSERT INTO properties(atomic_number, type, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id) 
--VALUES (9, 'nonmetal', 1, 1, 1, NULL);
/*
SELECT * FROM properties;
--Well waddayaknow... si me deja insertar NULLS, aunque la foreign key restriction no acepte NULLS.
--Entonces, debo forzar esa restraint en esta columna tambien
DELETE FROM properties WHERE atomic_number=9 OR atomic_number=10;
ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL;

--Repito la prueba y no deberia ser capaz ahora de lograrlo
--Necesito un nuevo elemento en la tabla elements para hacer esta prueba..
INSERT INTO elements(atomic_number, symbol, name) VALUES (10, 'Di', 'Locatioi');

INSERT INTO properties(atomic_number, type, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id) 
VALUES (10, 'nonmetal', 1, 1, 1, NULL);

UPDATE elements
	SET symbol = INITCAP(symbol);
	
-- INITCAP no nos sirve, pues si bien pone en mayuscula la primera letra, tambien pone en minuscula a los que estan a derecha, no los deja como estan.
*/

--UPDATE elements
--	SET symbol = REGEXP_REPLACE(symbol, '(^[A-Z])', E'\\l\\1')
	
-- Tristemente REGEXP_REPLACE no tiene una built-in function para reemplazar los caracteres que encontro con regex por su version mayuscula.
-- Malisimo.


--UPDATE elements
	--SET symbol = UPPER(LEFT(symbol, 1)) || RIGHT(symbol, -1);

--Un hack es usar string slicing y concatenacion: Con LEFTA elegimos la primera letra y la hacemos mayuscula con UPPER. Con RIGHT, en vez de
-- empezar desde la derecha, empezamos desde la izquierda -1 y capturamos todo a derecha, y lo dejamos como esta, pues no tenemos que 
-- poner en minuscula lo que sea que viene despues de la primera letra. Con || concatenamos las strings.

--You should remove all the trailing zeros after the decimals from each row of the atomic_mass column. You may need to adjust a data type to DECIMAL for this. The final values they should be are in the atomic_mass.txt file
--14- Remover todos los ceros
--ALTER TABLE properties ALTER COLUMN atomic_mass TYPE DECIMAL(8, 2);

--ALTER TABLE properties ALTER COLUMN atomic_mass TYPE REAL;
--ALTER TABLE properties ALTER COLUMN atomic_mass TYPE DECIMAL;
--SELECT * FROM properties;

--You should add the element with atomic number 9 to your database. Its name is Fluorine, symbol is F, mass is 18.998, melting point is -220, boiling point is -188.1, and it's a nonmetal

--15 y 16- añadir el Fluorine al database y el Neon
INSERT INTO elements(atomic_number, symbol, name) VALUES (9, 'F', 'Fluorine'), (10, 'Ne', 'Neon');

INSERT INTO properties(atomic_number, type, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id)
VALUES (9, 'nonmetal', 18.998, -220, -188.1, 1), (10, 'nonmetal', 20.18, -248.6, -246.1, 1);

