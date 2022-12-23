#' next_item
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
next_item <- function(
  mod,
  df,
  itens_disponiveis,
  content.names = c(1:30),
  content.props = rep(1/30, 30)
){
  # Retirar a instrução
  df <- df[!grepl('instrucao$', df$cod_item),]

  # Caso seja o primeiro item
  if(length(mod$aplicados) == 0){
    # aplicados_disponiveis <- NULL
    mod$theta <- 0
    out <- NULL
  } else{
    out <- which(itens_disponiveis$cod_item %in% df$cod_item[mod$aplicados])
  }


  item_select <- simCAT::select.item(
    # catR::nextItem(
    bank = as.matrix(itens_disponiveis[,c('a', 'b', 'c', 'd')]),
    theta = mod$theta,
    administered = out,
    sel.method = 'progressive',
    cat.type = 'fixed',
    thr = 20,
    content.names = content.names,
    content.props = content.props,
    content.items = itens_disponiveis$faceta
  )

  it_select <- which(df$cod_item == item_select$name)

  return(it_select)
}
