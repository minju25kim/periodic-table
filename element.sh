# #!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 ]]
then
  if [[ $1 =~ ^[0-9]+$ ]]
  then 
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1;")
  else
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1' OR name = '$1';")
  fi
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo I could not find that element in the database.
    exit 0
  else
    $PSQL "SELECT * FROM properties FULL JOIN elements USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number = $ATOMIC_NUMBER" | while IFS="|" read TYPE_ID ATOMIC_NUMBER ATOMIC_MASS MELTING BOILING SYMBOL NAME TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done 
  fi
  else
  echo Please provide an element as an argument.
fi
