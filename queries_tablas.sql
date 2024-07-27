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

SELECT A.type_id FROM types AS A RIGHT JOIN properties AS B USING(type);
/*
UPDATE properties AS A
SET type_id = B.type_id
FROM types AS B
WHERE A.type = B.type;
*/
SELECT * FROM types;
SELECT * FROM properties;
