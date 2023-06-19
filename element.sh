#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"


if [[ $1 ]]
then
  REGEX_NUMBER="^[0-9]+$"
  REGEX_ELEMENT="^[A-Z][a-z]?$"
  if [[ "$1" =~ $REGEX_NUMBER ]] 
  then
    JOIN_DATA=$($PSQL "SELECT properties.atomic_number, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM properties INNER JOIN elements ON properties.atomic_number = elements.atomic_number INNER JOIN types ON properties.type_id = types.type_id WHERE properties.atomic_number = $1")
    else
    if [[ "$1" =~ $REGEX_ELEMENT ]]
    then
      JOIN_DATA=$($PSQL "SELECT properties.atomic_number, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM properties INNER JOIN elements ON properties.atomic_number = elements.atomic_number INNER JOIN types ON properties.type_id = types.type_id WHERE symbol LIKE '$1'")
      else
      JOIN_DATA=$($PSQL "SELECT properties.atomic_number, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM properties INNER JOIN elements ON properties.atomic_number = elements.atomic_number INNER JOIN types ON properties.type_id = types.type_id WHERE name LIKE '$1'")
    fi
  fi
  if [[ -z $JOIN_DATA ]]
    then
      echo "I could not find that element in the database."
    else
      echo $JOIN_DATA | while read ATOMIC_NUMBER PIPE NAME PIPE SYMBOL PIPE ATOMIC_MASS PIPE MELTING_POINT PIPE BOILING_POINT PIPE TYPE
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
    fi
else
  echo "Please provide an element as an argument."
fi
