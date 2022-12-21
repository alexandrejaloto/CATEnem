#' cria_r_cat
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
cria_r_cat <- function(
  mod,
  df,
  instrucao = 'instrucao$'
){
  mod$aplicados <- numeric(0)
  mod$padrao <- rep(NA, nrow(df[!grepl(instrucao, df$cod_item),]))
  mod$resp_itens <- rep(NA, nrow(df[!grepl(instrucao, df$cod_item),]))
  mod$theta_hist <- 0
  mod$se_hist <- 1
  mod$hist_resp_time <- Sys.time()

  return(mod)
}
