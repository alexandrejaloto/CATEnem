#' aut
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
aut <- function(
  df = df_CH,
  r = r$CH,
  it_select = it_selet(),
  # output = output,
  # r_object = r,
  # modelo = modelo_CH,
  # area = 'CH',
  input = input
  # ui = output$ui,
  # ns = ns
){

  r <- atualiza_r_cat(
    mod = r,
    it_select = it_select,
    input = input$alternativas,
    df = df,
    modelo_cat = modelo_CH
  )

  r$fim <- fim_cat(
    # criterios
    rule = list(
      fixed = 1,
      tempo_limite = 1000.5
    ),
    current = list(
      applied = length(r$aplicados),
      hist_resp_time = r$hist_resp_time
    )
  )

  return(r)

}
