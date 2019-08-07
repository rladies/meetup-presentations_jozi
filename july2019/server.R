# Very very simple app

library(shiny)

# Define server logic required 
shinyServer(function(input, output) {
  
  output$distPlot <- renderPlot({
 data<-switch(input$var,
              "Petal Length"=iris$Petal.Length,
              "Petal Width"=iris$Petal.Width,
              "Sepal Length"=iris$Sepal.Length,
              "Sepal Width"=iris$Sepal.Width)
    xl<-switch(input$var,
               "Petal Length"="Petal Length",
               "Petal Width"="Petal Width",
               "Sepal Length"="Sepal Length",
               "Sepal Width"="Sepal Width")
    heading<-switch(input$var,
                    "Petal Length"="Histogram of the Petal Length",
                    "Petal Width"="Histogram of the Petal Width",
                    "Sepal Length"="Histogram of the Sepal Length",
                    "Sepal Width"="Histogram of the Sepal Width")
    # draw a histogram with the colour being specified
    par(mfrow=c(1,2))
    hist(data , col = input$col,main=heading, xlab=xl)
    boxplot(data, col=input$col)
  })
  
})
