# DuplicateTableClmns
Display tables that are not present in database 2 but are in database 1


1.) Replace below details.
  # Prompt the user for MySQL credentials and connection parameters for database 1

    DB1_HOST="localhost" ~~ Use your host
    DB1_USER="root"  ~~ Use your host username
    DB1_PASS="root"  ~~ Use your host password

  # Prompt the user for MySQL credentials and connection parameters for database 2
    DB2_HOST="localhost"
    DB2_USER="root"
    DB2_PASS="root"

2.) Replace below mysql paths.

  # Get the list of tables from database 1
    DB1_TABLES=$(E:\\wamp64\\bin\\mysql\\mysql8.0.27\\bin\\mysql.exe -h$DB1_HOST -u$DB1_USER -p$DB1_PASS -D$DB1_NAME -e "SHOW TABLES;" | tail -n +2 | tr '\n' ' ')

  # Get the list of tables from database 2
    DB2_TABLES=$(E:\\wamp64\\bin\\mysql\\mysql8.0.27\\bin\\mysql.exe -h$DB2_HOST -u$DB2_USER -p$DB2_PASS -D$DB2_NAME -e "SHOW TABLES;" | tail -n +2 | tr '\n' ' ')

