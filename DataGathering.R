
# Initialization

getwd()
# setwd("/home/umutcan/Desktop/WebMining")
setwd("/media/molcay/data/Projects/WorkspaceR/Web Mining/weather-statistics-for-web-mining/project")

packages = c("ggplot2", "XML", "httr", "xml2", "rvest", "sqldf", "XLConnect")
package.check <- lapply(packages, FUN = function(x) {
  if (!require(x, character.only = TRUE)) {
    install.packages(x, dependencies = TRUE)
    library(x, character.only = TRUE)
  }
})

##################################################

# Getting Cities and URLs
URL <- paste("https://www.mgm.gov.tr/veridegerlendirme/il-ve-ilceler-istatistik.aspx")
raw.html <- read_html(URL)

sehirler.div <- html_nodes(raw.html , ".kk_div1 a" )
sehir.adi <- html_text(sehirler.div)
sehir.url <- html_attr(sehirler.div, "href")

sehir.url <- gsub("m=", "", sehir.url, fixed = TRUE)
sehir.url <- gsub("?", "", sehir.url, fixed = TRUE)

sehir.info.df <- data.frame(c(1:length(sehir.url)), sehir.adi, sehir.url)
colnames(sehir.info.df) <- c("id", "sehir", "mgm_url")
write.csv(sehir.info.df, "data/Sehir.csv", row.names = FALSE)

##################################################

GetWeatherStatsForTurkey <- function(sehirurl) {
  # Getting main data
  URL <- paste("https://www.mgm.gov.tr/veridegerlendirme/il-ve-ilceler-istatistik.aspx?m=", sehirurl, sep="")
  tables <- GET(URL)
  TableSehir <- readHTMLTable (rawToChar (tables$content), which=1 )
  
  # Manupilating DataFrame
  TableSehir <- TableSehir[-c(1,8), ]
  colnames(TableSehir) <- c("SEHIR", "OCAK", "SUBAT", "MART", "NISAN", "MAYIS", "HAZIRAN", "TEMMUZ", "AGUSTOS", "EYLUL", "EKIM", "KASIM", "ARALIK", "YILLIK")
  TableSehir[1] <- c("Ortalama Sicaklik", "Ortalama En Yuksek Sicaklik", "Ortalama En Dusuk Sicaklik", "Ortalama Guneslenme Suresi", "Ortalama Yagisli Gun Sayisi", "Aylik Toplam Yagis Mik. Ort.", "En Yuksek Sicaklik","En Dusuk Sicaklik")
  
  # convert all numeric data from char to numeric
  for(i in c(2:length(TableSehir))) {
    TableSehir[,i] <- as.numeric ( levels ( TableSehir[,i]))[ TableSehir[,i]]
    print(TableSehir[,i])
  }
  
  aylar <- c("OCAK", "SUBAT", "MART", "NISAN", "MAYIS", "HAZIRAN", "TEMMUZ", "AGUSTOS", "EYLUL", "EKIM", "KASIM", "ARALIK")
  
  # Calculating "Yillik" column
  sum1 <- 0
  sum2 <- 0
  i = 1
  numbers <- c(1:8)
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
  
  return(TableSehir)
}

Ortalama.Sicaklik <- data.frame()
Ort.En.Yuksek.Sicaklik <- data.frame()
Ort.En.Dusuk.Sicaklik <- data.frame()
Ort.Guneslenme.Suresi <- data.frame()
Ort.Yagisli.Gun.Sayisi <- data.frame()
Aylik.Toplam.Yagis.Mik.Ort <- data.frame()
En.Yuksek.Sicaklik <- data.frame()
En.Dusuk.Sicaklik <- data.frame()

for (sehir_url in sehir.info.df$url) {
  print(paste(sehir_url, "bilgisi alınıyor..."))
  # Write a for loop for all getting all cities data
  TableSehir <- GetWeatherStatsForTurkey(sehir_url)
  
  Ortalama.Sicaklik <- rbind(Ortalama.Sicaklik, TableSehir[1, ][2:14])
  Ort.En.Yuksek.Sicaklik <- rbind(Ort.En.Yuksek.Sicaklik, TableSehir[2, ][2:14])
  Ort.En.Dusuk.Sicaklik <- rbind(Ort.En.Dusuk.Sicaklik, TableSehir[3, ][2:14])
  Ort.Guneslenme.Suresi <- rbind(Ort.Guneslenme.Suresi, TableSehir[4, ][2:14])
  Ort.Yagisli.Gun.Sayisi <- rbind(Ort.Yagisli.Gun.Sayisi, TableSehir[5, ][2:14])
  Aylik.Toplam.Yagis.Mik.Ort <- rbind(Aylik.Toplam.Yagis.Mik.Ort, TableSehir[6, ][2:14])
  En.Yuksek.Sicaklik <- rbind(En.Yuksek.Sicaklik, TableSehir[7, ][2:14])
  En.Dusuk.Sicaklik <- rbind(En.Dusuk.Sicaklik, TableSehir[8, ][2:14])
  
  Sys.sleep(2)
}

