#' MT UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_MT_ui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns("ui"))
  )
}

#' MT Server Functions
#'
#' @noRd
mod_MT_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # itens disponíveis
    rownames(df_MT) <- df_MT$cod_item
    itens_disponiveis <- df_MT[!grepl('instrucao$', df_MT$cod_item),]

    output$ui <- renderUI({
      tagList(
        h5('Matemática'),
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
      r$carrossel_itens[[df_MT$widget[it_select() + 1]]](
        df_MT,
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

      if(is.null(r$MT$aplicados)) return(0)

      next_item(
        mod = r$MT,
        df = df_MT,
        itens_disponiveis = itens_disponiveis
      )

    })

    # quando clicar em responder
    observeEvent(input$responder, {

      # se for o primeiro item
      if(is.null(r$MT$aplicados)){
        r$MT <- cria_r_cat(
          mod = r$MT,
          df = df_MT
        )
      } else {

        print(it_select())

        r$MT <- atualiza_r_cat(
          mod = r$MT,
          it_select = it_select(),
          input = input$alternativas,
          df = df_MT,
          modelo_cat = modelo_MT
        )

        r$MT$fim <- fim_cat(
          # criterios
          rule = list(
            fixed = 20,
            tempo_limite = .2
          ),
          current = list(
            applied = length(r$MT$aplicados),
            hist_resp_time = r$MT$hist_resp_time
          )
        )

        if(r$MT$fim$stop){

          r <- r_fim(
            r = r,
            area = 'MT',
            modelo_cat = modelo_MT
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

## To be copied in the UI
#

## To be copied in the server
#
