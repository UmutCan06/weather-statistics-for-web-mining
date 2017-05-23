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
  
  get.plot.data <-  reactive({
    # print(get.the.data())
    data <- get.the.data()
    data <- data[c(2:14)]
    data <- as.data.frame(t(data))
    
    colnames(data) <- c("Deger")
    x <- factor(rownames(data), levels = rownames(data))

    bar <- ggplot(data=data, aes(x=x,y=Deger))
    bar <- bar + geom_bar(stat="identity")
    
    print(bar)
  }) 
  
  output$outputFor <- renderText({
    city.link <- gsub("il=", "", session$clientData$url_search, fixed = TRUE)
    city.link <- gsub("?", "", city.link, fixed = TRUE)
    paste("The result shown by", city.link)
  })
  output$outputTable <- renderTable(get.the.data())
  
  output$outputPlot <- renderPlot(get.plot.data())
  
  # output$outputTable <- renderDataTable(get.the.data())
}