PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
if [[ $1 ]]; then
  if [[ $1 =~ ^[0-9]+$ ]]; then
    #echo "El argumento ingresado es un numero"
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1" | sed -E 's/^ *| *$//g')
    if [[ -z $ATOMIC_NUMBER ]]; then
      echo "I could not find that element in the database."
    else
      #si el numero atomico es valido, buscamos su simbolo y su nombre
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER" | sed -E 's/^ *| *$//g')
      NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER" | sed -E 's/^ *| *$//g')
      #tambien buscamos su type_id segun el metal que sea
      QUERY="
      SELECT 
        type
      FROM types 
      WHERE
        type_id=
          (SELECT type_id 
          FROM properties
          WHERE atomic_number=$ATOMIC_NUMBER)
      "
      TYPE=$($PSQL "$QUERY" | sed -E 's/^ *| *$//g')
      #luego buscamos toda la data en la tabla de propiedades
      PROPIEDADES=$($PSQL "SELECT * FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
      echo $PROPIEDADES | while read NUM_ATOM BAR MASA BAR MELTING BAR BOILING BAR TYPE_ID BAR
      do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASA amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done
    fi
  else
    #echo "El argumento ingresado NO es un numero"
    #Hay dos opciones: que lo que haya ingresado sea un simbolo, o que sea el nombre entero
    #Busco primero el simbolo. Si no es, busco el nombre. Si no es, entonces no es nada
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1'" | sed -E 's/^ *| *$//g')
    if [[ -z $SYMBOL ]]; then
      #si no encontro el simbolo, aun queda la chance de que haya ingresado un nombre
      NAME=$($PSQL "SELECT name FROM elements WHERE name='$1'" | sed -E 's/^ *| *$//g')
      if [[ -z $NAME ]]; then
        #si tampoco encuentra el nombre, entonces el usuario ingreso basura
        echo "I could not find that element in the database."
      else
        #si encontro el nombre
        #busco entonces el numero atomico y simbolo
        ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$NAME'" | sed -E 's/^ *| *$//g')
        SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$NAME'" | sed -E 's/^ *| *$//g')
        #busco el tipo
        QUERY="
        SELECT 
          type
        FROM types 
        WHERE
          type_id=
            (SELECT type_id 
            FROM properties
            WHERE atomic_number=$ATOMIC_NUMBER)
        "
        TYPE=$($PSQL "$QUERY" | sed -E 's/^ *| *$//g')
        #luego buscamos toda la data en la tabla de propiedades
        PROPIEDADES=$($PSQL "SELECT * FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
        echo $PROPIEDADES | while read NUM_ATOM BAR MASA BAR MELTING BAR BOILING BAR TYPE_ID BAR
        do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASA amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
        done
      fi
    else
      #si encontro el simbolo
      #busco entonces el numero atomico y nombre
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$SYMBOL'" | sed -E 's/^ *| *$//g')
      NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$SYMBOL'" | sed -E 's/^ *| *$//g')
      #busco el tipo
      QUERY="
        SELECT 
          type
        FROM types 
        WHERE
          type_id=
            (SELECT type_id 
            FROM properties
            WHERE atomic_number=$ATOMIC_NUMBER)
        "
      TYPE=$($PSQL "$QUERY" | sed -E 's/^ *| *$//g')
      #luego buscamos toda la data en la tabla de propiedades
      PROPIEDADES=$($PSQL "SELECT * FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
      echo $PROPIEDADES | while read NUM_ATOM BAR MASA BAR MELTING BAR BOILING BAR TYPE_ID BAR
      do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASA amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done
    fi
  fi
else
  echo "Please provide an element as an argument."
fi