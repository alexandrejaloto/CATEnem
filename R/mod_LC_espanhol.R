#' LC_espanhol UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_LC_espanhol_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' LC_espanhol Server Functions
#'
#' @noRd 
mod_LC_espanhol_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_LC_espanhol_ui("LC_espanhol_1")
    
## To be copied in the server
# mod_LC_espanhol_server("LC_espanhol_1")
