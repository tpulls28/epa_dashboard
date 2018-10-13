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
library(shinydashboard)

load(".RData")

input_options <- parcel_data$address

# Define UI for application
ui <- fluidPage(
  navbarPage("EPA Garage Conversion Dashboard",
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
                            addition of a bedroom and bathroom to the existing home and can be used as
                            a guest house."),
                       br(),
                       br(),
                       strong("3. Bedroom + Bathroom + Kitchen:"),
                       span("This project is considered 
                            not a garage conversion but an attached second unit, 
                            which can be rented out separately from the main house. Many other 
                            development standards apply; refer to ___."),
                       br(),
                       h3("Project Costs"),
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
                       span("In past projects, these conditions have added $___-___ to the project budget."),
                       h3("Special Circumstances"), 
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
                       ),
             tabPanel("Project Planning Tool",
                      # Sidebar 
                      sidebarLayout(
                        sidebarPanel(
                          helpText("If you are a property owner in East Palo Alto, the following step-by-step tool 
                                   is designed to help you decide if a garage conversion is right for you and guide you 
                                   to useful resources. The information is based on averages from similar projects
                                   in the past, but are not meant to be precise or final. Porfessional consultation
                                   is necessary to validate these rough estimates."),
                          selectizeInput("address", "Enter address here:", input_options),
                          actionButton("go", "Go!"),
                          br(),
                          br(),
                          p("Based on public records, we have made the 
                           following estimates. You are welcome to make modifications 
                           to these numbers if you feel they are off."),
                         numericInput("lot_size", 
                                      span("Lot Size"), 
                                      value = 1),
                         numericInput("building_footprint", 
                                      span("Building Footprint"), 
                                      value = 1),
                         numericInput("assessed_val", 
                                      span("Current Assessed Value"), 
                                      value = 1),
                         numericInput("num_bedrooms", 
                                      span("Current Number of Bedrooms"), 
                                      value = 1),
                         br(),
                         strong("The next few questions will help you identify cost drivers."),
                         radioButtons("garage_lw", 
                                            h5("What’s the estimated length and width of my garage?"), 
                                            choices = list("Choice 1" = 1, 
                                                           "Choice 2" = 2, 
                                                           "Choice 3" = 3),
                                            selected = 1),
                         radioButtons("water_heater", 
                                            h5("Is there a water heater in my garage?"), 
                                            choices = list("Yes" = 1, 
                                                           "No" = 2, 
                                                           "I don't know" = 3),
                                            selected = 1),
                         radioButtons("electrical_panel", 
                                            h5("Is my electrical panel or meter within 3ft of my gas meter?"), 
                                            choices = list("Yes" = 1, 
                                                           "No" = 2, 
                                                           "I don't know" = 3),
                                            selected = 1),
                         radioButtons("structural_mods", 
                                            h5("Are there any known structural modifications to garage floor, walls, or ceiling?"), 
                                            choices = list("Yes" = 1, 
                                                           "No" = 2, 
                                                           "I don't know" = 3),
                                            selected = 1),
                         radioButtons("ceiling_joists", 
                                            h5("Is there attic access? If so, and if you can inspect the attic, what’s the size and spacing of ceiling joists?"), 
                                            choices = list("Choice 1" = 1, 
                                                           "Choice 2" = 2, 
                                                           "Choice 3" = 3),
                                            selected = 1),
                         radioButtons("ventilation", 
                                            h5("Does there appear to be ventilation in the ceiling space? From the outside of the garage, can you see evenly spaced holes where the roof meets the wall?"), 
                                            choices = list("Yes" = 1, 
                                                           "No" = 2, 
                                                           "I don't know" = 3),
                                            selected = 1),
                         radioButtons("exterior_door", 
                                            h5("Is there a normal exterior door on your garage?"), 
                                            choices = list("Yes" = 1, 
                                                           "No" = 2, 
                                                           "I don't know" = 3),
                                            selected = 1),
                         radioButtons("exterior_door_pt2", 
                                            h5("If you answered yes to the last question, does it have a 3ft by 3ft landing outside?"), 
                                               choices = list("Yes" = 1, 
                                                             "No" = 2, 
                                                             "I don't know" = 3,
                                                             "I didn't answer yes"),
                                                              selected = 1),

                         radioButtons("glass_area", 
                                            h5("What’s the estimated total area of glass in windows or doors in the garage?"), 
                                            choices = list("Choice 1" = 1, 
                                                           "Choice 2" = 2, 
                                                           "Choice 3" = 3),
                                            selected = 1),
                         radioButtons("bathroom", 
                                            h5("Are you considering adding a bathroom?"), 
                                            choices = list("Yes" = 1, 
                                                           "No" = 2, 
                                                           "I don't know" = 3),
                                            selected = 1),
                         radioButtons("kitchen", 
                                            h5("Are you considering adding a kitchen?"), 
                                            choices = list("Yes" = 1, 
                                                           "No" = 2, 
                                                           "I don't know" = 3),
                                            selected = 1),
                         radioButtons("fire_sprinkler", 
                                            h5("(Fire sprinkler question)"), 
                                            choices = list("Choice 1" = 1, 
                                                           "Choice 2" = 2, 
                                                           "Choice 3" = 3),
                                            selected = 1),
                          br(),
                          h4("Disclaimers:"),
                          p("This is an educational tool and not a substitute for professional advice and consultation."),
                          p("Real costs and conditions may vary."),
                          p("The City of East Palo Alto is not liable to the user for any damages arising from the use of this tool."),
                          p("No personal information is stored in the use of this tool. At the end of this session, you are given the option to download results to your own device."),
                          p("Questions about or issues with this tool should be directed to ___."),
                          style = "height:700px;overflow-y: scroll"
                        ),
                        mainPanel(
                          fluidRow(
                            column(6,
                          leafletOutput("map", height = '500px'),
                          br(),
                          textOutput("costAlert")
                            ),
                          column(6,
                                 # dataTableOutput("parcel_df")
                                 #textOutput("parcel_df"),
                                 #valueBoxOutput('structureVal'),
                                 #valueBoxOutput("parcel_area"),
                                 #valueBoxOutput('cost_estimate'),
                                 #valueBox(textOutput('structureVal'), strong("Building Value"), icon = icon("usd"), color = 'green'),
                                 #tags$head(tags$style("#structureVal{
                                 #font-size: 14px; height: 50px;
                                #                      }"
                                 #)
                                 #),
                                 #valueBox(textOutput('parcel_area'), strong("Parcel Area"), icon = icon("home"), color = 'yellow'),
                                 #tags$head(tags$style("#parcel_area{
                                 #font-size: 14px; height: 50px;
                                  #                    }"
                                 #)
                                 #),
                                 #valueBox(textOutput("cost_estimate"), strong("Estimated Construction Cost"), icon = icon("pencil"), color = 'orange'),
                                 #tags$head(tags$style("#cost_estimate{
                                 #font-size: 14px; height: 55px;
                                  #                    }"
                                # )
                                 #),
                                 box(textOutput("parcel_info"),height = '60%', width = '100%'),
                                 tags$head(tags$style("#parcel_info{
                                 font-size: 14px; vertical-align: middle;
                                                      }"
                                 )
                                 ),
                                br(),
                                strong(textOutput("structureVal")),
                                br(),
                                strong(textOutput("parcel_area")),
                                br(),
                                strong("Itemized Costs"),
                                tableOutput("itemizedCosts")      
                          ) 
                        )
                      )
              )
    ),
    tabPanel("Export Final Construction Cost Estimate",
             strong("Itemized Costs"),
             tableOutput("itemizedCosts2")
    )
  )
)

# Define the server logic 
server <- function(input, output, session) {
  
  # output$parcel_df <- renderDataTable({
  #   observeEvent(input$parcel, filter(parcel_data, APN == input$parcel))
  # })
  cost <- 0
  
  type <- eventReactive(input$go, {type <- filter(parcel_data.shape@data, address == input$address)$adu_type[1]})
  
  area_sqf <- eventReactive(input$go, {area_sqf <- filter(parcel_data, address == input$address)$area_sqf[1]})
  
  #This needs to be fixed
  
  structure_val <- eventReactive(input$go, {structure_val <- as.character(filter(parcel_data, address == input$address)$IMPROVEMEN[1])})
  
  sfha_flag <- eventReactive(input$go, {sfha_flag <- filter(parcel_data, address == input$address)$SFHA_FLAG[1]})
  
  flood_flag <- eventReactive(input$go, {flood_flag <- filter(parcel_data, address == input$address)$FLOOD_FLAG[1]})
  
  lotSize <- eventReactive(input$go, {lotSize <- filter(parcel_data, address == input$address)$AREA[1]})
  
  buildingFootprint <- eventReactive(input$go, {buildingFootprint <- filter(parcel_data, address == input$address)$area_sqf[1]})
  
  assessedVal <- eventReactive(input$go, {assessedVal <- filter(parcel_data, address == input$address)$assdTotVal[1]})
  
  numBedrooms <- eventReactive(input$go, {numBedrooms <- filter(parcel_data, address == input$address)$FLOOD_FLAG[1]})
  
  output$parcel_info <- renderText({gen_report(type(), sfha_flag(), flood_flag())})
  
  output$cost_estimate <- renderText({paste("$", updateCost(arrayOfQuestions))})
  
  observeEvent({
    input$garage_lw
    input$water_heater
    input$electrical_panel
    input$structural_mods
    input$ceiling_joists
    input$ventilation
    input$exterior_door
    input$exterior_door_pt2
    input$glass_area
    input$bathroom
    input$kitchen
    input$fire_sprinkler
  },{
    arrayOfQuestions <- list(input$garage_lw,input$water_heater,input$electrical_panel,input$structural_mods,
                             input$ceiling_joists,input$ventilation,input$exterior_door,input$exterior_door_pt2,
                             input$glass_area,input$bathroom,input$kitchen,input$fire_sprinkler)
    output$cost_estimate <- renderText({paste("$", updateCost(arrayOfQuestions))})
    dataTable <- data.frame(
      Item = c("Question 1",
               "Question 2",
               "Question 3",
               "Question 4",
               "Question 5",
               "Question 6",
               "Question 7",
               "Question 8",
               "Question 9",
               "Question 10",
               "Question 11",
               "Question 12",
               'Total Cost'),
      Cost = as.character(c(input$garage_lw,input$water_heater,input$electrical_panel,input$structural_mods,
                            input$ceiling_joists,input$ventilation,input$exterior_door,input$exterior_door_pt2,
                            input$glass_area,input$bathroom,input$kitchen,input$fire_sprinkler,updateCost((arrayOfQuestions)))),
      stringsAsFactors = FALSE)
    output$itemizedCosts <- renderTable(dataTable)
    output$itemizedCosts2 <- renderTable(dataTable)
  })
  
  observeEvent(input$go, {
    index <- which(parcel_data.shape@data$address == input$address)
    output$map <- renderLeaflet({make_map(parcel_data.shape[index,])})
    arrayOfQuestions <- list(input$garage_lw,input$water_heater,input$electrical_panel,input$structural_mods,
                             input$ceiling_joists,input$ventilation,input$exterior_door,input$exterior_door_pt2,
                             input$glass_area,input$bathroom,input$kitchen,input$fire_sprinkler)
    output$cost_estimate <- renderText({paste("$", updateCost((arrayOfQuestions)))})
    dataTable <- data.frame(
      Item = c("Question 1",
               "Question 2",
               "Question 3",
               "Question 4",
               "Question 5",
               "Question 6",
               "Question 7",
               "Question 8",
               "Question 9",
               "Question 10",
               "Question 11",
               "Question 12",
               'Total Cost'),
      Cost = as.character(c(input$garage_lw,input$water_heater,input$electrical_panel,input$structural_mods,
                            input$ceiling_joists,input$ventilation,input$exterior_door,input$exterior_door_pt2,
                            input$glass_area,input$bathroom,input$kitchen,input$fire_sprinkler,updateCost((arrayOfQuestions)))),
      stringsAsFactors = FALSE)
    output$itemizedCosts <- renderTable(dataTable)
    output$itemizedCosts2 <- renderTable(dataTable)
    updateNumericInput(session, "lot_size", value = as.integer(lotSize()))
    updateNumericInput(session, "building_footprint", value = as.integer(buildingFootprint()))
    updateNumericInput(session, "assessed_val", value = as.integer(assessedVal()))
    updateNumericInput(session, "num_bedrooms", value = as.integer(numBedrooms()))
    output$structureVal <- renderText({paste("Building Value:", structure_val())})
    output$parcel_area <- renderText({paste("Lot Area:", as.integer(buildingFootprint()), 'square feet')})
    if(as.numeric(updateCost(arrayOfQuestions)) >= 0.4 * as.numeric(gsub('[$,]', '',structure_val()))){
      output$costAlert <- renderText("You are at risk of your project exceeding 50% of the building's value. 
                                     Projects of this size may require further city regulation.")
    }
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
