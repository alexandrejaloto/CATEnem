#' r_fim
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
r_fim <- function(r)
{
  r$theta_enem <- transform_nota(
    nota_01 = r$theta,
    area = 'CH'
  )

  r$theta_hist <- transform_nota(
    nota_01 = r$theta_hist,
    area = 'CH'
  )

  r$padrao <- r$padrao

  r$aplicados <- r$aplicados

  r$tempo <- r$hist_resp_time

  r$grafico <- cria_grafico(
    info = r
  )

  return(r)

}
