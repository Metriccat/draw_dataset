# A program to draw a 2D dataset by clicking on a [0,1]x[0,1] canvas. 
# 3 classes are available, labeled by color.
# Users can export their dataset as a csv file.

library(ggplot2)

server <- function(input, output, session) {
  
  addGroup <- function(data, n, center, sigma, class){
    # append a group of points distributed around the clic coordinates
    # to a data frame holding all the points created and their color.
    new_group <- data.frame("x"=rnorm(n, mean=center$x, sd=sigma), 
                            "y"=rnorm(n, mean=center$y, sd=sigma),
                            "class"=class)
    return(rbind(data, new_group))
  }
  
  # initialize reactive dataset holding the points created by the user
  v <- reactiveValues(data = data.frame())
  
  observe({
    # populates the dataset with points distributed around the clic target point
    if(!is.null(input$plot_click)) {
      # "isolate" reads fresh value of v$data without the update re-evaluating it
      # avoids infinite loop of update with rbind then re-rbind the updated data with the new group 
      v$data <- isolate(addGroup(v$data, input$num_points, input$plot_click, input$sigma, input$class))
    }
  })
  
  observe({
    # remove all points from the canvas and the dataset when clear button is clicked
    if(!is.null(input$clear)) {
      v$data <- data.frame()
    }
  })
  
  observeEvent(input$undo, {
    # remove the latest drawn point from the dataset when undo button is clicked
    v$data <- v$data[-nrow(v$data), ]
  })
  
  output$save <- downloadHandler(
    # save the dataset as a csv file
    # scale to zero mean and unit variance before saving
    filename = function() {'DIYdataset.csv'},
    content = function(file) {
      write.csv(data.frame(scale(v$data[,c("x","y")]), "color"=v$data$class), 
                file, 
                quote=F, 
                row.names=F)}
  )
  
  output$data_plot <- renderPlot({
    # display the base plot
    plot <- ggplot() + xlim(0, 100) + ylim(0, 100) + xlab("x") + ylab("y")
    # if data is not empty, add it to plot
    # points outside of plot boundaries are added to the dataset but not displayed
    if (nrow(v$data) > 0) {
      plot <- plot + geom_point(aes(x=v$data$x, y=v$data$y), 
                                size=4, 
                                colour=v$data$class, 
                                show.legend=F)
    }
    return(plot)
  }, height=800)
  
}
