library (dplyr)
library (tidyr)
library(textreadr)
library(stringr)
library(sjmisc)

rm(list = ls())

# importar função para atualizar sysdata
source('rascunho/update.sysdata.R')

# salvar pars.csv ----

# testlets codes
source('rascunho/testlets.R')

pars <- data.frame()

areas <- c('CH', 'CN', 'LC', 'MT')
area <- 'CH'
year <- 2020
application <- 1
for (area in areas)
{
  for (year in 2009:2020)
  {
    # import official parameters
    items <- read.table(
      paste0('rascunho/items/ITENS_PROVA_', year, '.csv'),
      sep = ';',
      header = TRUE
    )

    for(application in 1:2)
    {
      if(year == 2009)
      {
        # filter items of each area
        items_area <- subset(items, SG_AREA = area) %>%
          # filter first testlet
          subset(CO_PROVA == testlets[[paste0('year.', year, '.', application)]][[area]][1]) %>%
          # select parameters and content
          select(starts_with('NU_PAR'), CO_HABILIDADE, CO_ITEM, CO_POSICAO, TX_GABARITO)

        if(nrow(items_area) > 0)
          items_area$TP_LINGUA <- NA

      } else {

        # filter items of each area
        items_area <- subset(items, SG_AREA = area) %>%
          # filter first testlet
          subset(CO_PROVA == testlets[[paste0('year.', year, '.', application)]][[area]][1]) %>%
          # select parameters and content
          select(starts_with('NU_PAR'), CO_HABILIDADE, TP_LINGUA, CO_ITEM, CO_POSICAO, TX_GABARITO)

      }

      if(nrow(items_area) > 0)
      {
        items_area$area <- area
        items_area$year <- year
        items_area$application <- application

        pars <- rbind(
          pars,
          items_area
        )
      }

      if(application == 2 & year %in% c(2016, 2020))
      {
        # filter items of each area
        items_area <- subset(items, SG_AREA = area) %>%
          # filter first testlet
          subset(CO_PROVA == testlets[[paste0('year.', year, '.', application)]][[area]][1]) %>%
          # select parameters and content
          select(starts_with('NU_PAR'), CO_HABILIDADE, TP_LINGUA, CO_ITEM, CO_POSICAO, TX_GABARITO)

        if(nrow(items_area) > 0)
        {
          items_area$area <- area
          items_area$year <- year
          items_area$application <- 3

          pars <- rbind(
            pars,
            items_area
          )
        }
      }
    }
  }
}

pars$TP_LINGUA <- ifelse(pars$TP_LINGUA == 0, 'i', 'e')

# a <- subset(pars, CO_ITEM %in% pars$CO_ITEM[duplicated(pars$CO_ITEM)]) %>%
#   arrange(CO_ITEM)

# pars <- pars[!duplicated(pars$CO_ITEM),]

# table(pars[pars$area == 'CH',]$CO_POSICAO)

# CH
# level_key <- rep(1:45, 3)
# names(level_key) <- 46:180

ch <- subset(pars, area == 'CH') %>%
  arrange(year, application, CO_POSICAO)
# mutate(CO_POSICAO = recode(CO_POSICAO, !!!level_key))

ch$CO_POSICAO <- 1:45

table(ch$CO_POSICAO, useNA = 'always')

# CN
# level_key <- rep(46:90, 3)
# names(level_key) <- c(1:45, 91:180)

cn <- subset(pars, area == 'CN') %>%
  arrange(year, application, CO_POSICAO)
# mutate(CO_POSICAO = recode(CO_POSICAO, !!!level_key))

cn$CO_POSICAO <- 46:90

table(cn$CO_POSICAO, useNA = 'always')

# LC
# level_key <- rep(c(rep(91:95, 2), 96:135), 3)
# names(level_key) <- rep(c(1:45, 91:180)

lc <- subset(pars, area == 'LC') %>%
  arrange(year, application, TP_LINGUA, CO_POSICAO)
