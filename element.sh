#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"


if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
  else
    ATOMIC_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1' OR name = '$1'")
  fi
  if [[ -z $ATOMIC_NUM ]]
  then
    echo "I could not find that element in the database."
  else
    ATOMIC_NUM_FORMATTED=$(echo "$ATOMIC_NUM" | sed -E 's/^ *| *$//g')
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUM")
    SYMBOL_FORMATTED=$(echo "$SYMBOL" | sed -E 's/^ *| *$//g')
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUM")
    NAME_FORMATTED=$(echo "$NAME" | sed -E 's/^ *| *$//g')
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUM")
    ATOMIC_MASS_FORMATTED=$(echo "$ATOMIC_MASS" | sed -E 's/^ *| *$//g')
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUM")
    MELTING_POINT_FORMATTED=$(echo "$MELTING_POINT" | sed -E 's/^ *| *$//g')
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUM")
    BOILING_POINT_FORMATTED=$(echo "$BOILING_POINT" | sed -E 's/^ *| *$//g')
    TYPE=$($PSQL "SELECT type FROM types FULL JOIN properties USING(type_id) WHERE atomic_number = $ATOMIC_NUM")
    TYPE_FORMATTED=$(echo "$TYPE" | sed -E 's/^ *| *$//g')

    echo "The element with atomic number $ATOMIC_NUM_FORMATTED is $NAME_FORMATTED ($SYMBOL_FORMATTED). It's a $TYPE_FORMATTED, with a mass of $ATOMIC_MASS_FORMATTED amu. $NAME_FORMATTED has a melting point of $MELTING_POINT_FORMATTED celsius and a boiling point of $BOILING_POINT_FORMATTED celsius."

  fi
fi