library(shiny)

function(input, output) {
  output$cityName <- renderText( { input$city } )
}