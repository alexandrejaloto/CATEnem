#' prova UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_prova_ui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns("ui"))
  )
}

#' prova Server Functions
#'
#' @noRd
mod_prova_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # itens disponíveis
    rownames(df_prova) <- df_prova$cod_item
    itens_disponiveis <- df_prova[!grepl('instrucao$', df_prova$cod_item),]

    output$ui <- renderUI({
      tagList(
        h5('Ciências Humanas'),
        shinyjs::useShinyjs(),
        uiOutput(ns('botao_alternativas')),
        shinyjs::disabled(
          actionButton(
            ns('responder'),
            'Responder',
            onclick = 'document.getElementById(this.id).disabled = true'
          )
        )
      )
    })

    output$botao_alternativas <- renderUI({
      r$carrossel_itens[[df_prova$widget[it_select() + 1]]](
        df_prova,
        it_select() + 1, # adicionamos 1 por conta da instrução
        ns
      )
    })

    observe({
      # Lógica para habilitar o botão de responder
      if(!is.null(input$alternativas)) {
        if(input$alternativas != ''){
          shinyjs::enable('responder')
        }
      }
    })

    # selecionar o item
    it_select <- reactive({

      if(is.null(r$prova$aplicados)) return(0)

      next_item(
        mod = r$prova,
        df = df_prova,
        itens_disponiveis = itens_disponiveis
      )

    })

    # quando clicar em responder
    observeEvent(input$responder, {

      # se for o primeiro item
      if(is.null(r$prova$aplicados)){
        r$prova <- cria_r_cat(
          mod = r$prova,
          df = df_prova
        )
      } else {

        print(it_select())

        r$prova <- atualiza_r_cat(
          mod = r$prova,
          it_select = it_select(),
          input = input$alternativas,
          df = df_prova,
          modelo_cat = modelo_prova
        )

        r$prova$fim <- fim_cat(
          # criterios
          rule = list(
            fixed = 20,
            tempo_limite = .2
          ),
          current = list(
            applied = length(r$prova$aplicados),
            hist_resp_time = r$prova$hist_resp_time
          )
        )

        if(r$prova$fim$stop){

          r <- r_fim(
            r = r,
            area = 'prova',
            modelo_cat = modelo_prova
          )

          r$grafico <- cria_grafico(
            info = r
          )

          output$ui <- renderUI({
            mod_devolutiva_ui("devolutiva_1")
          })

        }
      }
    })

  })
}
