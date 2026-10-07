#!/bin/bash

if [[ $# -eq 0 ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

ELEMENT=$(psql --username=freecodecamp --dbname=periodic_table -t --no-align -F '|' -v element="$1" <<'SQL'
SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius
FROM elements
INNER JOIN properties USING(atomic_number)
INNER JOIN types USING(type_id)
WHERE elements.atomic_number::text = :'element'
  OR elements.symbol = :'element'
  OR elements.name = :'element'
LIMIT 1;
SQL
)

if [[ -z $ELEMENT ]]; then
  echo "I could not find that element in the database."
  exit 0
fi

IFS='|' read -r ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT <<< "$ELEMENT"

printf "The element with atomic number %s is %s (%s). It's a %s, with a mass of %s amu. %s has a melting point of %s celsius and a boiling point of %s celsius.\n" \
  "$ATOMIC_NUMBER" "$NAME" "$SYMBOL" "$TYPE" "$ATOMIC_MASS" "$NAME" "$MELTING_POINT" "$BOILING_POINT"
