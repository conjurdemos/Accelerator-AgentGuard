# MySQL container vars
export MYSQL_IMAGE=mysql:8.2.0
export MYSQL_CONTAINER=mysql-xlr8r
export MYSQL_ROOT_PASSWORD=In1t1alR00tPa55w0rd

# MySQL DB account values
#   These vars are used by:
#    - 0-start-demo.sh to set the container port
#    - mysql-admin/init-mysql.sh to initialize the MySQL database
#    - conjur-admin/2-create-secrets.sh to create Conjur secrets

export MYSQL_USERNAME=test_user1
export MYSQL_PASSWORD=UHGMLk1
export MYSQL_SERVER_ADDRESS=localhost
export MYSQL_SERVER_PORT=3306
export MYSQL_DBNAME=petclinic