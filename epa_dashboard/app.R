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
  navbarPage("EPA Second Unit Dashboard",
    tabPanel("About", 
       tabsetPanel(type = "tabs",
         tabPanel("Overview",
          h3("Project Types"),
          span("There are three main retrofit options to a garage:"),
          br(),
          br(),
          strong("1. Bedroom:"), 
          span("This is the simplest and lowest-cost project. 
          It is considered the addition of a bedroom to the existing home."),
          br(),
          br(),
          strong("2. Bedroom + Bathroom:"),
          span("Adding new plumbing can significantly 
          increase the cost and complexity of the project. This can be considered the 
          addition of a bedroom and bathroom to the existing home, or used as
          a guest house."),
          br(),
          br(),
          strong("3. Bedroom + Bathroom + Kitchen:"),
          span("This project is considered 
          not a garage conversion but an attached second unit, 
          which can be rented out separately from the main house. Many other 
          development standards apply; refer to ___.")
       ),
       tabPanel("Project Costs",
        br(),
        strong("Standard project costs run a minimum of $___ and include:"),
        br(),
        tags$div(tags$ul(
          tags$li("Reframing the garage door, including a concrete curb"),
          tags$li("Sealing the garage floor"),
          tags$li("Adding insulation"),
          tags$li("Installing a heating source"),
          tags$li("Finishing the interiors"),
          tags$li("Electrical upgrades and additions"),
          tags$li("Upgrading water-efficient plumbing fixtures in whole home"),
          tags$li("Soft costs for design and engineering services"),
          tags$li("Permit and development fees "))
          ),
        p("As a permitted building project, a garage conversion may uncover 
        details that are out of compliance with current codes, or introduce 
        unexpected complexities. Some of the major added cost drivers may include:"),
        tags$div(tags$ul(
          tags$li("Removal of existing attic insulation to be able to properly inspect ceiling details"),
          tags$li("Raising the floor if the house is in a special flood hazard area and project costs exceed 50% of assessed value of the structure"),
          tags$li("Retrofits of structural elements if they are out of compliance"),
          tags$li("Movement of water heater or electrical panel depending on existing location"),
          tags$li("Nonstandard solutions for Title 24 energy efficiency compliance"),
          tags$li("Addition of windows to meet natural light requirements"),
          tags$li("Costs of bathroom and kitchen additions (if eligible)"))
        ),
        p("In past projects, these conditions have added $___-___ to the project budget.")
       ),
       tabPanel("Special Circumstances", 
        br(),
        strong("There are two special circumstances to be aware of:"),
        br(),
        p("1. Some properties may be ineligible because the removal of a garage space and 
          addition of a bedroom create a parking demand that cannot be accommodated in an 
          existing driveway, or for other reasons. An attached or detached second unit project 
          that does not involve the garage may still be feasible."),
        p("2. If a garage has already been converted into a habitable 
        space without a building permit, these existing modifications may present 
        serious life safety issues, and bringing them into compliance may have even greater cost 
        drivers than starting a garage conversion project from scratch. Homeowners in this situation 
        should seek consultation from a network of support organizations as soon as possible to find a 
        safe and affordable path forward.")
       )
      )
    ),
    tabPanel("Project Planning Tool",
      # Sidebar 
      sidebarLayout(
        sidebarPanel(
          helpText("If you are a property owner in East Palo Alto, the following step-by-step tool 
                   is designed to help you decide if a garage conversion is right for you and guide you 
                   to useful resources."),
          selectizeInput("address", "Enter address here:", input_options),
          actionButton("go", "Go!"),
          br(),
          h4("Disclaimers:"),
          p("This is an educational tool and not a substitute for professional advice."),
          p("Real costs and conditions may vary."),
          p("The City of East Palo Alto is not liable to the user for any damages arising from the use of this tool."),
          p("No personal information is stored in the use of this tool. At the end of the tool, you are given the option to download results to your own device."),
          p("Questions about or issues with this tool should be directed to ___.")
        ),
        
        
        mainPanel(
          # dataTableOutput("parcel_df")
          textOutput("parcel_df"),
          textOutput("parcel_info"),
          leafletOutput("map")
        )
      )
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

