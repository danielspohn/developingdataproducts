library(shiny)

shinyUI(
    navbarPage("Tweets by State",
      tabPanel("Tweets",
          # Application title
          #titlePanel("Hello Shiny!"),
        
            sidebarPanel(
              uiOutput("state_dropdown")
              ,plotOutput("state_map",width = 250)
            ),
        
            mainPanel(
                tabsetPanel(
                    tabPanel("Word Cloud"
                             ,h3(textOutput("state_name"))
                             ,imageOutput("myImage")
                    ),
                    tabPanel("Data Table"
                             ,h3(textOutput("state_name_2"))
                             ,dataTableOutput('data_table')
                    )
                    
                )
                
            )
          
      )
      ,tabPanel("About",
          mainPanel(
            
            titlePanel("About")
            ,p("This application shows the top words that were Tweeted from U.S. states 
               between the dates of 2015-02-04 and 2015-02-20.")
            ,p("The data was downloaded and parsed from Twitter using the TwitteR and StreamR R packages.")
            ,p("The data was processed using the tm package in R.")            
            ,p("Word clouds were created using the wordcloud package in R.") 
            ,p("Attempts were made to remove curse and crude words from the application, 
               if any offensive words still remove, I apologize.")             
            ,titlePanel("How to Use")
            ,p("To view the top tweeted words from any particular U.S. state, 
               select the state from the drop down menu.")            

          )
      )
  )
)