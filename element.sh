#!/bin/bash

# Provide information about the given element.

# postgresql query helper
PSQL="psql -U freecodecamp -d periodic_table -t --no-align -c"

# early return, if no argument is provided
if [[ -z $1 ]]; then
  # show message and exit
  echo "Please provide an element as an argument."
  exit
fi

# build query to fetch all data for the element
QUERY="select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements e inner join properties p using(atomic_number) inner join types t using(type_id) where "
# argument can be the atomic number, symbol, or name of an element
if [[ $1 =~ ^[0-9]+$ ]]; then
  QUERY+="atomic_number=$1"
else
  QUERY+="symbol='$1' or name='$1'"
fi

# execute query
QUERY_RESULT="$($PSQL "$QUERY")"

# if not exist
if [[ -z $QUERY_RESULT ]]; then
  # show message and exit
  echo "I could not find that element in the database."
  exit
fi

# read query results into array
readarray -t VALUES <<< "$(echo "$QUERY_RESULT" | sed 's/|/\n/g')"

# output formatted information
echo "The element with atomic number ${VALUES[0]} is ${VALUES[1]} (${VALUES[2]}). It's a ${VALUES[3]}, with a mass of ${VALUES[4]} amu. ${VALUES[1]} has a melting point of ${VALUES[5]} celsius and a boiling point of ${VALUES[6]} celsius."
