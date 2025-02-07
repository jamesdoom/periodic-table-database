#!/bin/bash
# element.sh - Display information about a chemical element from the periodic_table database.

# PostgreSQL command with formatted output
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"


# Check if an argument is provided; if not, print the required message and exit.
if [[ -z "$1" ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

# Determine if the input is numeric (atomic number) or not (symbol or name)
if [[ $1 =~ ^[0-9]+$ ]]; then
  CONDITION="e.atomic_number=$1"
else
  CONDITION="e.symbol='$1' OR e.name='$1'"
fi

# Query the database for an element that matches the condition.
# Redirect stderr to /dev/null to avoid PostgreSQL error messages from appearing.
ELEMENT_DATA=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p USING(atomic_number) JOIN types t ON p.type_id = t.type_id WHERE $CONDITION;" 2>/dev/null)

# If no matching element is found, output the required message and exit.
if [[ -z "$ELEMENT_DATA" ]]; then
  echo "I could not find that element in the database."
  exit 1
fi

# Parse the query result (fields are separated by '|')
IFS="|" read -r ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< "$ELEMENT_DATA"

# Output the element details in the required format.
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."