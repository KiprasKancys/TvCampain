library(shiny)
library(dplyr)
library(ggplot2)

# dat <- read.csv('data.csv') %>%
#     mutate(Cost.per.new.lister = gsub("€", "", Cost.per.new.lister)) %>% 
#     mutate(Cost.per.new.lister = as.numeric(Cost.per.new.lister)) %>% 
#     mutate(Hour = gsub("*H[0-9][0-9]", "", as.character(Airing.time))) %>% 
#     mutate(Hour = as.numeric(Hour)) %>% 
#     filter(Cost.per.new.lister > 0)

dat <- readRDS('data.rds')

shinyServer(function(input, output) {
    
    values <- reactiveValues()
    
    output$channelControl <- renderUI({
        selectizeInput('channel', 'Select channels', choices = unique(dat$Channel), selected = unique(dat$Channel),
                       multiple = TRUE)
    })
    
    output$hourControl <- renderUI({
        sliderInput('hour', 'Select hours', min = 6, max = 24, value = c(6, 24), step = 1, ticks = FALSE)
    })
    
    # Filter data
    observe({
        
        values$filteredData <- dat %>% 
            filter(Channel %in% input$channel) %>%
            filter(Hour >= input$hour[1] & Hour <= input$hour[2])
        
    })
    
    output$xaxis <- renderUI({
        selectizeInput('x', 'Select variable for x-axis', selected = c("Channel"),
                       choices = c("Channel", "Day.Of.The.Week", "Hour", "Creative.length", "Week", "Creative.name"))
    })
    
    output$yaxis <- renderUI({
        req(input$x)
        selectizeInput('y', 'Select variable for y-axis', selected = c("Hour"), choices = setdiff(
            c("Channel", "Day.Of.The.Week", "Hour", "Creative.length", "Week", "Creative.name"), input$x))
    })
    
    output$heatmap <- renderPlot({
        req(values$filteredData)
        req(input$x)
        req(input$y)

        temp <- values$filteredData %>% 
            group_by_(input$x, input$y) %>% 
            summarise(Cost.per.new.lister = mean(Cost.per.new.lister))
        
        if (input$logTransform) {
            temp <- mutate(temp, Cost.per.new.lister = log(Cost.per.new.lister))
        }

        ggplot(data = temp, aes_string(x = input$x, y = input$y)) +
            geom_tile(aes(fill = Cost.per.new.lister))
        
    })
    
    observe({
        req(values$filteredData)
        req(input$groups)

        values$summaryTable <- values$filteredData %>% 
            group_by_(.dots = eval(input$groups)) %>% 
            summarise(MeanCPL = sort(round(mean(Cost.per.new.lister), 2)), NumberOfRecords = n())
    })
    
    output$table <- renderDataTable(values$summaryTable)

})
