#Very very basic app

library(shiny)

# Define UI for application 
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Leveling Up"),
  
  # Sidebar with a radio input for the colours
  sidebarLayout(
    sidebarPanel(
       selectInput("var",
                label=  "Variable",
               choices= c("Petal Length","Petal Width", "Sepal Length","Sepal Width")),
                
       radioButtons("col",
                   label="Choose your favourite Colour",
                   choices=c("Red"="red",
                             "Blue"="blue",
                             "Yellow"="yellow",
                             "Green"="green"))
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
       )
  ))
)
