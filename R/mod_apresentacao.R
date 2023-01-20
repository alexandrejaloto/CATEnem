#' apresentacao UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_apresentacao_ui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns("ui"))
  )
}

#' apresentacao Server Functions
#'
#' @noRd
mod_apresentacao_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    output$ui <- renderUI({
      tagList(
        h1('CATEnem'),
        'Você poderá responder à CATEnem, que é uma versão adaptativa do Enem.
        CAT é a sigla para
        Testagem Adaptativa Computadorizada em português. Nesse tipo de
        testagem, as questões vão sendo escolhidas de acordo com a sua
        resposta. De forma geral, quando você acerta, o programa seleciona
        uma questão mais difícil. Quando você erra, o programa seleciona
        uma questão mais fácil. Dessa maneira, o teste é mais eficiente
        porque com menos questões do que no teste tradicional o programa
        consegue calcular sua nota com menos erro.',
        br(),
        br(),
        'A CATEnem contém questões passadas do Enem de 2009 a 2020.
        Ao final da sua prova, você receberá uma nota que é calculada
        da mesma maneira que a nota do Enem é calculada, incluindo
        a Teoria de Resposta ao Item (TRI). É como se esta prova fosse
        um espelho do Enem: se o Enem fosse hoje, qual seria sua nota?
        Claro que não seria exatamente a mesma nota, porque no dia da
        prova
        outros fatores interferem (como ansiedade, cansaço e
        diferença no conteúdo das questões respondidas).
        Além disso, o Enem oficial não é
        adaptativo. De todo modo, acredito que a CATEnem é um grande
        exercício preparatório para o Enem. Aproveite sem moderação!',
        br(),
        br(),
        'Se você quiser saber mais sobre como funciona a aplicação de
        uma CAT e sobre a TRI,
        visite http://jaloto.shinyapps.io/app_tri ou entre em contato
        comigo: alexandrejaloto@gmail.com.',
        br(),
        br(),
        'Cada prova tem 20 questões e você pode responder quantas
        vezes quiser. Porém, existem algumas considerações:',
        br(),
        '- o tempo máximo da prova é de 70 minutos. Após esse tempo, a
        aplicação é interrompida ',
        br(),
        '- você não pode voltar para uma questão que já respondeu',
        br(),
        '- quando você responde mais de uma vez a mesma prova, algumas
        questões podem se repetir',
        br(),
        br(),
        radioButtons(
          ns('prova'),
          width = '100%',
          label = 'Selecione a prova que deseja responder.',
          choiceNames = c(
            'Ciências Humanas',
            'Ciências da Natureza',
            'Linguagens e Códigos (língua estrangeira: inglês)',
            'Linguagens e Códigos (língua estrangeira: espanhol)',
            'Matemática'
          ),
          choiceValues = c(
            'CH',
            'CN',
            'LC_ingles',
            'LC_espanhol',
            'MT'
          ),
          selected = character(0)
        ),
        shinyjs::disabled(
          actionButton(
            ns("avancar"),
            label = "Avançar"
          )
        ),
        br(),
        'Apoio:',
        br(),
        img(src ='https://raw.githubusercontent.com/alexandrejaloto/CATEnem/master/data-raw/Catvante-07.png', width = 300)
      )
    })

    # Lógica para habilitar o botão de avançar
    observe({
      if(!is.null(input$prova)) {
        shinyjs::enable('avancar')
      }
    })

    # Ao clicar o botão
    observeEvent(input$avancar, {
      if(input$prova == 'CH'){
        output$ui <- renderUI(mod_CH_ui("CH_ui_1"))
      }
      if(input$prova == "CN"){
        output$ui <- renderUI(mod_CN_ui("CN_1"))
      }
      if(input$prova == "LC_ingles"){
        output$ui <- renderUI(mod_LC_ingles_ui("LC_ingles_1"))
      }
      if(input$prova == "LC_espanhol"){
        output$ui <- renderUI(mod_LC_espanhol_ui("LC_espanhol_1"))
      }
      if(input$prova == "MT"){
        output$ui <- renderUI(mod_MT_ui("MT_1"))
      }

    })

  })
}
