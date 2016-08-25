library(shiny)
library(shinydashboard)

dashboardPage(
  dashboardHeader(title="Draw Dataset"),
  dashboardSidebar(disable=T),
  dashboardBody( 
    box(width=12,
        title="Parameters",
        fluidRow(
          column(4, numericInput("num_points", "Number of points per clic", 3)),
          column(4, 
                 numericInput("sigma", 
                              "Standard deviation of each clic point set", 
                              step=0.01, 
                              value=5)
          ),
          column(4, 
                 selectInput("class", "Class (color)", choices=c("red"="firebrick1", 
                                                                 "green"="forestgreen", 
                                                                 "blue"="dodgerblue")))
        ),
        fluidRow(
          column(12,
                 downloadButton("save", "Save"),
                 actionButton("clear", "Clear", icon=icon("remove")),
                 actionButton("undo", "Undo", icon=icon("undo"))
          )
        )
    ),
    box(width=12, 
        height=870,
        title="Draw your own dataset by clicking on this canvas",
        plotOutput("data_plot", click="plot_click")
    )
  )
)



