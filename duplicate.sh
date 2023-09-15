# Prompt the user for MySQL credentials and connection parameters for database 1
DB1_HOST="localhost"
DB1_USER="root"
DB1_PASS="root"
echo
read -p "Enter Database 1 Name: " DB1_NAME

# Prompt the user for MySQL credentials and connection parameters for database 2
DB2_HOST="localhost"
DB2_USER="root"
DB2_PASS="root"
echo
read -p "Enter Database 2 Name: " DB2_NAME

# Get the list of tables from database 1
DB1_TABLES=$(E:\\wamp64\\bin\\mysql\\mysql8.0.27\\bin\\mysql.exe -h$DB1_HOST -u$DB1_USER -p$DB1_PASS -D$DB1_NAME -e "SHOW TABLES;" | tail -n +2 | tr '\n' ' ')

# Get the list of tables from database 2
DB2_TABLES=$(E:\\wamp64\\bin\\mysql\\mysql8.0.27\\bin\\mysql.exe -h$DB2_HOST -u$DB2_USER -p$DB2_PASS -D$DB2_NAME -e "SHOW TABLES;" | tail -n +2 | tr '\n' ' ')

# Find tables that are not present in database 2 but are in database 1
NOT_PRESENT_IN_DB2=""
for table1 in $DB1_TABLES; do
    found=false
    for table2 in $DB2_TABLES; do
        if [ "$table1" == "$table2" ]; then
            found=true
            break
        fi
    done
    if ! $found; then
        NOT_PRESENT_IN_DB2="$NOT_PRESENT_IN_DB2 $table1"
    fi
done

# Display tables that are not present in database 2 but are in database 1
echo "Tables that are in $DB1_NAME but not in $DB2_NAME:"
if [ -z "$NOT_PRESENT_IN_DB2" ]; then
    echo "No tables found."
else
    for table in $NOT_PRESENT_IN_DB2; do
        echo "- $table"
    done
fi

# Compare the columns of tables with the same name between the two databases
for common_table in $DB1_TABLES; do
    if [[ " $DB2_TABLES " =~ " $common_table " ]]; then
        echo "Comparing columns for table: $common_table"
        # Get column names from database 1
        DB1_COLUMNS=$(E:\\wamp64\\bin\\mysql\\mysql8.0.27\\bin\\mysql.exe -h$DB1_HOST -u$DB1_USER -p$DB1_PASS -D$DB1_NAME -e "SHOW COLUMNS FROM $common_table;" | awk '{print $1}')

        # Get column names from database 2
        DB2_COLUMNS=$(E:\\wamp64\\bin\\mysql\\mysql8.0.27\\bin\\mysql.exe -h$DB2_HOST -u$DB2_USER -p$DB2_PASS -D$DB2_NAME -e "SHOW COLUMNS FROM $common_table;" | awk '{print $1}')

        # Compare column names and find differences
        DIFFERENCE_COLUMNS=$(diff <(echo "$DB1_COLUMNS") <(echo "$DB2_COLUMNS") | grep -E "^<|>")

        if [ -z "$DIFFERENCE_COLUMNS" ]; then
            echo "Columns are the same for table: $common_table"
        else
            echo "Columns are different for table: $common_table"
            echo "Differences:"
            echo "$DIFFERENCE_COLUMNS"
        fi
    fi
done
