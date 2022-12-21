#' estourou_tempo
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
estourou_tempo <- function(
  mod,
  tempo_limite
){

  # hora de resposta
  mod$hist_resp_time <- c(mod$hist_resp_time, Sys.time())

  mod$tempo_estourado <- difftime(
    mod$hist_resp_time[length(mod$hist_resp_time)],
    mod$hist_resp_time[1],
    units = c('mins')
  ) >= tempo_limite

  return(mod)

}
