#' transform_nota
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
transform_nota <- function(
  nota_01,
  area
) {

  s <- constantes[constantes$area == area, 's']
  m <- constantes[constantes$area == area, 'm']

  theta <- nota_01 * s + m

  return(theta)
}
