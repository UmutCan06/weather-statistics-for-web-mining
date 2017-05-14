library(shiny)

function(input, output) {
  get.the.data <- reactive({
    file.name <- paste("data", input$stats_type, sep="/")
    data <- read.csv(file.name)
    data
  })
  
  output$outputTable <- renderTable(get.the.data())
  # output$outputTable <- renderDataTable(get.the.data())
}