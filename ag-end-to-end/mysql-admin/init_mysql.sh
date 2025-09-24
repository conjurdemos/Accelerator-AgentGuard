#!/bin/bash

if [[ $1 == "all" ]]; then
  # full admin
  PERMS="ALL PRIVILEGES"
else
  # read-only
  PERMS="SELECT"
fi

source ../demo-vars.sh
source ../db-vars.sh

echo; echo
echo "Waiting for MySQL to be ready..."
DB_READY=0
while [[ $DB_READY -eq 0 ]]; do
  sleep 5
  DB_READY=$($DOCKER exec mysql mysql -h localhost -u root --password=$MYSQL_ROOT_PASSWORD -e "SELECT 1" 2>/dev/null)
done

echo
echo "Dropping existing database..."
echo "drop database petclinic;"	\
| $DOCKER exec -i mysql	\
      mysql -h localhost -u root --password=$MYSQL_ROOT_PASSWORD
echo
echo "Initializing MySQL database..."
# create db
cat db_create_petclinic.sql          				\
| $DOCKER exec -i mysql	\
      mysql -h localhost -u root --password=$MYSQL_ROOT_PASSWORD
echo
echo "Loading data..."
cat db_load_petclinic.sql            				\
| $DOCKER exec -i mysql	\
      mysql -h localhost -u root --password=$MYSQL_ROOT_PASSWORD

# grant user access
./mysqldb-grant-user-access.sh $MYSQL_DBNAME $MYSQL_USERNAME $MYSQL_PASSWORD

echo
echo
echo "Verifying petclinic database:"
echo "use petclinic; select * from pets;" \
| $DOCKER exec -i mysql	\
      mysql -h localhost -u root --password=$MYSQL_ROOT_PASSWORD

