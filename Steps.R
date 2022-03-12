#This is showing dates with closing price 
getSymbols("AAPL", src = "yahoo", from = start, to = end)
par(mfrow = c(2,1))
plot(AAPL$AAPL.Close)

#If you can merge the two together, it should create output we want 
ui <- fluidPage(
  
  # Copy the chunk below to make a group of checkboxes
  checkboxGroupInput("checkGroup", 
                     label = h3("Choose a Stock"), 
                     choices = list("Choice 1" = 1, "Choice 2" = 2, "Choice 3" = 3),
                     selected = 1),
  dateRangeInput("dates", label = h3("Date range")),
  hr(),
  fluidRow(column(4, verbatimTextOutput("value")))
  
)
)


server <- function(input, output) {
  
  # You can access the values of the widget (as a vector)
  # with input$checkGroup, e.g.
  output$value <- renderPrint({ input$checkGroup })
  function(input, output) {
    
    # You can access the values of the widget (as a vector of Dates)
    # with input$dates, e.g.
    output$value <- renderPrint({ input$dates })
  }
}


shinyApp(ui = ui, server = server)