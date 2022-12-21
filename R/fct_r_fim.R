#' r_fim
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
r_fim <- function(r, area)
{

  # se estourou o tempo, desconsidera o último item
  # if(r$CH$fim$tempo_estourado)
  #   respondidos <- r[[area]]$aplicados[-length(r[[area]]$aplicados)]
  #
  #
  # r[[area]]$padrao

  # r[[area]]$theta <- r[[area]]$theta_hist[[length(r[[area]]$aplicados)]]

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
