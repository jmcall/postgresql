library(RPostgres)
library(RPostgreSQL)
library(DBI)

#Establish Database Connection

drv <- dbDriver("PostgreSQL")

con <- dbConnect(drv, 
                 dbname = "postgres",
                 host = "127.0.0.1", 
                 port = "5432",
                 user = "", 
                 password = "")

#List Database Tables

dbListTables(con)

#Pull in Test Data

df = mtcars

df = tibble::rownames_to_column(df, "make")

#Create table via sql query

dbExecute(con, "CREATE TABLE mtcars (
          make TEXT PRIMARY KEY, 
          mpg FLOAT,
          cyl FLOAT,
          disp FLOAT,
          hp FLOAT,
          drat FLOAT,
          wt FLOAT,
          qsec FLOAT,
          vs FLOAT,
          am FLOAT,
          gear FLOAT,
          carb FLOAT)")

#Read Database table

df1 = dbReadTable(con, "mtcars")

df2 = dbGetQuery(con, "SELECT * FROM mtcars")

#Setup Modified Test Data

mtcars2 <- subset(mtcars, hp >= 150)

mtcars2 = tibble::rownames_to_column(mtcars2, "make")

mtcars2$mpg = 99

#Update Database Table with Test Data

dbWriteTable(con, "temp", mtcars2, append = TRUE,temporary = FALSE, row.names = FALSE)

dbSendQuery(con, 'UPDATE mtcars SET mpg = temp.mpg FROM temp WHERE temp.make = mtcars.make')

dbSendQuery(con, "DROP TABLE temp")

#Drop Database Table

dbSendQuery(con, "DROP TABLE mtcars")

#Disconnect

dbDisconnect(con) 
