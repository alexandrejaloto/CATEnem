#' aut_cat
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
aut_cat <- function(
  df = df_CH,
  r_object = r$CH,
  modelo = modelo_CH,
  area = 'CH',
  input = input,
  ui = output$ui,
  ns = ns
){

  # itens disponíveis
  rownames(df) <- df$cod_item
  itens_disponiveis <- df[!grepl('instrucao$', df$cod_item),]

  # browser()

  ui <- renderUI({
    tagList(
      h5('Ciências Humanas'),

      shinyjs::useShinyjs(),
      # uiOutput(ns('botao_alternativas')),
      shinyjs::disabled(
        actionButton(
          ns('responder'),
          'Responder',
          onclick = 'document.getElementById(this.id).disabled = true'
        )
      )
    )
  })

  # output$botao_alternativas <- renderUI({
  #   r$carrossel_itens[[df$widget[it_select() + 1]]](
  #     df,
  #     it_select() + 1, # adicionamos 1 por conta da instrução
  #     ns
  #   )
  # })

  # observe({
  #   # Lógica para habilitar o botão de responder
  #   if(!is.null(input$alternativas)) {
  #     if(input$alternativas != ''){
  #       shinyjs::enable('responder')
  #     }
  #   }
  # })

  # selecionar o item
  it_select <- reactive({

    if(is.null(r_object$aplicados)) return(0)

    next_item(
      mod = r_object,
      df = df,
      itens_disponiveis = itens_disponiveis
    )

  })

  # quando clicar em responder
  # observeEvent(input$responder, {
  #
  #   # se for o primeiro item
  #   if(is.null(r_object$aplicados)){
  #     r_object <- cria_r_cat(
  #       mod = r_object,
  #       df = df
  #     )
  #   } else {
  #
  #     r_object <- atualiza_r_cat(
  #       mod = r_object,
  #       it_select = it_select(),
  #       input = input$alternativas,
  #       df = df,
  #       modelo_cat = modelo
  #     )
  #
  #     r_object$fim <- fim_cat(
  #       # criterios
  #       rule = list(
  #         fixed = 1,
  #         tempo_limite = 1000.5
  #       ),
  #       current = list(
  #         applied = length(r_object$aplicados),
  #         hist_resp_time = r_object$hist_resp_time
  #       )
  #     )
  #
  #     if(r_object$fim$stop){
  #
  #       r$theta_enem <- transform_nota(
  #         nota_01 = r_object$theta,
  #         area = area
  #       )
  #
  #       r$theta_hist <- transform_nota(
  #         nota_01 = r_object$theta_hist,
  #         area = area
  #       )
  #
  #       r$padrao <- r_object$padrao
  #
  #       r$aplicados <- r_object$aplicados
  #
  #       r$tempo <- r_object$hist_resp_time
  #
  #       r$grafico <- cria_grafico(
  #         info = r
  #       )
  #
  #       ui <- renderUI({
  #         mod_devolutiva_ui("devolutiva_1")
  #       })
  #
  #     }
  #   }
  # })
return(ui)
}
