library(shiny)

vars <- c(
  "Ortalama Sıcaklık" = "Ortalama.Sicaklik.csv",
  "Ortalama En Düşük Sıcaklık" = "Ort.En.Dusuk.Sicaklik.csv",
  "Ortalama En Yüksek Sıcaklık" = "Ort.En.Yuksek.Sicaklik.csv",
  "Ortalama Güneşlenme Süresi (saat)" = "Ort.Guneslenme.Suresi.csv",
  "Ortalama Yağışlı Gün Sayısı" = "Ort.Yagisli.Gun.Sayisi.csv",
  "En Düşük Sıcaklık" = "En.Dusuk.Sicaklik.csv",
  "En Yüksek Sıcaklık" = "En.Yuksek.Sicaklik.csv",
  "Aylık Toplam Yağış Miktarı Ortalaması" = "Aylik.Toplam.Yagis.Mik.Ort.csv"
)

sehirler <- read.csv("data/Sehir.csv")

fluidPage(

  pageWithSidebar(
    
    # Application title
    headerPanel("Weeather Statistics for Turkey"),
    
    # Sidebar with a slider input
    sidebarPanel(
      textInput(inputId = "city", label = "Your city choice is ", placeholder = "Select or Enter a City"),
      selectizeInput(inputId = "stats_type", label = "Select a Statistics Type", vars)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      includeScript("js/jquery-1.12.4.min.js"),
      includeScript("js/svg-turkiye-haritasi.js"),
      
      includeHTML('svg-TR-map.html')
    )
  ),
  
  mainPanel(
    tableOutput("outputTable")
    # dataTableOutput("outputTable")
  )
)
