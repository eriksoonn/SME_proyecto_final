source("metrics.R")

#' Clase Filtro
#'
#' @description
#' Constructor que inicializa un filtro de datos con el DataFrame original.
#'
#' @param dataframe (DataFramePersonalizado) DataFrame con los datos originales.
#' @return Un objeto de clase Filtro.
#' @export
Filtro <- function(dataframe) {
  e <- new.env()
  e$df_original <- dataframe
  e$datos_filtrados <- list()
  class(e) <- "Filtro"
  return(e)
}

#' Método para validar las columnas especificadas.
#'
#' @param filtro El objeto Filtro.
#' @param columnas (list[str] | NULL) Lista de nombres de columnas a validar, o NULL para usar todas las columnas.
#' @return list[str]: Lista de columnas válidas que existen en el DataFrame original.
#' @examples
#' columnas_validas <- _validar_columnas(filtro, columnas)
#' @export
validar_columnas <- function(filtro, columnas = NULL) {
  if (is.null(columnas)) {
    return(names(filtro$df_original$datos))
  }
  if (!is.list(columnas) || !all(sapply(columnas, is.character))) {
    stop("`columnas` debe ser una lista de nombres de columnas.")
  }
  Filter(function(col) col %in% names(filtro$df_original$datos), columnas)
}

#' Método para filtrar columnas en función de la entropía.
#'
#' @param filtro El objeto Filtro.
#' @param umbral (float) Umbral de entropía por encima del cual se filtran las columnas.
#' @param columnas (list[str] | NULL) Lista de nombres de columnas a filtrar, o NULL para todas las columnas.
#' @examples
#' filtrar_por_entropía(filtro, umbral, columnas)
#' @export
filtrar_por_entropia <- function(filtro, umbral, columnas = NULL) {
  columnas_a_filtrar <- validar_columnas(filtro, columnas)
  for (nombre_columna in columnas_a_filtrar) {
    columna <- obtener_columna(filtro$df_original, nombre_columna)
    valor_entropía <- entropia(columna)
    if (valor_entropía > umbral) {
      filtro$datos_filtrados[[nombre_columna]] <- columna
    }
  }
}

#' Método para filtrar columnas en función de la varianza.
#'
#' @param filtro El objeto Filtro.
#' @param umbral (float) Umbral de varianza por encima del cual se filtran las columnas.
#' @param columnas (list[str] | NULL) Lista de nombres de columnas a filtrar, o NULL para todas las columnas.
#' @examples
#' filtrar_por_varianza(filtro, umbral, columnas)
#' @export
filtrar_por_varianza <- function(filtro, umbral, columnas = NULL) {
  columnas_a_filtrar <- validar_columnas(filtro, columnas)
  for (nombre_columna in columnas_a_filtrar) {
    columna <- obtener_columna(filtro$df_original, nombre_columna)
    if (all(sapply(columna, is.numeric))) {
      valor_varianza <- varianza(columna)
      if (valor_varianza > umbral) {
        filtro$datos_filtrados[[nombre_columna]] <- columna
      }
    }
  }
}

#' Método para filtrar columnas en función del AUC (Area Under the Curve) en relación a una columna de clase binaria.
#'
#' @param filtro El objeto Filtro.
#' @param umbral (float) Umbral de AUC por encima del cual se filtran las columnas.
#' @param nombre_columna_clase (str) Nombre de la columna de clase binaria.
#' @param columnas (list[str] | NULL) Lista de nombres de columnas a filtrar, o NULL para todas las columnas.
#' @examples
#' filtrar_por_auc(filtro, umbral, nombre_columna_clase, columnas)
#' @export
filtrar_por_auc <- function(filtro, umbral, nombre_columna_clase, columnas = NULL) {
  if (!(nombre_columna_clase %in% names(filtro$df_original$datos))) {
    stop(paste("La columna de clase especificada '", nombre_columna_clase, "' no existe.", sep = ""))
  }
  columnas_a_filtrar <- validar_columnas(filtro, columnas)
  for (nombre_columna in columnas_a_filtrar) {
    if (nombre_columna == nombre_columna_clase) next
    columna <- obtener_columna(filtro$df_original, nombre_columna)
    if (all(sapply(columna, is.numeric))) {
      valor_auc <- auc(columna, obtener_columna(filtro$df_original, nombre_columna_clase))
      if (valor_auc > umbral) {
        filtro$datos_filtrados[[nombre_columna]] <- columna
      }
    }
  }
}

#' Método para obtener un nuevo DataFrame con los datos filtrados.
#'
#' @param filtro El objeto Filtro.
#' @return DataFramePersonalizado: DataFrame que contiene solo las columnas que cumplen con los filtros aplicados.
#' @examples
#' df_filtrado <- obtener_data_frame_filtrado(filtro)
#' @export
obtener_data_frame_filtrado <- function(filtro) {
  DataFrame(filtro$datos_filtrados)
}
