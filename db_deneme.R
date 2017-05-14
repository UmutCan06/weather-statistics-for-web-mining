
# DB Connect[1,]
db <- dbConnect(SQLite(), dbname="Test.sqlite")
sqldf("attach `Test.sqlite` as new")

dbSendQuery(conn = db,
            "CREATE TABLE School
            (SchID INTEGER,
              Location TEXT,
              Authority TEXT,
              SchSize TEXT)")

dbSendQuery(conn = db, "INSERT INTO School VALUES (1, 'urban', 'state', 'medium')")
dbSendQuery(conn = db, "INSERT INTO School VALUES (2, 'urban', 'independent', 'large')")
dbSendQuery(conn = db, "INSERT INTO School VALUES (3, 'rural', 'state', 'small')")

dbListTables(db)              # The tables in the database
dbListFields(db, "School")    # The columns in a table
dbReadTable(db, "School")     # The data in a table

dbRemoveTable(db, "School")     # Remove the School table.

##################################################
