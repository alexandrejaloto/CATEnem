# CH ----

# importar banco
df_CH <- read.table("data-raw/df_CH.csv", sep = ';', dec = ',', header = TRUE)
rownames(df_CH) <- df_CH$cod_item

# salvar para uso
usethis::use_data(
  df_CH,
  overwrite = TRUE
)

# constantes de transformação ----
constantes <- read.table("data-raw/constantes.csv", sep = ';', dec = ',', header = TRUE)

# salvar para uso
usethis::use_data(
  constantes,
  overwrite = TRUE
)
