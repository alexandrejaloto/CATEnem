# Importar banco
df_CH <- read.table("data-raw/df_CH.csv", sep = ';', dec = ',', header = TRUE)
rownames(df_CH) <- df_CH$cod_item

# salvar para uso
usethis::use_data(
  df_CH,
  overwrite = TRUE
)
