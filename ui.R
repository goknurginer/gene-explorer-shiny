shinyUI(fluidPage(
  
  titlePanel("Smac Mimetic Gene Explorer"),
  
  hr(),
  
  fluidRow(
    
    column(3, wellPanel(
      
      radioButtons('selection', "1. Select Genes", 
        choices = c("Within all genes", "Within Smac Mimetic genes")),
      
      conditionalPanel(
        condition = "input.selection == 'Within all genes'", 
        selectizeInput("genes", label = '2. Enter Gene Symbols', choices = NULL, 
          multiple = TRUE)),
      
      conditionalPanel(
        condition = "input.selection == 'Within Smac Mimetic genes'", 
        selectInput('smac', '2. Enter Gene Symbols', choices = smac_genes, 
          multiple = TRUE),
        checkboxInput("all_genes", "Select all")),
      h5(strong("3. View P-value table and plots")),
      actionButton('btnViewTableAndPlots', 'View Table and Plots')
    )),

    column(3, wellPanel(
        radioButtons('pval_radio', "4. Save P-value tables", 
          choices = c("All", "Filtered", "Selected")),
      textInput('filename_pval', label = "Name the file"),
      p(downloadButton('pval_dl', 'Download'))
    )),
    
    column(3, wellPanel(
        radioButtons('dev', "5. Save box plots", 
          choices = c("svg", "pdf")),
        textInput('filename_box', label = "Name the file"),
        p(downloadButton('box_dl', 'Download'))
    ))
  ),
  
  hr(),
  
  fluidRow(
    
    column(4,
      DT::dataTableOutput('pvalTable')
    ),
    
    column(7, offset = 1,
      uiOutput('plot.ui')
    )
  )
)
)
