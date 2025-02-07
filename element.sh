#!/bin/bash
# element.sh - Display information about a chemical element from the periodic_table database.

# PostgreSQL command with formatted output
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if an argument is provided; if not, print an error message and exit.
if [[ -z "$1" ]]; then
  echo "Please provide an element as an argument."
  exit 1
fi

# Query the database for an element that matches the atomic number, symbol, or name. 
ELEMENT_DATA=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p USING(atomic_number) JOIN types t ON p.type_id = t.type_id WHERE e.atomic_number='$1' OR e.name='$1';")

# If no matching element is found, output an error message and exit.
if [[ -z "$ELEMENT_DATA" ]]; then
  echo "I could not find that element in the database."
  exit 1
fi

# Parse the query result using the '|' delimiter.
IFS="|" read -r ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< "$ELEMENT_DATA"

# Output the element details in the required format.
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT°C and a boiling point of $BOILING_POINT°C."
