# Jessica Sun's Assignment B3

This repository contains the Assignment B3 files for Jessica Sun (#69248748).

## This repository contains the following files:

1.  README.md: An introduction to the repository and list of files.

2.  ChatGPT Prompts.docx: A Word doc of the record of prompts sent to ChatGPT to help write code for this project, as well as ChatGPT's replies. It also has a reflection of my use of ChatGPT for this project.

3.  SteamGameGenreTrends: A folder of the code and other documentation for the Shiny app. It contains the following files:

    -   app.R: R code for the Shiny app.
    -   rsconnect: A folder created when deploying the app to Shinyapps.io. Through the path rsconnect/shinyapps.io/jessisunshine, it contains the file steamgamegenretrends.dcf, which documents information about the app.

This app plots the most commonly tagged genres for games each year on the `steam_games` dataset. It has two sliders for year range and top genres displayed. The user can choose to see genre use in the range of years of their choice. They can also choose to see however many genres that was the most popular in that time. There is a toggle for dark mode as well.

The app displays a lineplot of the top genres used in games over a time range. There is also a switch to display that information in a table. This table is searchable.

The app can be accessed at the following URL: <https://jessisunshine.shinyapps.io/steamgamegenretrends/>
