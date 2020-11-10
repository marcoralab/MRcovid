library(tidyverse)   ## For data wrangling 
library(TwoSampleMR) ## For conducting MR https://mrcieu.github.io/TwoSampleMR/ 
library(ggplot2)     ## For plotting 
library(ggiraph)
library(shinythemes)
library(shiny)
# library(shinyauthr)
# library(shinyjs)
`%nin%` = Negate(`%in%`)

# user_base <- data.frame(
#   user = c("GoateLab"),
#   password = c("microglia"), 
#   permissions = c("admin"),
#   name = c("User One"),
#   stringsAsFactors = FALSE,
#   row.names = NULL
# )


# Read in Data
## Harmonized data 
dat <- read_csv('HarmonizedMRdat.csv', guess_max = 100000)
studies.raw <- read_csv('StudyCharacteristics.csv', guess_max = 100000)
mrpresso_global <- read_tsv('mrpresso_global.txt')


# Define UI for app that draws a histogram ----
ui <- fluidPage(
  ## must turn shinyjs on
  # shinyjs::useShinyjs(),
  ## add logout button UI 
  # div(class = "pull-right", shinyauthr::logoutUI(id = "logout")),
  ## add login panel UI function
  # shinyauthr::loginUI(id = "login"),
  ## setup table output to show user info after login
   uiOutput("testUI")
)

