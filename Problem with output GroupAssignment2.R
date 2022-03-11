library(shiny)
library(shinydashboard)
library(semantic.dashboard)
library(ggplot2)
library(plotly)
library(DT)
library(fpp3)
library(ggpubr)
library(plotly)

library(tidyverse)
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
              title = "Your Chosen Stock",
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
          
          
          selectInput(inputId = "select", label = h3("Choose a Stock"), 
                      choices = names(table(SYMBOLS$Name)), 
                      selected = 1)
          
          
          
        )
        
      )
    )
  )
)


server <- shinyServer(function(input, output) {
  start <- as.Date("2016-01-01")
  end <- as.Date("2022-01-01")
  interest_stocks <- c("AAPL", "MSFT", "GOOG", "AMZN")
  Stocks <- tq_get(interest_stocks, from = start, to = end)
  output$dotplot <- renderPlotly({
    ggplotly(ggplot(Stocks, aes(date, close)) + geom_point(aes(date, close, color = symbol)))
  })
  
  output$value <- renderPrint({SYMBOLS$Symbol[which(SYMBOLS$Name == input$select)]})
  
  interest_stocks2 <- getSymbols({SYMBOLS$Symbol[which(SYMBOLS$Name == input$select)]})
  Stocks2 <- tq_get(reactive(interest_stocks2, from = start, to = end))
  #Stocks2 <- Symbols21 %>% filter(symbol %in% input$select)
  
  
   output$dotplot1 <- renderPlotly({
    ggplotly(ggplot(Stocks2, aes(date, close)) + geom_point(aes(date, close, color = symbol)))
  })
  
  
})
shinyApp(ui, server)

