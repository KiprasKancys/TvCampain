library(shiny)

shinyUI(fluidPage(
  
  titlePanel("TV campaign insights"),
  
  sidebarLayout(
    sidebarPanel(
        uiOutput("channelControl"),
        uiOutput("hourControl"),
        uiOutput("xaxis"),
        uiOutput("yaxis"),
        checkboxInput("logTransform", "Use log transformation", TRUE),
        selectizeInput("groups", "Group by", selected = c("Channel", "Hour"), multiple = TRUE,
                       choices = c("Channel", "Day.Of.The.Week", "Hour", "Creative.length", "Week", "Creative.name")),
        h3("Insights"),
        HTML("<ul><li>Some zeros found in the CPL, decided to filter such records out.</li>"),
        HTML("<li>Simplyfied data by picking hours from airing time variable.</li>"),
        HTML("<li>Applied log transformation for CPL on heat map, because of many high values it was hard to", 
                   "see anything. Everything was same color. However if you remove some expensive chanels, you might",
                   "see some differences even without transformation.</li>"),
        HTML("<li>PD12, PD8, PD3 these channels stands out from others, they should be the used.</li>"),
        HTML("<li>Found nothing interesting about Creative length variable.",
             "This rise question whether this data is very synthetic or not.</li>"),
        HTML("<li>Some hours are less expensive than others, by it very much connected with channels.</li>"),
        HTML("<li>I am getting quite strange impresion from Week variable. I thought more times you see the ad",
             "less it is profitable. But in heat map (x-axis chanel, y-axis week) it looks like the oposite.",
             "Probably it is also makes sense.</li>"),
        HTML("<li>Creative name variable is interesting, but I am guessing it is already fixed for certain channels",
             "like kids channel - kids ad.</li>"),
        HTML("<li>Creative name variable together with hours seems interesting, Kids ad late evening is bad idea,",
             "same with women ads.</li>"),
        HTML("<li>Certainly with more time one could find more insights and make some rules.", 
             "All of this could be easily automated.</li></ul>")
        
    ),

    # Show a plot of the generated distribution
    mainPanel(
        h3("Heat map"),
        plotOutput("heatmap"),
        h3("Summary table"),
        dataTableOutput("table")
    )
  )
))
