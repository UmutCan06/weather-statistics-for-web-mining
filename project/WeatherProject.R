getwd()
setwd("/home/umutcan/Desktop/Web_mining_R/WebMiningProject")

library(ggplot2)
library(XML)
library(httr)

URL <- paste("https://www.mgm.gov.tr/veridegerlendirme/il-ve-ilceler-istatistik.aspx?m=ADANA")
tables <- readHTMLTable(URL)

tables <- GET ("https://www.mgm.gov.tr/veridegerlendirme/il-ve-ilceler-istatistik.aspx?m=ADANA")
TableAdana <- readHTMLTable (rawToChar (tables$content), which=1 )
TableAdana2 <- readHTMLTable (rawToChar (tables$content), which=2 )


TableAdana <- TableAdana[-c(1,8), ]

colnames(TableAdana) <- c("ADANA", "OCAK", "SUBAT", "MART", "NISAN", "MAYIS", "HAZIRAN", "TEMMUZ", "AGUSTOS", "EYLUL", "EKIM", "KASIM", "ARALIK", "YILLIK")

TableAdana[1] <- c("Ortalama Sicaklik", "Ortalama En Yuksek Sicaklik", "Ortalama En Dusuk Sicaklik", "Ortalama Guneslenme Suresi(saat)", "Ortalama Yagisli Gun Sayisi", "Aylik Toplam Yagis Mik. Ort.", "En Yuksek Sicaklik","En Dusuk Sicaklik")


for(i in c(2:length(TableAdana))) {
  TableAdana[,i] <- as.numeric ( levels ( TableAdana[,i]))[ TableAdana[,i]]
}

TableAdana$YILLIK <- mean(TableAdana)