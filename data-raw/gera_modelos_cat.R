library(mirtCAT)
library(dplyr)


# CH ----

df_CH <- read.table("data-raw/df_CH.csv", sep = ';', dec = ',', header = TRUE)
rownames(df_CH) <- df_CH$cod_item

df_CH_mirt <- df_CH[!grepl('instrucao$', df_CH$cod_item),] %>%
  dplyr::mutate(d = -a * b) %>%
  dplyr::select(a, d, c)

names(df_CH_mirt) <- c('a1', 'd', 'g')

modelo_CH <- mirtCAT::generate.mirt_object(
  df_CH_mirt,
  '3PL'
)

usethis::use_data(modelo_CH)

# CN ----

df_CN <- read.table("data-raw/df_CN.csv", sep = ';', dec = ',', header = TRUE)
rownames(df_CN) <- df_CN$cod_item

df_CN_mirt <- df_CN[!grepl('instrucao$', df_CN$cod_item),] %>%
  dplyr::mutate(d = -a * b) %>%
  dplyr::select(a, d, c)

names(df_CN_mirt) <- c('a1', 'd', 'g')

modelo_CN <- mirtCAT::generate.mirt_object(
  df_CN_mirt,
  '3PL'
)

usethis::use_data(modelo_CN)

# LC ----

df_LC <- read.table("data-raw/df_LC.csv", sep = ';', dec = ',', header = TRUE)
rownames(df_LC) <- df_LC$cod_item

df_LC_mirt <- df_LC[!grepl('instrucao$', df_LC$cod_item),] %>%
  dplyr::mutate(d = -a * b) %>%
  dplyr::select(a, d, c)

names(df_LC_mirt) <- c('a1', 'd', 'g')

modelo_LC <- mirtCAT::generate.mirt_object(
  df_LC_mirt,
  '3PL'
)

usethis::use_data(modelo_LC)


# MT ----

df_MT <- read.table("data-raw/df_MT.csv", sep = ';', dec = ',', header = TRUE)
rownames(df_MT) <- df_MT$cod_item

df_MT_mirt <- df_MT[!grepl('instrucao$', df_MT$cod_item),] %>%
  dplyr::mutate(d = -a * b) %>%
  dplyr::select(a, d, c)

names(df_MT_mirt) <- c('a1', 'd', 'g')

modelo_MT <- mirtCAT::generate.mirt_object(
  df_MT_mirt,
  '3PL'
)

usethis::use_data(modelo_MT)