server <- function(input, output) {
  # call the logout module with reactive trigger to hide/show
  # logout_init <- callModule(shinyauthr::logout, 
  #                           id = "logout", 
  #                           active = reactive(credentials()$user_auth))
  
  # call login module supplying data frame, user and password cols
  # and reactive trigger
  # credentials <- callModule(shinyauthr::login, 
  #                           id = "login", 
  #                           data = user_base,
  #                           user_col = user,
  #                           pwd_col = password,
  #                           log_out = reactive(logout_init()))
  
  output$default <- renderText({
   
    })
  ## Exract exposure and outcome names/blurbs
  exposure.name <-  eventReactive(input$go, {dat %>% filter(exposure == input$exposure) %>% distinct(exposure.name) %>% pull()})
  outcome.name <-  eventReactive(input$go, {dat %>% filter(outcome == input$outcome) %>% distinct(outcome.name) %>% pull()})

  ## Extract Study Characgeristics
  studies <- eventReactive(input$go, {
    input_exposure <- input$exposure
    input_outcome <- input$outcome
    input_outcome <- if(input_exposure %nin% c('Liu2019drnkwk', 'SanchezRoige2018auditt', 'Walters2018alcdep', 'Lee2018educ') & 
                        input_outcome %in% 'Lambert2013load'){
      'Kunkle2019load'
    } else if(input_exposure %nin% c('Liu2019drnkwk', 'SanchezRoige2018auditt', 'Walters2018alcdep', 'Lee2018educ') & 
              input_outcome %in% 'Hilbar2015hipv') {
      'Hilbar2017hipv'
    } else {
      input_outcome
    }
    
    out <- studies.raw %>% 
      filter(code %in% c(input_exposure, input_outcome))
    out
  })
 
  ## Extract MR-PRESSO global results
  mr_PressoGloabl <- eventReactive(input$go, {
    input_exposure <- input$exposure
    input_outcome <- input$outcome
    input_pt <- ifelse(input$pt == 1, 5e-8, 5e-6)
    input_outliers <- input$outliers
    out <- mrpresso_global %>%   
      filter(exposure == input_exposure) %>% 
      filter(outcome == input_outcome) %>% 
      filter(pt == input_pt) %>% 
      filter(outliers_removed == ifelse(input_outliers == 1, FALSE, TRUE))
    out
  })
  
  

  ## Extract exposure - outcome data
  mrdat <- eventReactive(input$go, {
    input_exposure <- input$exposure
    input_outcome <- input$outcome
    input_pt <- ifelse(input$pt == 1, 5e-8, 5e-6)
    input_outcome <- if(input_exposure %nin% c('Liu2019drnkwk', 'SanchezRoige2018auditt', 'Walters2018alcdep', 'Lee2018educ') & 
                        input_outcome %in% 'Lambert2013load'){
      'Kunkle2019load'
    } else if(input_exposure %nin% c('Liu2019drnkwk', 'SanchezRoige2018auditt', 'Walters2018alcdep', 'Lee2018educ') & 
              input_outcome %in% 'Hilbar2015hipv') {
      'Hilbar2017hipv'
    } else {
      input_outcome
    }
    
    out <- dat %>% 
      filter(exposure == input_exposure) %>% 
      filter(outcome == input_outcome) %>% 
      filter(pt == input_pt) %>% 
      mutate(beta.exposure.flipped = ifelse(beta.exposure < 0, beta.exposure * -1, beta.exposure)) %>% 
      mutate(beta.outcome.flipped = ifelse(beta.exposure < 0, beta.outcome * -1, beta.outcome)) 
    out$onclick <- sprintf("window.open(\"%s%s\")", "https://www.ncbi.nlm.nih.gov/snp/", as.character(out$SNP))
    out
   })
  
  mrdat_d <- eventReactive(input$go, {
    if(input$outliers == 1){
      d <- mrdat() %>%
        filter(mr_keep == TRUE)
    } else {
      d <- mrdat() %>%
        filter(mr_keep == TRUE) %>%
        filter(mrpresso_keep == TRUE)
    }
    d
  })
  
  ## Calculate mr results - main
  res <- eventReactive(input$go, {
    if(input$outliers == 1){
      res <- mrdat() %>%
        filter(mr_keep == TRUE) %>%
        mr(., method_list = c("mr_ivw_fe", "mr_weighted_median", "mr_weighted_mode", "mr_egger_regression")) 
      temp <- mrdat() %>% 
        unite(id, id.exposure, id.outcome, sep = '.', remove = F) %>% 
        split(.$id) %>% 
        map(~ with(., mr_egger_regression(beta.exposure.flipped, beta.outcome.flipped, se.exposure, se.outcome, 
                                          default_parameters()))) %>% 
        map(~ .$b_i) %>% 
        bind_rows() %>% 
        t() %>% 
        as_tibble(.name_repair = 'unique', rownames = 'id') %>% 
        separate(id, c('id.exposure', 'id.outcome')) %>% 
        mutate(method = "MR Egger") %>% 
        rename(a = '...1')
      
      mrres <- left_join(res, temp) %>% 
        mutate(a = ifelse(is.na(a), 0, a)) %>% 
        mutate(a = round(a,3)) %>%
        mutate(outliers = nrow(mrdat()) - sum(mrdat()$mrpresso_keep, na.rm=TRUE))
      
    } else {
      res <- mrdat() %>%
        filter(mr_keep == TRUE) %>%
        filter(mrpresso_keep == TRUE) %>% 
        mr(., method_list = c("mr_ivw_fe", "mr_weighted_median", "mr_weighted_mode", "mr_egger_regression"))  
      temp <- mrdat() %>% 
        unite(id, id.exposure, id.outcome, sep = '.', remove = F) %>% 
        split(.$id) %>% 
        map(~ with(., mr_egger_regression(beta.exposure.flipped, beta.outcome.flipped, se.exposure, se.outcome, 
                                          default_parameters()))) %>% 
        map(~ .$b_i) %>% 
        bind_rows() %>% 
        t() %>% 
        as_tibble(.name_repair = 'unique', rownames = 'id') %>% 
        separate(id, c('id.exposure', 'id.outcome')) %>% 
        mutate(method = "MR Egger") %>% 
        rename(a = '...1')
      
      mrres <- left_join(res, temp) %>% 
        mutate(a = ifelse(is.na(a), 0, a)) %>% 
        mutate(a = round(a,3)) %>%
        mutate(outliers = nrow(mrdat()) - sum(mrdat()$mrpresso_keep, na.rm=TRUE))
      
    }
  })
  
  ## Calculate mr results - main
  res_single <- eventReactive(input$go, {
    if(input$outliers == 1){
      res <- mrdat() %>%
        filter(mr_keep == TRUE) %>%
        mr_singlesnp(.,
                     single_method = 'mr_wald_ratio',
                     all_method=c("mr_ivw_fe", "mr_weighted_median", "mr_weighted_mode", "mr_egger_regression")) 

          } else {
      res <- mrdat() %>%
        filter(mr_keep == TRUE) %>%
        filter(mrpresso_keep == TRUE) %>%
        mr_singlesnp(.,
                     single_method = 'mr_wald_ratio',
                     all_method=c("mr_ivw_fe", "mr_weighted_median", "mr_weighted_mode", "mr_egger_regression"))      
    }
   })
  

  ##===============================================##  
  ## Instruments
  ##===============================================## 
  
  output$instruments <- DT::renderDataTable(DT::datatable({
    mrdat() %>% 
      select(SNP, exposure.name, effect_allele.exposure, other_allele.exposure, beta.exposure, se.exposure, pval.exposure, eaf.exposure,
             outcome.name, effect_allele.outcome,  other_allele.outcome, beta.outcome, se.outcome, pval.outcome, eaf.outcome, 
             proxy.outcome, target_snp.outcome, proxy_snp.outcome, target_a1.outcome, target_a2.outcome, proxy_a1.outcome, proxy_a2.outcome, 
             remove, palindromic, ambiguous, mr_keep.outcome, mr_keep.exposure, action, mr_keep, mrpresso_RSSobs, mrpresso_pval, mrpresso_keep) %>%
      rename(EA.exposure = effect_allele.exposure, NEA.exposure = other_allele.exposure, EA.outcome = effect_allele.outcome, NEA.outcome = other_allele.outcome) %>%
      mutate(SNP = paste0("<a href='",'https://www.ncbi.nlm.nih.gov/snp/', SNP,"'target='_blank'>",SNP,"</a>"))
  }, options = list(scrollX = TRUE), caption = paste0("Table 1: Harmonized SNPs used in MR anlaysis of ", exposure.name(), ' — ', outcome.name()) ,escape = FALSE))

  output$StudyCharacteristics <- DT::renderDataTable(DT::datatable({
    studies() %>% 
      select(variable, Trait, Study, PMID, `Cohort / Consortium`, N, ncase, ncontrol, Age, `Females (%)`) %>%
      mutate(PMID = paste0("<a href='",'https://www.ncbi.nlm.nih.gov/pubmed/', PMID,"'target='_blank'>",PMID,"</a>"))
  }, options = list(paging = FALSE, searching = FALSE, ordering=F, scrollX = TRUE, bInfo = FALSE), 
  caption = paste0("Table 1: Publication Info"), escape = FALSE, rownames= FALSE)
  )
  
  
  ##===============================================##  
  ## MR analysis
  ##===============================================## 
  
  output$mr_res <- DT::renderDataTable(DT::datatable({
    res() %>% 
      select(method, nsnp, outliers, b, se, pval) %>%
      mutate(b = round(b, 3)) %>% 
      mutate(se = round(se, 3)) %>% 
      mutate(pval = ifelse(pval > 0.0001, round(pval, 4), format(pval, digits = 2, scientific = TRUE))) 
  }, options = list(paging = FALSE, searching = FALSE, ordering=F, scrollX = TRUE, bInfo = FALSE), 
  caption = "Table 1: MR Results", escape = FALSE, rownames= FALSE))
  
  output$mr_scatterText = renderUI({
    HTML(paste0(tags$br(), "Scatter plot"))
  })

  ##===============================================##  
  ## Pleitropy
  ##===============================================##  
  
  output$mr_Q <- DT::renderDataTable(DT::datatable({
    mr_heterogeneity(mrdat_d(), method_list=c("mr_egger_regression", "mr_ivw")) %>% 
      select(-id.exposure, -id.outcome, -exposure, -outcome) %>% 
      mutate(Q = round(Q, 2)) %>% 
      mutate(Q_pval = ifelse(Q_pval > 0.0001, round(Q_pval, 4), format(Q_pval, digits = 2, scientific = TRUE)))
  }, options = list(paging = FALSE, searching = FALSE, ordering=F, bInfo = FALSE), 
  caption = "Table 2: Cochrans Q heterogeneity test", rownames= FALSE))
  
  
  output$mr_Egger <- DT::renderDataTable(DT::datatable({
    mr_pleiotropy_test(mrdat_d()) %>% 
      mutate(egger_intercept = round(egger_intercept, 4)) %>% 
      mutate(se = round(se, 4)) %>% 
      mutate(pval = ifelse(pval > 0.0001, round(pval, 4), format(pval, digits = 2, scientific = TRUE))) %>%
      mutate(method = 'MR Egger') %>% 
      rename(intercept = egger_intercept) %>%
      select(method, intercept, se, pval)
  }, options = list(paging = FALSE, searching = FALSE, ordering=F, bInfo = FALSE), 
  caption = "Table 3: MR Egger test for directional pleitropy", rownames= FALSE))
  
  output$mr_PressoGloabl <- DT::renderDataTable(DT::datatable({
    mr_PressoGloabl() %>%
      mutate(RSSobs = round(RSSobs, 4)) %>% 
      mutate(method = 'MR-PRESSO Global') %>%
      select(method, n_outliers, RSSobs, pval)
  }, options = list(paging = FALSE, searching = FALSE, ordering=F, bInfo = FALSE), 
  caption = "Table 4: MR-PRESSO Global Test", rownames= FALSE))
  
  ##===============================================##  
  ## MR Plots
  ##===============================================## 
  
  output$mr_scatterPlot <- renderggiraph({
    
    mrres <- res() %>%
      as_tibble() #%>%
    mrres[mrres$method == 'Inverse variance weighted (fixed effects)', 'method'] = 'IVW'
    p_colours = c("#377EB8", "#E41A1C", "#984EA3", "#4DAF4A", '#E69F00', 'black')
    names(p_colours) = c('IVW', 'MR Egger', 'Weighted median', 'Weighted mode', 'FALSE', 'TRUE')

  g <- ggplot(data = mrdat_d(), aes(x = beta.exposure.flipped, y = beta.outcome.flipped)) + 
      geom_errorbar(aes(ymin = beta.outcome.flipped - se.outcome, ymax = beta.outcome.flipped + se.outcome), colour = "grey", width = 0) + 
      geom_errorbarh(aes(xmin = beta.exposure.flipped - se.exposure, xmax = beta.exposure.flipped + se.exposure), colour = "grey", height = 0) +
      geom_abline(data = mrres, aes(intercept = a, slope = b, colour = method), show.legend = TRUE, size = 1.25) + 
      geom_point_interactive(data = mrdat_d(), aes(tooltip = SNP, onclick = onclick, colour = mrpresso_keep), size = 3) +
      labs(colour = "MR Test", x = "SNP effect on exposure", y = "SNP effect on outcome") + 
      scale_color_manual(breaks = c('IVW', 'MR Egger', 'Weighted median', 'Weighted mode', 'FALSE', 'TRUE'), 
                         labels = c('IVW', 'MR Egger', 'Weighted median', 'Weighted mode', 'Outlier', 'Variant'),
                         values = p_colours)  + 
      theme_bw() + theme(legend.position = "bottom", legend.title=element_blank(),  text = element_text(family="Times", size=20))
      
    girafe(code = print(g), width_svg = 10.5, height_svg = 8.75)  
    
  })
  
  output$mr_FunnelText = renderUI({
    HTML(paste0(tags$br(), "Funnel plot"))
  })
  
  output$mr_FunnelPlot <- renderggiraph({
    d <- res_single() %>%
      as_tibble() %>% 
      mutate(SNP = as.character(SNP)) %>%
      filter(str_detect(SNP, 'rs[[:digit:]]')) %>%
      left_join(select(mrdat(), SNP, mrpresso_keep))
    d$onclick <- sprintf("window.open(\"%s%s\")", "https://www.ncbi.nlm.nih.gov/snp/", as.character(d$SNP))
    
    am <- res_single() %>%
      as_tibble() %>% 
      mutate(SNP = as.character(SNP)) %>%
      filter(!str_detect(SNP, 'rs[[:digit:]]')) %>%
      mutate(SNP = str_replace(SNP, 'All - ', "")) 
    am[am$SNP == 'Inverse variance weighted (fixed effects)', 'SNP'] = 'IVW'
    
    p_colours = c("#377EB8", "#E41A1C", "#984EA3", "#4DAF4A", '#E69F00', 'black')
    names(p_colours) = c('IVW', 'MR Egger', 'Weighted median', 'Weighted mode', 'FALSE', 'TRUE')
    
    g <- ggplot(d, aes(y = 1/se, x = b)) + 
      geom_vline(data = am, aes(xintercept = b, colour = SNP), size = 1.25) + 
      geom_point_interactive(data = d, aes(tooltip = SNP, onclick = onclick, colour = mrpresso_keep), size = 3) +
      #geom_point(data = d, aes(colour = mrpresso_keep)) + 
      scale_colour_manual(breaks = c('IVW', 'MR Egger', 'Weighted median', 'Weighted mode', 'FALSE', 'TRUE'), 
                          labels = c('IVW', 'MR Egger', 'Weighted median', 'Weighted mode', 'Outlier', 'Variant'),
                          values = p_colours) + 
      labs(y = expression(1/SE[IV]), x = expression(beta[IV])) + 
      theme_bw() + theme(legend.position = "bottom",  legend.title=element_blank(),  text = element_text(family="Times", size=20))
    g
    girafe(code = print(g), width_svg = 10.5, height_svg = 8.75)  
    
  })
  
  output$testUI <- renderUI({
  fluidPage(
    # Uncomment for Login.
    # req(credentials()$user_auth),
    theme = shinytheme("cerulean"),
            
            # App title ----
            titlePanel("Causal Relationships in the Alzheimer's phenome"),
            
            navbarPage("AD MR research Portal",
                       tabPanel("Analysis", 
                                sidebarLayout(
                                  
                                  # Sidebar panel for inputs ----
                                  sidebarPanel(

                                    # Input: Dropdown for exposure ----
                                    selectInput("exposure", label = h3("Select Exposure"), 
                                                choices = list("Alcohol Consumption" = "Liu2019drnkwk", 
                                                               "Alcohol Dependence" = "Walters2018alcdep", 
                                                               "AUDIT" = "SanchezRoige2018auditt", 
                                                               "Smoking Initiation" = "Liu2019smkint", 
                                                               "Cigarettes per Day" = "Liu2019smkcpd", 
                                                               "Diastolic Blood Pressure" = "Evangelou2018dbp", 
                                                               "Depressive Symptoms" = "Howard2018dep", 
                                                               'BMI' = "Yengo2018bmi", 
                                                               "Type 2 Diabetes" = "Xu2018diab", 
                                                               "Educational Attainment" = "Lee2018educ", 
                                                               "Oily Fish Intake" = "NealeLab2018oilfish",
                                                               "High-density lipoproteins" = "Willer2013hdl", 
                                                               "Hearing Problems" = "NealeLab2018hear", 
                                                               "Insomnia Symptoms" = "Jansen2018insom", 
                                                               "Low-density lipoproteins" = "Willer2013ldl", 
                                                               "Major Depressive Disorder" = "Wray2018mdd", 
                                                               "Moderate-to-vigorous PA" = "Klimentidis2018mvpa",
                                                               "Pulse Pressure" = "Evangelou2018pp", 
                                                               "Systolic Blood Pressure" = "Evangelou2018sbp", 
                                                               "Social Isolation" = "Day2018sociso", 
                                                               "Sleep Duration" = "Dashti2019slepdur",
                                                               "Total Cholesterol" = "Willer2013tc", 
                                                               "Triglycerides" = "Willer2013tg"), 
                                                selected = 'Liu2019drnkwk'),
                                    
                                    # Input: Dropdown for outcome ----
                                    selectInput("outcome", label = h3("Select Outcome"), 
                                                choices = list("LOAD" = "Lambert2013load", 
                                                               "AAOS" = "Huang2017aaos", 
                                                               "CSF Ab42" = "Deming2017ab42", 
                                                               "CSF Tau" = "Deming2017tau", 
                                                               "CSF Ptau" = "Deming2017ptau", 
                                                               "Hippocampul Volume" = "Hilbar2015hipv",
                                                               "Neuritic Plaques" = "Beecham2014npany",
                                                               "Neurofibrillary Tangles" = "Beecham2014braak4",
                                                               "Vascular Brain Injury" = "Beecham2014vbiany"), 
                                                selected = 'load'), 
                                    
                                    radioButtons("pt", label = h3("Pvalue Threshold"),
                                                 choices = list("5e-8" = 1, "5e-6" = 2), 
                                                 selected = 1),
                                    
                                    radioButtons("outliers", label = h3("Remove Outliers"),
                                                 choices = list("False" = 1, "True" = 2), 
                                                 selected = 1), 
                                    br(),
                                    
                                    actionButton("go", "Analyze")
                                    
                                  ),
                                  
                                  
                                  # Main panel for displaying outputs ----
                                  mainPanel(
                                    
                                    # Output: Tabset w/ plot, summary, and table ----
                                    tabsetPanel(type = "tabs",
                                                tabPanel("Instruments", br(),
                                                         DT::dataTableOutput("StudyCharacteristics"), br(),
                                                         DT::dataTableOutput("instruments")),
                                                tabPanel("MR Results", 
                                                         fluidRow(
                                                           column(6, 
                                                                  htmlOutput("mr_scatterText"),
                                                                  ggiraphOutput(outputId = "mr_scatterPlot")
                                                           ), 
                                                           column(6, 
                                                                  htmlOutput("mr_FunnelText"),
                                                                  ggiraphOutput(outputId = "mr_FunnelPlot")
                                                           )
                                                         ), br(),
                                                         DT::dataTableOutput("mr_res"), br(),
                                                         DT::dataTableOutput("mr_Q"), br(),
                                                         DT::dataTableOutput("mr_Egger"), br(),
                                                         DT::dataTableOutput("mr_PressoGloabl"), br()
                                                )
                                    )
                                  )
                                )
                       ), 
                       tabPanel("About", 
                                h1('Interactive Alzheimer\'s Disease MR Research Portal'),
                                p("Version 0.1"),
                                h2('Background'), 
                                p("This interactive research portal is a companion to the research paper \"Causal Relationships Undelrying 
                                the Alzheiemr\'s Phenome\" that explores the causal relationships between modifiabl risk selected from the 
                                observationa litrature factors and the Alzheimer's phenome"), 
                                p("For each exposure - outcome pair, Genetic variants were included as instruments based on the following criteria:
                                Genome-wide assocatied SNPs with a minum p-value of 5x10-8 or 5x10-6; SNPs or their proxies (minimum R2value = 0.8 
                                in the 1000 European super-population); R2 clumping threshold = 0.001 and 1000kb window. Ouliers were
                                identified using MR-PRESSO"),
                                p("Causal associations were estimated using the following methods.", 
                                  a('IVW', href = 'https://doi.org/10.1002/gepi.21758'), 
                                  "is equivalent to a weighted regression of the SNP-outcome coefficients on the SNP-exposure coefficients with the intercept
                        constrained to zero. This method assumes that all variants are valid instrumental variables based on the Mendelian 
                        randomization assumptions. The causal estimate of the IVW analysis expresses the causal increase in the outcome 
                        (or log odds of the outcome for a binary outcome) per unit change in the exposure.", 
                                  a("Weighted median MR", href = 'https://doi.org/10.1002/gepi.21965'),
                                  "allows for 50% of the instrumental variables to be invalid.", 
                                  a("MR-Egger regression", href = "https://doi.org/10.1093/ije/dyw220"),
                                  "allows all the instrumental variables to be subject to direct effects (i.e. horizontal pleiotropy), with the intercept
                        representing bias in the causal estimate due to pleiotropy and the slope representing the causal estimate.", 
                                  a("Weighted Mode", href = "https://doi.org/10.1093/ije/dyx102"),
                                  "gives consistent estimates as the sample size increases if a plurality (or weighted plurality) of the genetic variants are
                        valid instruments."),
                                br(), 
                                h4('Further Reading'),
                                p('The Lancet Commisions report on ', 
                                  a("Dementia prevention, intervention, and care",
                                    href ='https://www.sciencedirect.com/science/article/pii/S0140673617313636?via%3Dihub')), 
                                p('A guide to reading Mendelian randomization studies. ', 
                                  a('Davies et al BMJ 2018', href = "https://doi.org/10.1136/bmj.k601")), 
                                p('Performing Mendelian randomization studies. ', 
                                  a('Hemani et al eLife 2018', href = "https://doi.org/10.7554/eLife.34408")), 
                                br(),
                                h4("Contact information"), 
                                fluidRow(
                                  column(6, 
                                         p(div("Dr. Shea Andrews"),
                                           div("Postdoctoral Fellow"),
                                           div("Ronald M. Loeb Center for Alzheimer’s Disease"), 
                                           div("Icahn School of Medicine at Mount Sinai"),
                                           div("1425 Madison Ave"),
                                           div("New York, NY 10029"), 
                                           div("Tel: +1-212-659-8632"),
                                           div("Email: shea.andrews@mssm.edu"))
                                  ),
                                  column(6, 
                                         p(div("Dr. Alison Goate"),
                                           div("Willard T.C. Johnson Research Professor of Neurogenetics"),
                                           div("Director, Ronald M. Loeb Center for Alzheimer’s Disease"), 
                                           div("Icahn School of Medicine at Mount Sinai"),
                                           div("1425 Madison Ave"),
                                           div("New York, NY 10029"), 
                                           div("Tel: +1-212-659-5672"),
                                           div("Email: alison.goate@mssm.edu"))
                                  )
                                )
                       ) 
                       
                       
            )
            
  )
  })
}

shinyApp(ui, server)