# arrange(desc(TP_LINGUA), CO_POSICAO)

lc[lc$year == 2009,]$CO_POSICAO <- 91:135
lc[lc$year != 2009,]$CO_POSICAO <- c(rep(91:95, 2), 96:135)

table(lc$CO_POSICAO, useNA = 'always')

# MT
# level_key <- rep(46:90, 3)
# names(level_key) <- c(1:45, 91:180)

mt <- subset(pars, area == 'MT') %>%
  arrange(year, application, CO_POSICAO)
# mutate(CO_POSICAO = recode(CO_POSICAO, !!!level_key))

mt$CO_POSICAO <- 136:180

table(mt$CO_POSICAO, useNA = 'always')


# pars2 <- pars[duplicated(pars$CO_ITEM),]
# table(pars2$year)
# table(pars2$area)
# subset(pars2, year == 2009)
# subset (pars, CO_ITEM == 59611)

pars <- rbind(ch, cn, lc, mt)

pars$CO_POSICAO <- sprintf("%03.f", pars$CO_POSICAO)

pars$teste <- paste0('year.', pars$year, '.', pars$application)

for(i in 1:nrow(pars))
  pars$cad[i] <- testlets[[pars$teste[i]]][[pars$area[i]]][1]

pars$cad <- sprintf("%03.f", pars$cad)

pars$cod_item <- paste0(
  'enem',
  pars$year,
  pars$cad,
  pars$CO_POSICAO,
  pars$TP_LINGUA
) %>%
  sub('NA', '', .)

pars$cod_item
subset(pars, area == 'LC')$cod_item

# save(pars, file = 'rdata/pars.RData')
write.table(
  pars,
  'rascunho/pars.csv',
  row.names = FALSE,
  sep = ';',
  dec = ','
)

# salvar imagens dos itens ----

year <- 2010

for(year in 2009:2010)
{
  enem <- read_document(paste0('rascunho/provas/', year, '.docx')) %>%
    data.frame()

  names (enem) = c('item')

  enem$cod_item <- NA

  j = 1

  for (i in 1:nrow(enem))
  {
    questao <- FALSE
    while (questao == FALSE & j <= nrow(enem))
    {
      questao <- str_contains(enem[j,1], 'Questão enem20')
      if (questao)
      {
        enem$cod_item[j] <- str_sub(enem[j,1], 9)
        enem$cod_item[(j+1):nrow(enem)] <- NA
      }
      j = j + 1
    }
  }

  enem <- drop_na(enem) %>%
    select(cod_item)


  enem$cod_item <- paste0(
    # 'inst/app/www/',
    'data-raw/imagens/',
    enem$cod_item,
    '.jpg'
  )

  imgs <- list.files(paste0('rascunho/provas/imagens/', year))
  imgs <- paste0(
    'rascunho/provas/imagens/',
    year,
    '/',
    imgs
  )

  # str_count('rascunho/provas/imagens/2010/2010_')

  imgs. <- substring(imgs, 35) %>%
    sub('.jpg', '', .) %>%
    as.numeric() %>%
    sprintf("%03.f", .) %>%
    paste0(
      'rascunho/provas/imagens/',
      year,
      '/',
      year,
      '_',
      .,
      '.jpg'
    )

  file.rename(imgs, imgs.)

  imgs <- imgs.

  imgs <- imgs[order(imgs)]

  impar <- seq(1, length(imgs), 2)
  par <- seq(2, length(imgs), 2)

  file.remove(imgs[impar])

  file.rename(imgs[par], enem$cod_item)

}
# warnings()
# salvar df ----

# itens que possuem imagem
imgs <- data.frame(
  # cod_item = list.files('inst/app/www')
  cod_item = list.files('data-raw/imagens')
)

imgs$cod_item <- sub('.jpg', '', imgs$cod_item)

