library(DBI)
library(RSQLite)

con <- dbConnect(RSQLite::SQLite(),dbname='data/ecommerce.db')
result <- dbSendQuery(con,"select * from customers")
while(!dbHasCompleted(result)){
  ds <-   dbFetch(result,n=1000)
}

dbClearResult(result)
dbDisconnect(con)
ds
