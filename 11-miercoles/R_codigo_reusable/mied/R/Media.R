#' Mi función para calcular la media
#' 
#' Toma un vector de datos numéricos y regresa la media.
#' 
#' @param x vector de datos
#'
#' @details Esta función sirve para ...  
#'
#' @return valor numérico de la media
#'
#' @author Héctor Villalobos.   
#'
#' @seealso \code{\link{mean}}.
#'
#' @examples
#' data(longitud)
#' # cálculo de la media
#' prom.long <- Media(x = longitud)
#' prom.long
#'
#' @export
Media <- function(x){
  sum.x <- sum(x)
  n <- length(x)
  resultado <- sum.x/n
  resultado
}