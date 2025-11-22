#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

# Libraries for app
library(shiny)
library(bslib)
library(reactable)

# Libraries for data
library(datateachr)
library(tidyverse)
library(stringr)
library(forcats)

# Add dark and light theme
light <- bs_theme(bootswatch = "pulse")
dark <- bs_theme(bootswatch = "pulse", dark = TRUE)

# Define UI for application that graphs the use of genres in games over time.
ui <- fluidPage(

  # Dark mod toggle
  theme = light,
  nav_item(input_dark_mode()),
  
  # Application title
  titlePanel("Game Genres Over Time"),

  # Sidebar with a slider input for year range
  page_sidebar(
    sidebar = sidebar(
      # Slider to select year range
      sliderInput("years", "Range of Years:", min = 1980, max = 2025,
                  value = c(1990, 2020)),
      
      # Slider to select how many top genres to show
      sliderInput("genres", "Top Genres Shown:", min = 1, max = 26, value = 5),
      
      # Switch to see data table
      input_switch("switch", "See Table"),
    ),
    
    # Show a plot of the generated distribution
    plotOutput("plot"),
      
    # Interactable data table
    reactableOutput("table", width = "100%")
  )
)

# Define server logic required to determine what genres were used in what year.
server <- function(input, output) {
  
  # Data used in app of genres used by year.
  q4_data <- reactive({
    data <- steam_games %>%
      select(name, release_date, genre) %>%
      
      # Remove rows with improperly formatted dates, convert to year.
      filter(!is.na(release_date)) %>%
      filter(grepl(", ", release_date)) %>%
      filter(!grepl("!", release_date)) %>%
      
      # Convert release date strings to date values.
      mutate(release_year = suppressWarnings(as.numeric(word(release_date, 2, 
                                                             sep = ", ")))) %>%
      select(-release_date) %>%
      drop_na() %>%
      filter(release_year %in% (input$years[1]: input$years[2])) %>%
      
      # Separate genre column into individual items.
      separate_wider_delim(genre, delim = ",", names_sep = "_", 
                           too_few = "align_start") %>%
      
      # Make multiple rows for each game with one genre column
      pivot_longer(cols = starts_with("genre"), names_to = "temp", 
                   values_to = "genre", values_drop_na = TRUE) %>%
      select(-temp) %>%
      
      # Sort by genre
      group_by(release_year, genre) %>%
      rename("Genre" = genre) %>%
      summarise(n = n())
    
    genre_data <- data %>%
      group_by(Genre) %>%
      summarize(n = sum(n)) %>%
      arrange(desc(n)) %>%
      slice(1:input$genres)
    
    data <- data %>%
      filter(Genre %in% genre_data$Genre) %>%
      rename("Occurrence" = n, "Release Year" = release_year)
  })
  
  # Code for line plot
  output$plot <- renderPlot({
    
    # Draw line plot of what genres are used over years
    q4_graph <- ggplot(q4_data(), 
                       aes(x = `Release Year`, y = Occurrence, color = Genre)) +
      geom_line() +
      scale_y_continuous(trans = "log10") +
      
      # Labels
      ggtitle("Genres of Games Over Time") +
      xlab("Release Year") +
      ylab("# of Games")
    
    q4_graph
  })
  
  # Output an interactable data table
  output$table <- renderReactable({
    
    if(input$switch){
      reactable(q4_data(), searchable = TRUE, striped = TRUE, highlight = TRUE,
              theme = reactableTheme(color = "#26004d",
                                     borderColor = "#26004d",
                                     stripedColor = "#f6f8fa",
                                     highlightColor = "#ccccff"))
    }
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
