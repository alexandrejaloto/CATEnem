#' cria_grafico
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
#
cria_grafico <- function(
  info
){
  grafico <- data.frame(
      x = 1:length(info$aplicados),
      y = info$theta_hist[-1],
      resp = c(as.numeric(info$padrao[info$aplicados]))
    )
    grafico$shape = ifelse(grafico$resp == 1, 1, 4)
    # grafico$shape[1] <- 2

    return(grafico)

  }
