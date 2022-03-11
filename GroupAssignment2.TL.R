library(shiny)
library(semantic.dashboard)
library(ggplot2)
library(plotly)
library(DT)
library(fpp3)
library(ggpubr)
library(plotly)


library(quantmod)
library(tidyquant)





SYMBOLS <- stockSymbols()

ui <- dashboardPage(
  dashboardHeader(color = "blue",title = "Stock Price Data", inverted = TRUE),
  dashboardSidebar(
    size = "thin", color = "teal",
    sidebarMenu(
      menuItem(tabName = "main", "Select a Stock"),
      menuItem(tabName = "extra", "Your Stock Performance Compared to Major Performances")
    )
  ),
  dashboardBody(
    tabItems(
      selected = 1,
      tabItem(
        tabName = "extra",
        fluidRow(
          box(width = 8,
              title = "4 Major Companies",
              color = "green", ribbon = TRUE, title_side = "top right",
              column(width = 8,
                     plotlyOutput("dotplot")
              )
          ),
          box(width = 8,
              title = "Graph 2",
              color = "red", ribbon = TRUE, title_side = "top right",
              column(width = 8,
                     plotlyOutput("dotplot1")
              )
          )
        )
      ),
      tabItem(
        tabName = "main",
        fluidPage(
          textInput("text", label = h3("Select a Stock"), value = "Enter Stock Symbol"),
          
          hr(),
          fluidRow(column(3, verbatimTextOutput("value")))
          
        )
        
      )
    )
  ), theme = "cerulean"
)


server <- shinyServer(function(input, output, session) {
  start <- as.Date("2016-01-01")
  end <- as.Date("2022-01-01")
  interest_stocks <- c("AAPL", "MSFT", "GOOG", "AMZN")
  Stocks <- tq_get(interest_stocks, from = start, to = end)
  output$dotplot <- renderPlotly({
    ggplotly(ggplot(Stocks, aes(date, close)) + geom_point(aes(date, close, color = symbol)))
  })
  interest_stocks2 <- c("AAPL", "MSFT", "GOOG", "AMZN")
  Stocks2 <- tq_get(interest_stocks, from = start, to = end)
  output$dotplot1 <- renderPlotly({
    ggplotly(ggplot(Stocks2, aes(date, close)) + geom_point(aes(date, close, color = symbol)))
  })
  
  output$dotplot1 <- renderPlotly({
    ggplotly(ggplot(mtcars, aes(wt, mpg))
             + geom_point(aes(colour=factor(cyl), size = qsec))
             + scale_colour_manual(values = colscale)
    )
  })
  output$value <- renderPrint({ input$text })
  

})
shinyApp(ui, server)


  
