#' r_fim
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
r_fim <- function(r, area, modelo_cat)
{

  # caso o tempo tenha estourado, excluir a última resposta e tudo atrelado a ela
  if(r[[area]]$fim$tempo_estourado)
  {
    r[[area]]$padrao[r[[area]]$aplicados[length(r[[area]]$aplicados)]] <- NA
    r[[area]]$theta_hist <- r[[area]]$theta_hist[-length(r[[area]]$aplicados)]
    r[[area]]$se_hist <- r[[area]]$se_hist[-length(r[[area]]$aplicados)]
    r[[area]]$aplicados <- r[[area]]$aplicados[-length(r[[area]]$aplicados)]
    r[[area]]$theta <- r[[area]]$theta_hist[length(r[[area]]$aplicados)]
    r[[area]]$se <- r[[area]]$se[length(r[[area]]$aplicados)]
  }

  r$theta_enem <- transform_nota(
    nota_01 = r[[area]]$theta,
    area = area
  )

  r$theta_hist <- transform_nota(
    nota_01 = r[[area]]$theta_hist,
    area = area
  )

  r$padrao <- r[[area]]$padrao

  r$aplicados <- r[[area]]$aplicados

  # r$tempo <- r[[area]]$hist_resp_time

  r$tempo <- round(
    difftime(
      r[[area]]$hist_resp_time[length(r[[area]]$hist_resp_time)],
      r[[area]]$hist_resp_time[1],
      units = c('mins')
    ),
    1
  )

  r$grafico <- cria_grafico(
    info = r
  )

  return(r)

}
