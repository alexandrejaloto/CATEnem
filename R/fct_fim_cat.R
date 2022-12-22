#' fim_cat
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
fim_cat <- function(
  rule = list(
    se = NULL,
    delta.theta = NULL,
    hypo = NULL,
    hyper = NULL,
    info = NULL,
    max.items = NULL,
    min.items = NULL,
    fixed = NULL,
    # limite de tempo
    tempo_limite = NULL
  ),
  current = list(
    se = NULL,
    delta.theta = NULL,
    info = NULL,
    applied = NULL,
    delta.se = NULL,
    # histórico do tempo de resposta
    hist_resp_time = NULL
  )
){

  # if there is no item minimum, it will be 0
  if(is.null(rule$min.items))
    rule$min.items <- 0

  convergence <- FALSE

  if(!is.null(rule$se) & is.null(current$se))
    stop('Please inform currrent standard error')

  if(!is.null(rule$delta.theta) & is.null(current$delta.theta))
    stop('Please inform delta.theta')

  if(!(is.null(rule$hypo) | is.null(rule$hyper)) & is.null(current$delta.se))
    stop('Please inform delta.se')

  if((!is.null(rule$hypo) | !is.null(rule$hyper)) & is.null(rule$se))
    stop('Please inform current standard error')

  if(!is.null(rule$hypo) & is.null(rule$hyper))
    stop('Please inform hyper')

  if(is.null(rule$hypo) & !is.null(rule$hyper))
    stop('Please inform hypo')

  if(!is.null(rule$info) & is.null(current$info))
    stop('Please inform maximum information')

  # if(!is.null(current$applied) & (is.null(rule$max.items) & is.null(rule$fixed)))
  #   warning('You informed quantitative of applied items, but there is no rule related to it. Is it correct?')

  if(!is.null(rule$fixed) & (!is.null(rule$max.items) | !is.null(rule$delta.theta) | !is.null(rule$se) | !is.null(rule$delta.se) | !is.null(rule$info) | !is.null(rule$hypo)))
    stop('You chose fixed items and other variable-length rules. Choose one.')

  stop <- FALSE

  if(!is.null(rule$se))
    stop <- stop | current$se <= rule$se

  if(!is.null(rule$info))
    stop <- stop | current$info < rule$info

  if(!is.null(rule$delta.theta))
    stop <- stop | abs(current$delta.theta) <= rule$delta.theta

  if(!is.null(rule$hyper))
  {
    stop <- (current$delta.se <= rule$hyper) & current$se <= rule$se
    stop <- stop | current$delta.se <= rule$hypo
  }

  if (current$applied < rule$min.items)
    stop <- FALSE

  if (stop)
    convergence <- TRUE

  if (!is.null(rule$max.items)){
    if(is.null(current$applied))
      stop('Please inform quantitative of applied items')
    stop <- stop | current$applied >= rule$max.items
  }

  if (!is.null(rule$fixed)){
    if(is.null(current$applied))
      stop('Please inform quantitative of applied items')
    stop <- current$applied == rule$fixed
    if(stop)
      convergence <- TRUE
  }

  tempo_estourado <- NULL

  # Convergência por tempo
  if(!is.null(rule$tempo_limite)){

    if(is.null(current$hist_resp_time))
      stop('Favor informar o histórico do tempo de prova')

    tempo_estourado <- difftime(
      current$hist_resp_time[length(current$hist_resp_time)],
      current$hist_resp_time[1],
      units = c('mins')
    ) >= rule$tempo_limite

    # Estabelece que o fim é verdadeiro pois respondeu acima do limite de tempo
    if(tempo_estourado){
      stop <- TRUE
    }
  }

  stop <- list(
    stop = stop,
    convergence = convergence
  )

  if (!is.null(tempo_estourado))
    stop$tempo_estourado <- tempo_estourado

  return(stop)

}

