library(shiny)

function(input, output, session) {

  get.city.link <- function() {
    
  }
  
  get.city.id <- function() {
    city.link <- gsub("il=", "", session$clientData$url_search, fixed = TRUE)
    city.link <- gsub("?", "", city.link, fixed = TRUE)
    
    cities <- read.csv("data/Sehir.csv")
    city.id <- cities$id[cities$url == city.link]
    city.id
  }
  
  get.the.data <- reactive({
    file.name <- paste("data", input$stats_type, sep="/")
    data <- read.csv(file.name)
    city.id = get.city.id()
    data[city.id, ]
  })
  
  output$outputFor <- renderText({
    city.link <- gsub("il=", "", session$clientData$url_search, fixed = TRUE)
    city.link <- gsub("?", "", city.link, fixed = TRUE)
    paste("The result shown by", city.link)
  })
  output$outputTable <- renderTable(get.the.data())
  
  # output$outputTable <- renderDataTable(get.the.data())
}