Ortalama.Sicaklik <- data.frame(c(1:length(Ortalama.Sicaklik[,1])), Ortalama.Sicaklik)
colnames(Ortalama.Sicaklik) <- c("ID", colnames(Ortalama.Sicaklik)[2:length(Ortalama.Sicaklik)])
write.csv(Ortalama.Sicaklik, "data/Ortalama.Sicaklik.csv", row.names = FALSE)

Ort.En.Yuksek.Sicaklik <- data.frame(c(1:length(Ort.En.Yuksek.Sicaklik[,1])), Ort.En.Yuksek.Sicaklik)
colnames(Ort.En.Yuksek.Sicaklik) <- c("ID", colnames(Ort.En.Yuksek.Sicaklik)[2:length(Ort.En.Yuksek.Sicaklik)])
write.csv(Ort.En.Yuksek.Sicaklik, "data/Ort.En.Yuksek.Sicaklik.csv", row.names = FALSE)

Ort.En.Dusuk.Sicaklik <- data.frame(c(1:length(Ort.En.Dusuk.Sicaklik[,1])), Ort.En.Dusuk.Sicaklik)
colnames(Ort.En.Dusuk.Sicaklik) <- c("ID", colnames(Ort.En.Dusuk.Sicaklik)[2:length(Ort.En.Dusuk.Sicaklik)])
write.csv(Ort.En.Dusuk.Sicaklik, "data/Ort.En.Dusuk.Sicaklik.csv", row.names = FALSE)

Ort.Guneslenme.Suresi <- data.frame(c(1:length(Ort.Guneslenme.Suresi[,1])), Ort.Guneslenme.Suresi)
colnames(Ort.Guneslenme.Suresi) <- c("ID", colnames(Ort.Guneslenme.Suresi)[2:length(Ort.Guneslenme.Suresi)])
write.csv(Ort.Guneslenme.Suresi, "data/Ort.Guneslenme.Suresi.csv", row.names = FALSE)

Ort.Yagisli.Gun.Sayisi <- data.frame(c(1:length(Ort.Yagisli.Gun.Sayisi[,1])), Ort.Yagisli.Gun.Sayisi)
colnames(Ort.Yagisli.Gun.Sayisi) <- c("ID", colnames(Ort.Yagisli.Gun.Sayisi)[2:length(Ort.Yagisli.Gun.Sayisi)])
write.csv(Ort.Yagisli.Gun.Sayisi, "data/Ort.Yagisli.Gun.Sayisi.csv", row.names = FALSE)

Aylik.Toplam.Yagis.Mik.Ort <- data.frame(c(1:length(Aylik.Toplam.Yagis.Mik.Ort[,1])), Aylik.Toplam.Yagis.Mik.Ort)
colnames(Aylik.Toplam.Yagis.Mik.Ort) <- c("ID", colnames(Aylik.Toplam.Yagis.Mik.Ort)[2:length(Aylik.Toplam.Yagis.Mik.Ort)])
write.csv(Aylik.Toplam.Yagis.Mik.Ort, "data/Aylik.Toplam.Yagis.Mik.Ort.csv", row.names = FALSE)

# En.Yuksek.Sicaklik <- data.frame(c(1:length(En.Yuksek.Sicaklik[,1])), En.Yuksek.Sicaklik)
# colnames(En.Yuksek.Sicaklik) <- c("ID", colnames(En.Yuksek.Sicaklik)[2:length(En.Yuksek.Sicaklik)])
# write.csv(En.Yuksek.Sicaklik, "data/En.Yuksek.Sicaklik.csv", row.names = FALSE)
# 
# En.Dusuk.Sicaklik <- data.frame(c(1:length(En.Dusuk.Sicaklik[,1])), En.Dusuk.Sicaklik)
# colnames(En.Dusuk.Sicaklik) <- c("ID", colnames(En.Dusuk.Sicaklik)[2:length(En.Dusuk.Sicaklik)])
# write.csv(En.Dusuk.Sicaklik, "data/En.Dusuk.Sicaklik.csv", row.names = FALSE)

##################################################

# GGPLOT2
require(ggplot2)

data <- read.csv("data/En.Dusuk.Sicaklik.csv")
data <- data[2,][c(2:14)]
data <- as.data.frame(t(data))

colnames(data) <- c("Deger")
x <- factor(rownames(data), levels = rownames(data))
bar <- ggplot(data=data, aes(x=x,y=Deger))
bar + geom_bar(stat="identity")
