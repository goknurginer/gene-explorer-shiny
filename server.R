tableRendered <<- FALSE
shinyServer(function(input, output, session){
  
  updateSelectizeInput(session, "genes", 
    choices = genes_all, server = TRUE)
  
  run_box <- reactive({
    if (input$selection == 'Within all genes') {
      input$genes
    }
    
    else if (input$selection == 'Within Smac Mimetic genes') {
      if (!input$all_genes & !is.null(input$smac)) input$smac
      else if (input$all_genes) smac_genes
    }
  })
  
  pval <- eventReactive(input$btnViewTableAndPlots, {
    pval.all[pval.all$Gene %in% run_box(),]
  }) 
  
  output$pvalTable <- DT::renderDataTable({
    input$btnViewTableAndPlots
    pval()
  }, options = list(orderClasses = TRUE), filter = 'top'
  )
  
  plot.height <- reactive({
    data <- getGeneData()
    ceiling(nrow(data)/2)*500
  })
  
  getGeneData = function(){
    data <- d[d$genes$Symbol %in% run_box(),]
    
    if (input$btnViewTableAndPlots) { 
      filtered_data <- input$pvalTable_rows_all
      data[rownames(data$genes) %in% filtered_data,]
    } else {
      data
    }
  }
  
  output$plot.ui <- renderUI({
    plotOutput("boxplot", height =  plot.height())
  })
  
  renderBox = function(){
    if (input$btnViewTableAndPlots) { 
      data <- getGeneData()
      par(mfrow = c(ceiling(nrow(data)/2),2))
      for(i in 1:nrow(data)) {
        b <- data[i,]
        counts <- data.frame(counts = as.vector(log10(b$counts)),
          group = as.character(b$samples$group))
        boxplot(counts~group, data = counts, main = b$genes$Symbol,
          ylab = "log10 expression values", range = 0, cex = 2, col = col)
      }
    }
  }
  output$boxplot <- renderPlot(
    renderBox()
  )
  
  output$pval_dl <- downloadHandler(
    filename = function() {
      paste(input$filename_pval,"-", Sys.Date(), '.csv', sep='')
    },
    content = function(file) 
    {
      if(input$pval_radio == "All") write.csv(pval(), file)
      else if (input$pval_radio == "Filtered") {
        s = input$pvalTable_rows_current
        write.csv(pval()[s, , drop = FALSE], file)
      }
      else {
        r = input$pvalTable_rows_selected
        write.csv(pval()[r, , drop = FALSE], file)
      }
    })
  
  output$box_dl <- downloadHandler(
    filename = function() {
      paste(input$filename_box, "-", Sys.Date(), ".", input$dev, sep='')
    },
    content = function(file) {
      if (input$dev == "pdf") pdf(file, height = plot.height()/150)
      else svg(file, height = plot.height()/150)
      data <- getGeneData()
      par(mfrow = c(ceiling(nrow(data)/2),2))
      for(i in 1:nrow(data)) {
        b <- data[i,]
        counts <- data.frame(counts = as.vector(log10(b$counts)),
          group = as.character(b$samples$group))
        boxplot(counts~group, data = counts, main = b$genes$Symbol,
          ylab = "log10 expression values", range = 0, cex = 2, col = col)
      }
      dev.off()
    }
  )
  
})

