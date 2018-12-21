
library(shiny)

shinyUI(
  fluidPage(
    #titlePanel("Life Expectancy at Birth"),
    sidebarPanel (
      h4("Please choose your criteria"),
      
      sliderInput("year_of_birth_slider", "Year of birth", 1960, 2016, 1978),
      
      selectInput("sex_select", "Sex", choices = NULL),
      selectInput("country_of_birth_select", "Country of birth", choices = NULL),
      
      submitButton("Submit")
    ),
    mainPanel (
      tabsetPanel(
        type = "tabs",
        tabPanel(
          "Readme First",
          h3("Goal of the App"),
          h6("To allow the user to generate life expectancy at birth figures and plots, given her/his criteria of choice."),
          h3("Capabilities:  What can be done with the App"),
          h6("The App allows the user to:"),
          h6("1) Calculate the life expectancy at birth for a given year of birth, sex and country."),
          h6("2) Plot a trend line for the life expectancy at birth for a given country and sex, with actual data that spans from 1960 to 2016."),
          h6("3) Plot a boxplot that allows to compare the World figures against the life expectancy at birth for the chosen year of birth, sex and country."),
          
          h3("App Structure and Elements"),
          h5("The app is structured in three parts with it's constituting elements:"),
          h5("1) Input panel, where the user can select the criteria for the analysis; it has four elements:"),
          h6("  a) 'Year of birth' slide bar:  To pick the year of birth (available from 1960 to 2016)."),
          h6("  b) 'Sex' dropdown list:  To pick the sex."),
          h6("  c) 'Country of birth' dropdown list:  To pick the country of birth."),
          h6("  d) 'Submit' button:  To generate the figures and plots."),  
          h5("2) 'Readme first' Tab, where help is provided to the user about the following aspects of the app:"),
          h6("  a) Goals"),
          h6("  b) Capabilities"),
          h6("  c) App Structure and Elements"),
          h6("  d) Operation:  How to use the App"),
          h5("3) 'Life Expectancy in Country' Tab, to show the following results by country and sex:"),
          h6("  a) Life Expectancy at Birth in Years:  This is by year of birth, sex and country of birth."),
          h6("  b) Life Expectancy Trend in selected country:  A scatter plot that shows the data from 1960 to 2016 for the selected country and sex."),
          h6("  c) A vertical line in red, that traverses the year of birth chosen."),
          h5("4) 'Life Expectancy in the World' Tab, to show the following results by year of birth and sex:"),
          h6("  a) A boxplot that shows descriptive statistics of life expectancies at birth for all countries in the World, for the chosen sex and year of birth."),
          h6("  b) A horizontal line in red traversing the boxplot, that represents the life expectancy at birth for the chosen sex, year of birth and country."), 
          h5("5) 'Intersting Sites About Life Expectancies' Tab, where hiperlinks to sites related life expectancy at birth are provided."),
             
          h3("Operation:  How to use the App"),
          h5("1) In the input panel, select your criteria for the analysis with the following controls:"),
          h6("a) 'Year of birth' slide bar"),
          h6("b) 'Sex' dropdown list"),
          h6("c) 'Country of birth' dropdown list"),
          h5("2) In the input panel, press the 'Submit' button to calculate the figures and generate the plots."),
          h5("3) Check the results in both panels, 'Life Expectancy in Country' Tab and 'Life Expectancy in the World' Tab."),
          h5("4) If desired, repeat steps 1 to 3 to generate different analyses.")
            
        ),
        tabPanel(
          "Life Expectancy in Country",
            h4("Life Expectancy at Birth in Years:"),
            textOutput("life_expectancy_at_birth"),
            h4("Life Expectancy Trend in selected country:"),
            plotOutput("life_expectancy_trend_plot")
        ),          
        tabPanel(
          "Life Expectancy in the World",
            h4("Life Expectancy at Birth in Relation to World Expectancies:"),
            plotOutput("world_life_expectancy_boxplot")
        ),       
        tabPanel(
          "Intersting Sites About Life Expectancies",
          h3("Gap Minder:"),
          h5("   https://www.gapminder.org/"),
          h3("Life Expectancies in Wikipedia:"),
          h5("   https://en.wikipedia.org/wiki/Life_expectancy")
        )
      )
      
    )
  )
)