# importar parâmetros
pars <- read.table(
  'rascunho/pars.csv',
  sep = ';',
  dec = ',',
  header = TRUE
)
areas <- c('CH', 'CN', 'LC', 'MT')

for(area_ in areas)
{
  # area_ <- 'LC'

  pars. <- subset(pars, area == area_)
pars.$cod_item
pars.[7,]
  pars.$TP_LINGUA

  pars. <- data.frame(
    cod_item = pars.$cod_item,
    fator = pars.$TP_LINGUA,
    faceta = pars.$CO_HABILIDADE,
    polo = 1,
    descricao =  paste0(
      'https://raw.githubusercontent.com/alexandrejaloto/CATEnem/master/data-raw/imagens/',
      pars.$cod_item,
      '.jpg'
    ),
    widget = 'radio_image',
    cat_1 = 'A',
    cat_2 = 'B',
    cat_3 = 'C',
    cat_4 = 'D',
    cat_5 = 'E',
    gabarito = pars.$TX_GABARITO,
    a = pars.$NU_PARAM_A,
    b = pars.$NU_PARAM_B,
    c = pars.$NU_PARAM_C,
    d = 1
  )

  # pars.[duplicated(pars.$cod_item),]
pars.$fator
  # imgs$cod_item <- paste0(
  #   'inst/app/www/',
  #   imgs$cod_item,
  #   '.jpg'
  # )

  # table(pars.$cad)
# df_LC$cod_item

  pars. <- inner_join(pars., imgs, 'cod_item') %>%
    drop_na(a)
pars.$fator
pars.$cod_item
  instrucao <- data.frame(

    cod_item = 'instrucao',
    fator = 'instrucao',
    faceta = 'instrucao',
    polo = 1,
    descricao =  '<p>ATEN&Ccedil;&Atilde;O: ap&oacute;s clicar em &quot;Avan&ccedil;ar&quot;, o tempo come&ccedil;ar&aacute; a contar. Voc&ecirc; ter&aacute; 70 minutos para responder a prova.</p>',
    widget = 'instrucao',
    cat_1 = NA,
    cat_2 = NA,
    cat_3 = NA,
    cat_4 = NA,
    cat_5 = NA,
    gabarito = NA,
    a = NA,
    b = NA,
    c = NA,
    d = NA
  )

  pars. <- rbind(
    instrucao,
    pars.
  )

  rownames(pars.) <- pars.$cod_item

  assign(
    paste0('df_', area_),
    pars.
  )

  # # salvar para uso
  # eval(
  #   parse(
  #     text = paste0(
  #       'usethis::use_data(df_',
  #       area_,
  #       ', overwrite = TRUE)'
  #     )
  #   )
  # )

  update.sysdata(object = paste0('df_', area_))

  write.table(
    pars.,
    paste0('data-raw/df_', area_, '.csv'),
    row.names = FALSE,
    dec = ',',
    sep = ';'
  )

}

# apagar imagens que não estão do df ----

imgs <- list.files('data-raw/imagens') %>%
  sub('.jpg', '', .)

cod_item <- rbind(
  df_CH,
  df_CN,
  df_LC,
  df_MT
) %>%
  rownames()

img_item <- imgs %in% cod_item

imgs <- paste0('data-raw/imagens/', imgs, '.jpg')

imgs_sem_item <- imgs[!img_item]

file.remove(imgs_sem_item)

# cortar as imagens ----
library(magick)

imgs <- list.files('data-raw/imagens') %>%
  paste0('data-raw/imagens/', .)

imgs

for(cortar in imgs)
  image_read(cortar) %>%
  image_trim() %>%
  image_write(cortar)

# é aqui que precisa salvar:
# https://raw.githubusercontent.com/alexandrejaloto/CATEnem/master/inst/app/www/enem200905907.jpg

# constantes de transformação ----
constantes <- read.table("data-raw/constantes.csv", sep = ';', dec = ',', header = TRUE)

update.sysdata(object = 'constantes')
