library(shiny)
library(maps)
library(ggplot2)
library(plyr)
library(mapproj)


shinyServer(function(input, output) {

  data_file <- "files/"
  data_file <- paste0(data_file,"us_state_top_tweet_words.csv")
  
  state_results <- read.csv(data_file,stringsAsFactors=FALSE)

  
  output$data_table = renderDataTable({
    
    state_abbr <- state.abb[match(  
      tolower(input$state)
      ,tolower(state.name))]
    
    if(input$state == "All")
    {
      
    }else
    {
      state_results[state_results==state_abbr,c('top_words','rank')]
    }       
    
    
  })
  
  

  simpleCap <- function(x) {
    s <- strsplit(x, " ")[[1]]
    paste(toupper(substring(s, 1,1)), substring(s, 2),
          sep="", collapse=" ")
  }

  d <- map_data("state") 

  
  
  output$state_dropdown <- renderUI({
    
    states <- unique(d$region)
    state_list <- sapply(states, simpleCap)
    
    selectInput(inputId = "state",
                label = "Select State",
                             c(state_list
                              
                              )
                           
                )
  })
  
  

  
  output$state_map <- renderPlot({
        if(!is.null(input$state))
        {
            if(input$state == "All")
            {
              d$highlight <- "yes"
            }else
            {
              d$highlight <- "no"
              d[d$region == tolower(input$state),]$highlight <- "yes"
            }       
            
            highlight <- c("no","yes")
            colors <- as.character(c("#FFFFFF", "#1E90FF"))
            
            p <- ggplot(d,aes(x=long, y=lat, fill=highlight)) + 
              scale_fill_manual(values = setNames(colors,highlight)) +
              geom_polygon(aes(group = group),color="black") + 
              xlab("") + ylab("") + #theme_bw() +
              theme(axis.ticks = element_blank()
                    , axis.text.x = element_blank()
                    , axis.text.y = element_blank()
                    , legend.position="none"
                    ,panel.grid.major=element_blank()
                    ,panel.grid.minor=element_blank()
              ) +
              coord_map(projection = "mercator")
            
            print(p)
          }
      }
    )
  
  output$state_name <- renderText({
    input$state
    
  })
  
  output$state_name_2 <- renderText({
    input$state
    
  })
  
  output$myImage <- renderImage({
    
    state_abbr <- state.abb[match(  
      tolower(input$state)
      ,tolower(state.name))]
    
    #state_abbr <- "NY"
    
    image_file <- "files/"
    image_file <- paste0(image_file,state_abbr,"_wordcloud.png")
  
    # Return a list containing the filename
    list(src = image_file,
         contentType = 'image/png',
         width = 500,
         height = 500,
         alt = "Word Cloud for selected state")
  }, deleteFile = FALSE)
  
  
  
  
  
})