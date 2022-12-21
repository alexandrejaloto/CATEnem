#' devolutiva UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_devolutiva_ui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns("ui"))
  )
}

#' devolutiva Server Functions
#'
#' @noRd
mod_devolutiva_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    output$ui <- renderUI({
      tagList(
        h3('Resultado'),
        htmlOutput(ns('texto_devolutiva')),
        shiny::plotOutput(ns('grafico_devolutiva'))
      )
    })

    output$texto_devolutiva <- renderUI({
      HTML(
        paste0(
          'Sua nota na CAT Enem foi ',
          round(r$theta_enem, 1),
          '.',
          br(),
          'Quantidade de questões respondidas: ',
          length(r$aplicados),
          br(),
          'Seu tempo de prova foi ',
          r$tempo,
          ' minutos.',
          br(),
          br(),
          'A seguir você pode ver um gráfico que representa a sua jornada
          neste teste. Em cada ponto, o acerto é representado por um
          círculo e o
          erro é representado por um “X”. O triângulo representa o
          início da aplicação, quando nenhuma questão havia sido
          administrada. Em um teste adaptativo, as questões são
          selecionadas de acordo com a resposta anterior. A cada questão
          administrada, o programa recalcula a sua nota, que está
          representada no eixo "y" do gráfico. A próxima questão
          administrada levará em conta a nota provisória. A tendência é
          que ao longo da aplicação a diferença entre uma nota provisória
          e outra vá diminuindo. Conforme a aplicação vai chegando ao
          final, a nota provisória tende a mudar pouco.'
        )
      )
    })

    observe({

      output$grafico_devolutiva <- shiny::renderPlot({
        ggplot2::ggplot(r$grafico, mapping = ggplot2::aes(x = x, y = y)) +
          ggplot2::geom_point(shape = r$grafico$shape, size = 3) +
          ggplot2::geom_line(linetype = 1, size = .4) +
          ggplot2::labs(x= "Questão", y = "Nota") +
          ggplot2::theme_bw()
      })

      print('devolutiva')
      print(r$theta_enem)
      print(r$theta_hist)
      print(r$padrao)
      print(r$aplicados)
    })

  })
}

## To be copied in the UI
#

## To be copied in the server
#
