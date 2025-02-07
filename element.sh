#!/bin/bash

#PostgreSQL command with formatted output
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
# Check if an argument is provided
if [[ -z $1 ]]; then
  echo "Pleae provide an element as an argument."
  exit 1
fi

# Determine the type of input (atomic number, symbol, or name)
if [[ $1 =~ ^[0-9]+$ ]]; then
  QUERY_CONDITION="atomic_number=$1"
elif [[ $1 =~ ^[A-Za-z]{1,2}$ ]]; then
  QUERY_CONDITION="symbol='$1'"
else
  QUERY_CONDITION="name='$1'"
fi

# Query the database
ELEMENT_DATA=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, p.type, p.weight, p.melting_point, p.boiling_point FROM elements e JOIN properties p ON e.atomic_number=p.atomic_number WHERE $QUERY_CONDITION")

# Check if element was found
if [[ -z $ELEMENT_DATA ]]; then
  echo "I could not find that element in the database."
  exit 1
fi

# Parse query result and display output
IFS="|" read -r ATOMIC_NUMBER NAME SYMBOL TYPE WEIGHT MELTING_POINT BOILING POINT <<< "$ELEMENT_DATA"

echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL)."
echo "It's a $TYPE with a mass of $WEIGHT amu."
echo "$NAME has a melting point of $MELTING_POINT°C and a boiling point of $BOILING_POINT°C."

exit 0