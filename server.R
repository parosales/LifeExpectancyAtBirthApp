library(shiny)

shinyServer(
  function(input, output, session) {
    
    # ----------------------------------- Load Libraries ----------------------------------- #
    library(sqldf)
    library(dplyr)
    library(reshape2)
    library(ggplot2)
    
    # ----------------------------------- Load Data Sets ----------------------------------- #
    raw_life_expectancy_at_birth_male_df <- read.csv("/Users/prosales/Documents/Personales/09 - Developing Data Products/final_project/data/Life_expectancy_at_birth_MALE.csv")
    raw_life_expectancy_at_birth_female_df <- read.csv("/Users/prosales/Documents/Personales/09 - Developing Data Products/final_project/data/Life_expectancy_at_birth_FEMALE.csv")
    
    
    # ----------------------------------- Males Set Preparation ----------------------------------- #
    # rename colums
    raw_life_expectancy_at_birth_male_col_names <- colnames(raw_life_expectancy_at_birth_male_df) 
    std_life_expectancy_at_birth_male_col_names <- gsub("X", "", raw_life_expectancy_at_birth_male_col_names)
    colnames(raw_life_expectancy_at_birth_male_df) <- std_life_expectancy_at_birth_male_col_names
    
    # standardise countries names
    std_life_expectancy_at_birth_male_df <- raw_life_expectancy_at_birth_male_df %>% mutate (country = toupper(country))
    
    # convert column year to row
    std_2_life_expectancy_at_birth_male_df <- melt(std_life_expectancy_at_birth_male_df, id = (c(("country"))) )
    colnames(std_2_life_expectancy_at_birth_male_df) <- c("country", "year", "life_expectancy_at_birth")
    
    std_2_life_expectancy_at_birth_male_df$year <- as.integer(as.character(std_2_life_expectancy_at_birth_male_df$year))
    
    std_2_life_expectancy_at_birth_male_df$sex = "MALE"
    
    # ----------------------------------- Females Set Preparation ----------------------------------- #
    # rename colums
    raw_life_expectancy_at_birth_female_col_names <- colnames(raw_life_expectancy_at_birth_female_df) 
    std_life_expectancy_at_birth_female_col_names <- gsub("X", "", raw_life_expectancy_at_birth_female_col_names)
    colnames(raw_life_expectancy_at_birth_female_df) <- std_life_expectancy_at_birth_female_col_names
    
    # standardise countries names
    std_life_expectancy_at_birth_female_df <- raw_life_expectancy_at_birth_female_df %>% mutate (country = toupper(country))
    
    # convert column year to row
    std_2_life_expectancy_at_birth_female_df <- melt(std_life_expectancy_at_birth_female_df, id = (c(("country"))) )
    colnames(std_2_life_expectancy_at_birth_female_df) <- c("country", "year", "life_expectancy_at_birth")
    
    std_2_life_expectancy_at_birth_female_df$year <- as.integer(as.character(std_2_life_expectancy_at_birth_female_df$year))
    std_2_life_expectancy_at_birth_female_df$sex = "FEMALE"
    
    # ----------------------------------- All  Set Preparation ----------------------------------- #
    all_life_expectancy_at_birth_df <- rbind(std_2_life_expectancy_at_birth_female_df, std_2_life_expectancy_at_birth_male_df)
    
    
    # ----------------------------------- Countries Set Preparation ----------------------------------- #
    countries_df <- sqldf("SELECT DISTINCT country FROM all_life_expectancy_at_birth_df")
    
    # ----------------------------------- Sex Set Preparation ----------------------------------- #
    sex_df <- sqldf("SELECT DISTINCT sex FROM all_life_expectancy_at_birth_df")
    
    # ----------------------------------- Load UI widgets ----------------------------------- #
    updateSelectizeInput(
      session,
      'sex_select',
      choices = sex_df$sex,
      server = TRUE
    )

    updateSelectizeInput(
      session,
      'country_of_birth_select',
      choices = countries_df$country,
      server = TRUE
    )
    
    # ----------------------------------- Filtering  User's Choice ----------------------------------- #
    resulting_row_by_choice <- reactive (
      {
        all_life_expectancy_at_birth_df[
          (
            (all_life_expectancy_at_birth_df$country == input$country_of_birth_select) &
            (all_life_expectancy_at_birth_df$year    == input$year_of_birth_slider) & 
            (all_life_expectancy_at_birth_df$sex     == input$sex_select )
          ), 
          ]
      }
    )
    # ----------------------------------- Display Results ----------------------------------- #
    # Life expectancy at birth
    output$life_expectancy_at_birth <- renderText (
      { 
        user_leb <- resulting_row_by_choice()$life_expectancy_at_birth
      }
    )
    
    # Life expectancy trend in country
    # ----------------------------------- Life Expectancy at Birth in Years for Country ----------------------------------- #
    output$life_expectancy_trend_plot <- renderPlot (
      {
        life_expectancies_by_country_df <- all_life_expectancy_at_birth_df [
          (
            (all_life_expectancy_at_birth_df$country == input$country_of_birth_select) &
            (all_life_expectancy_at_birth_df$sex     == input$sex_select)
          ),
        ]

        life_expectancies_by_country_qplot <- qplot(
          x = year,
          y = life_expectancy_at_birth,
          data = life_expectancies_by_country_df,
          main = paste("Period Life Expectancy at Birth by Year in", input$country_of_birth_select, "for", input$sex_select),
          xlab = "Year",
          ylab = "Life Expectancy at Birth in Years"
        )

        life_expectancies_by_country_qplot <- life_expectancies_by_country_qplot + theme(axis.text.x = element_text(angle = 90, hjust = 1))

        life_expectancies_by_country_qplot <- life_expectancies_by_country_qplot + geom_vline(xintercept =  input$year_of_birth_slider, linetype="dashed", color = "red")

        life_expectancies_by_country_qplot
      }
    )
    
    
    
     output$world_life_expectancy_boxplot <- renderPlot (
      {
        # summary data
        world_data_for_year_df <- na.omit(
          all_life_expectancy_at_birth_df[
            (
              (all_life_expectancy_at_birth_df$year == input$year_of_birth_slider) &
              (all_life_expectancy_at_birth_df$sex  == input$sex_select)
            ),
          ]
        )

        #
        user_leb <- resulting_row_by_choice()$life_expectancy_at_birth

        world_leb_boxplot <- boxplot(
          life_expectancy_at_birth ~ year,
          data = world_data_for_year_df,
          main = paste0("Comparison to World LEB for People born during ", input$year_of_birth_slider),
          xlab = paste0("Year of birth: ", input$year_of_birth_slider),
          ylab = "Life Expectancies at Birth in the World",
          notch = TRUE,
          col = (c("gold"))
        )

        abline(h = user_leb, col = "red", lwd = 2)

        world_leb_boxplot
      }
    )
    
  }
)
