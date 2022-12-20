#'-----------------------------------------------------------------------------
#' PROJETO: ENEM
#'
#' OBJETIVO: O objetivo deste script é criar os modelos do mirt para cálculo
#' do escore
#'
#' PRODUTO: modelos
#'
#' AUTOR: Araê Cainã
#'
#' DATA DE CRIACAO: 07/2022
#'
#' DATA DE MODIFICACAO:
#'
#' MODIFICACOES:
#'-----------------------------------------------------------------------------

library(mirtCAT)
library(mongolite)
library(dplyr)


# CAT_1_CH ----------------------------------------------------------------

con_df_cat_1_ch <- mongolite::mongo(
  'df_CAT_1_CH', # mudar aqui
  url = 'mongodb+srv://enem:c4Tv2302@cluster0.toje6lu.mongodb.net/df_instrumento',
  options = mongolite::ssl_options(weak_cert_validation = T)
)

df_cat_1_ch <- con_df_cat_1_ch$find()
# write.table(
#   df_cat_1_ch,
#   'data-raw/df_CH.csv',
#   row.names = FALSE,
#   sep = ';',
#   dec = ','
# )
con_df_cat_1_ch$disconnect()

rownames(df_cat_1_ch) <- df_cat_1_ch$cod_item

df_cat_1_ch_mirt <- df_cat_1_ch[!grepl('instrucao$', df_cat_1_ch$cod_item),] %>%
  dplyr::mutate(d = -a * b) %>%
  dplyr::select(a, d, c)

names(df_cat_1_ch_mirt) <- c('a1', 'd', 'g')

modelo_CAT_1_CH <- mirtCAT::generate.mirt_object(
  df_cat_1_ch_mirt,
  '3PL'
)

usethis::use_data(modelo_CAT_1_CH)


# CAT_1_CN ----------------------------------------------------------------

con_df_cat_1_cn <- mongolite::mongo(
  'df_CAT_1_CN', # mudar aqui
  url = 'mongodb+srv://enem:c4Tv2302@cluster0.toje6lu.mongodb.net/df_instrumento',
  options = mongolite::ssl_options(weak_cert_validation = T)
)

df_cat_1_cn <- con_df_cat_1_cn$find()

con_df_cat_1_cn$disconnect()

rownames(df_cat_1_cn) <- df_cat_1_cn$cod_item

df_cat_1_cn_mirt <- df_cat_1_cn[!grepl('instrucao$', df_cat_1_cn$cod_item),] %>%
  dplyr::mutate(d = -a * b) %>%
  dplyr::select(a, d, c)

names(df_cat_1_cn_mirt) <- c('a1', 'd', 'g')

modelo_CAT_1_CN <- mirtCAT::generate.mirt_object(
  df_cat_1_cn_mirt,
  '3PL'
)

usethis::use_data(modelo_CAT_1_CN)

# CAT_1_LC ----------------------------------------------------------------

con_df_cat_1_lc <- mongolite::mongo(
  'df_CAT_1_LC', # mudar aqui
  url = 'mongodb+srv://enem:c4Tv2302@cluster0.toje6lu.mongodb.net/df_instrumento',
  options = mongolite::ssl_options(weak_cert_validation = T)
)

df_cat_1_lc <- con_df_cat_1_lc$find()

con_df_cat_1_lc$disconnect()

rownames(df_cat_1_lc) <- df_cat_1_lc$cod_item

df_cat_1_lc_mirt <- df_cat_1_lc[!grepl('instrucao$', df_cat_1_lc$cod_item),] %>%
  dplyr::mutate(d = -a * b) %>%
  dplyr::select(a, d, c)

names(df_cat_1_lc_mirt) <- c('a1', 'd', 'g')

modelo_CAT_1_LC <- mirtCAT::generate.mirt_object(
  df_cat_1_lc_mirt,
  '3PL'
)

usethis::use_data(modelo_CAT_1_LC)

# CAT_1_MT ----------------------------------------------------------------

con_df_cat_1_mt <- mongolite::mongo(
  'df_CAT_1_MT', # mudar aqui
  url = 'mongodb+srv://enem:c4Tv2302@cluster0.toje6lu.mongodb.net/df_instrumento',
  options = mongolite::ssl_options(weak_cert_validation = T)
)

df_cat_1_mt <- con_df_cat_1_mt$find()

con_df_cat_1_mt$disconnect()

rownames(df_cat_1_mt) <- df_cat_1_mt$cod_item

df_cat_1_mt_mirt <- df_cat_1_mt[!grepl('instrucao$', df_cat_1_mt$cod_item),] %>%
  dplyr::mutate(d = -a * b) %>%
  dplyr::select(a, d, c)

names(df_cat_1_mt_mirt) <- c('a1', 'd', 'g')

modelo_CAT_1_MT <- mirtCAT::generate.mirt_object(
  df_cat_1_mt_mirt,
  '3PL'
)

usethis::use_data(modelo_CAT_1_MT)
