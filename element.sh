PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

#check for argument
if [[ $1 ]]
then

#Get Element
#check if input is a number
if [[ $1 =~ ^[0-9]+$ ]]
then
ELEMENT=$($PSQL "SELECT * FROM elements WHERE (atomic_number = $1)")
else
ELEMENT=$($PSQL "SELECT * FROM elements WHERE ((symbol = '$1') OR (name = '$1'))")
fi

#if not found
if [[ ! -z $ELEMENT ]]
then

#decompose Element info
echo $ELEMENT | while IFS='|' read ATOMIC_NUMBER SYMBOL NAME
do

#Get Properties
ELEMENT_PROPERTIES=$($PSQL "SELECT * FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
#decompose Properties info
echo $ELEMENT_PROPERTIES | while IFS='|' read ATOMIC_NUMBER ATOMIC_MASS MP BP TYPE_ID
do
#get type from types
TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID")
#print string
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
done

done

else echo "I could not find that element in the database."
fi

else
echo 'Please provide an element as an argument.'
fi
