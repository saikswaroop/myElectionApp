library(shiny)

shinyUI(fluidPage(
  
  # Application title
  #titlePanel(h1("Indian General Election 2014 Result Analysis",align="center")),
  titlePanel("Indian General Election 2014 Result Analysis"),
  
  sidebarLayout(
    
    # Sidebar with a slider input
    sidebarPanel(
      selectInput("state",label="State/UT",
                  choices = c("India","Andaman & Nicobar Islands","Andhra Pradesh","Arunachal Pradesh","Assam","Bihar","Chandigarh","Chhattisgarh","Dadra & Nagar Haveli","Daman & Diu","Goa","Gujarat","Haryana","Himachal Pradesh","Jammu & Kashmir","Jharkhand","Karnataka","Kerala","Lakshadweep","Madhya Pradesh","Maharashtra","Manipur","Meghalaya","Mizoram","Nagaland","NCT OF Delhi","Odisha","Puducherry","Punjab","Rajasthan","Sikkim","Tamil Nadu","Tripura","Uttar Pradesh","Uttarakhand","West Bengal") ,selected="India"
                  )
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
#      imageOutput("statePlot"),
#      textOutput("info")
      tabsetPanel(
        tabPanel('Vote Distribution',
                 imageOutput("statePlot")),
        tabPanel('Seats Distribution',
                 imageOutput("seatPlot"))
      )
    )
  )
))