#' atualiza_r_cat
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
atualiza_r_cat <- function(
  mod,
  it_select,
  input,
  df,
  modelo_cat
){

  df <- df[!grepl('instrucao$', df$cod_item),]

  # hora de resposta
  # mod$hist_resp_time <- c(mod$hist_resp_time, Sys.time())

  # atualizar o padrão de resposta -----
  mod$padrao[it_select] <- mirt::key2binary(
    t(input),
    df$gabarito[it_select]
  )

  mod$resp_itens[it_select] <- input

  # atualizar os itens aplicados -----
  mod$aplicados <- c(mod$aplicados, it_select)

  # calcular o theta -----
  theta_prov <- mirt::fscores(modelo_cat, response.pattern = mod$padrao)

  # atualizar o theta_cat ----
  mod$theta <- data.frame(theta_prov)$F1

  # atualizar o histórico do theta ----
  mod$theta_hist <- c(mod$theta_hist, mod$theta)

  # erro ----
  se_prov <- data.frame(theta_prov)$SE_F1

  # atualizar o histórico do erro ----
  mod$se_hist <- c(mod$se_hist, se_prov)

  return(
    mod
  )
}
