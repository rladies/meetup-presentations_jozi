

library(shiny)
ui<-fluidPage(
# Application title
titlePanel("The Simplest App Ever"),

p("You can add text to your page, and specify many parameters"),
# Sidebar with a radio input for the colours
sidebarLayout(
  sidebarPanel(
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
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
  output$distPlot <- renderPlot({
    
    
    hist(iris$Petal.Length, col = input$col,main="Histogram of the Petal Length of Flowers", xlab="Length of Petals")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

