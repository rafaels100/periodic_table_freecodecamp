--1- Cambiar el nombre de la columna weight a atomic_mass
ALTER TABLE properties RENAME COLUMN weight TO atomic_mass;

--2- Cambiar nombre columnas melting_point a melting_point_celsius y boiling_point a boiling_point_celsius
ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius;
ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius;
