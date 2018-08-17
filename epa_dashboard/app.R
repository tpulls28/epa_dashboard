#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


# Can be used to run a shiny app from a GitHub repo 
# runGitHub("epa_dashboard", "citysystems", subdir = "epa_dashboard")
# setwd("C:\\Users\\Derek\\Documents\\GitHub\\epa_dashboard\\epa_dashboard")
rm(list = ls())


library(shiny)
library(googlesheets)
library(dplyr)
library(leaflet)

load(".RData")
load("parcel_data.RData")


input_options <- parcel_data.shape@data$address

# Define UI for application
ui <- fluidPage(
  
  # Application title
  titlePanel("EPA Second Unit Dashboard"),
  
  # Sidebar 
  sidebarLayout(
    sidebarPanel(
      
      selectizeInput("address", "Enter address here:", input_options),
      actionButton("go", "Go!")
    ),
    
    
    mainPanel(
      # dataTableOutput("parcel_df")
      textOutput("parcel_df"),
      textOutput("parcel_info"),
      leafletOutput("map")
    )
  )
)

# Define the server logic 
server <- function(input, output) {
  
  # output$parcel_df <- renderDataTable({
  #   observeEvent(input$parcel, filter(parcel_data, APN == input$parcel))
  # })
  
  type <- eventReactive(input$go, {type <- filter(parcel_data.shape@data, address == input$address)$adu_type[1]})
  
  output$parcel_info <- renderText({gen_report(type())})
  
  observeEvent(input$go, {
    index <- which(parcel_data.shape@data$address == input$address)
    output$map <- renderLeaflet({make_map(parcel_data.shape[index,])})
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

