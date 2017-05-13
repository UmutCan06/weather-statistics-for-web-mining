getwd()
setwd("/home/umutcan/Desktop/WebMining")

packages = c("ggplot2", "XML", "httr", "sqldf", "XLConnect", "xml2", "rvest")
package.check <- lapply(packages, FUN = function(x) {
  if (!require(x, character.only = TRUE)) {
    install.packages(x, dependencies = TRUE)
    library(x, character.only = TRUE)
  }
})

#URL MANUPILATING

URL <- paste("https://www.mgm.gov.tr/veridegerlendirme/il-ve-ilceler-istatistik.aspx?m=ADANA")
tables <- readHTMLTable(URL)

tables <- GET ("https://www.mgm.gov.tr/veridegerlendirme/il-ve-ilceler-istatistik.aspx?m=ADANA")
TableSehir <- readHTMLTable (rawToChar (tables$content), which=1 )


content(tables, "text")
content(tables, "raw")

#One time URL manupilating

URL <- paste("https://www.mgm.gov.tr/veridegerlendirme/il-ve-ilceler-istatistik.aspx?m=ADANA")
tables <- read_html(URL)

content1 <- html_nodes(tables , ".kk_div1 a" )
location <- html_text(content1)

sehir_url <- html_attr(content1, "href")

sehir_url <- gsub("m=", "", sehir_url, fixed = TRUE)
sehir_url <- gsub("?", "", sehir_url, fixed = TRUE)

sehir_url


#Manupilating DataFrame

TableSehir <- TableSehir[-c(1,8), ]

colnames(TableSehir) <- c("ADANA", "OCAK", "SUBAT", "MART", "NISAN", "MAYIS", "HAZIRAN", "TEMMUZ", "AGUSTOS", "EYLUL", "EKIM", "KASIM", "ARALIK", "YILLIK")

TableSehir[1] <- c("Ortalama Sicaklik", "Ortalama En Yuksek Sicaklik", "Ortalama En Dusuk Sicaklik", "Ortalama Guneslenme Suresi(saat)", "Ortalama Yagisli Gun Sayisi", "Aylik Toplam Yagis Mik. Ort.", "En Yuksek Sicaklik","En Dusuk Sicaklik")


for(i in c(2:length(TableSehir))) {
  TableSehir[,i] <- as.numeric ( levels ( TableSehir[,i]))[ TableSehir[,i]]
  print(TableSehir[,i])
}

max(TableSehir[c(2:13)][7,][1,])

TableSehir$YILLIK <- mean(TableSehir[c(2:13)][1,][1,])

aylar <- c("OCAK", "SUBAT", "MART", "NISAN", "MAYIS", "HAZIRAN", "TEMMUZ", "AGUSTOS", "EYLUL", "EKIM", "KASIM", "ARALIK")


#Calculeting Yıllık colomun
sum1 <- 0
sum2 <- 0
i = 1
numbers <- c(1,2,3,4,5,6,7,8)
for (i in numbers) {
 
  for (value in aylar){
  
  x <- TableSehir[,value][[i]]
  
  sum1 = sum1 + x
  
  
  }
  
  sum2 = sum1/12
  TableSehir$YILLIK[i] <- round(sum2, digits = 1)
  
  if (i == 4) {
  TableSehir$YILLIK[i] <- round(sum1, digits = 1)
  }
  else if (i == 5) {
    TableSehir$YILLIK[i] <- round(sum1, digits = 1)
  }
  else if (i == 6) {
    TableSehir$YILLIK[i] <- round(sum1, digits = 1)
  }
  else if (i == 7) {
    TableSehir$YILLIK[i] <- max(TableSehir[c(2:13)][i,][1,])
  }
  else if (i == 8) {
    TableSehir$YILLIK[i] <- min(TableSehir[c(2:13)][i,][1,])
  }
  sum1 <- 0
  sum2 <- 0
}



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


