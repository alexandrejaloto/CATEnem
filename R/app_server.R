#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # Your application server logic

  # objeto r ----
  r  <- reactiveValues()
  r$carrossel_itens <- list(
    text = function(df, it, ns){
      textInput(
        ns('alternativas'),
        label = df$descricao[it],
        value = ''
      )
    },
    numeric = function(df, it, ns){
      numericInput(
        ns('alternativas'),
        label = df$descricao[it],
        value = ''
      )
    },
    radio = function(df, it, ns){

      cat <- unname(unlist(df[it, grepl('^cat', names(df))]))

      cat <- cat[!is.na(cat)]

      radioButtons(
        ns('alternativas'),
        label = df$descricao[it],
        choices = cat,
        selected = character(0)
      )
    },
    radio_image = function(df, it, ns){

      cat <- unname(unlist(df[it, grepl('^cat', names(df))]))

      cat <- cat[!is.na(cat)]

      radioButtons(
        ns('alternativas'),
        label = img(src = df$descricao[it]),
        choices = cat,
        selected = character(0)
      )
    },
    select = function(df, it, ns){

      cat <- unname(unlist(df[it, grepl('^cat', names(df))]))

      cat <- cat[!is.na(cat)]

      selectInput(
        ns('alternativas'),
        label = df$descricao[it],
        choices = cat,
        selected = character(0)
      )

    },
    instrucao = function(df, it, ns){
      tagList(
        HTML(df$descricao[it]),
        radioButtons(
          ns('alternativas'),
          label = '',
          choices = c('Compreendi e quero continuar'),
          selected = character(0)
        )
      )
    }
  )

  # ui ----
  output$ui <- renderUI(mod_apresentacao_ui("apresentacao_ui_1"))

  # servidores ----

  mod_apresentacao_server("apresentacao_ui_1")
  mod_CH_server("CH_ui_1", r)
  mod_CN_server("CN_1", r)
  mod_MT_server("MT_1", r)
  mod_LC_ingles_server("LC_ingles_1", r)
  mod_LC_espanhol_server("LC_espanhol_1", r)
  mod_devolutiva_server("devolutiva_1", r)
}
