#' Clase EscaladorDatos
EscaladorDatos <- function() {
  structure(list(), class = "EscaladorDatos")
}

#' Método para verificar si todos los elementos de una columna son numéricos.
#'
#' @param columna (list) Lista de elementos a verificar.
#' @return bool True si todos los elementos son de tipo int o float, False en caso contrario.
es_columna_numerica <- function(columna) {
  all(sapply(columna, is.numeric))
}

#' Método para normalizar una columna utilizando la escala min-max.
#'
#' @param columna (list[float | int]) Lista de valores numéricos a normalizar.
#' @param decimales (int) Número de decimales para redondear los valores normalizados.
#' @return list[float] Lista de valores normalizados con la escala min-max.
normalizar_min_max <- function(columna, decimales = 3) {
  min_val <- min(columna)
  max_val <- max(columna)
  if (max_val == min_val) {
    return(rep(round(0.5, decimales), length(columna)))
  }
  sapply(columna, function(x) round((x - min_val) / (max_val - min_val), decimales))
}

#' Método para estandarizar una columna, restando la media y dividiendo por la desviación estándar.
#'
#' @param columna (list[float | int]) Lista de valores numéricos a estandarizar.
#' @param decimales (int) Número de decimales para redondear los valores estandarizados.
#' @return list[float] Lista de valores estandarizados.
estandarizar <- function(columna, decimales = 3) {
  media <- mean(columna)
  varianza <- sum((columna - media) ^ 2) / length(columna)
  desviacion_estandar <- sqrt(varianza)
  if (desviacion_estandar == 0) {
    return(rep(round(0.0, decimales), length(columna)))
  }
  sapply(columna, function(x) round((x - media) / desviacion_estandar, decimales))
}

#' Método para normalizar cada columna numérica de un data.frame usando la escala min-max.
#'
#' @param df (objeto) DataFrame personalizado con los datos a normalizar.
#' @param decimales (int) Número de decimales para redondear los valores normalizados.
#' @return None
normalizar_data_frame <- function(df, decimales = 3) {
  for (nombre_columna in names(df$datos)) {
    columna <- obtener_columna(df, nombre_columna)
    if (es_columna_numerica(columna)) {
      df$datos[[nombre_columna]] <- normalizar_min_max(columna, decimales)
    }
  }
  return(df)
}

#' Método para estandarizar cada columna numérica de un data.frame, restando la media y dividiendo por la desviación estándar.
#'
#' @param df (objeto) DataFrame personalizado con los datos a estandarizar.
#' @param decimales (int) Número de decimales para redondear los valores estandarizados.
#' @return None
estandarizar_data_frame <- function(df, decimales = 3) {
  for (nombre_columna in names(df$datos)) {
    columna <- obtener_columna(df, nombre_columna)
    if (es_columna_numerica(columna)) {
      df$datos[[nombre_columna]] <- estandarizar(columna, decimales)
    }
  }
  return(df)
}
