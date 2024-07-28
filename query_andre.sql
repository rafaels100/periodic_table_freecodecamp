SELECT * FROM properties;

SELECT
	CAST(atomic_mass AS INTEGER)
	, REGEXP_REPLACE(CAST(atomic_mass AS VARCHAR), '0*$', '')
	, CAST(REGEXP_REPLACE(CAST(atomic_mass AS VARCHAR), '0*$', '') AS NUMERIC)
	, REGEXP_REPLACE(atomic_mass :: VARCHAR, '0*$', '')
	, CAST(REGEXP_REPLACE(CAST(atomic_mass AS VARCHAR), '0*$', '') AS NUMERIC(10, 1))
	, atomic_mass :: REAL :: DECIMAL
FROM properties;