#' Clase Correlacion
#' 
#' Constructor que inicializa la calculadora de correlación con un DataFrame.
#' 
#' @param dataframe DataFrame con los datos.
#' @return Objeto de clase Correlacion.
Correlacion <- function(dataframe) {
  structure(list(dataframe = dataframe), class = "Correlacion")
}

#' Método para verificar si todos los elementos de una columna son numéricos.
#' 
#' @param columna Lista de elementos a verificar.
#' @return TRUE si todos los elementos son numéricos (int o float), FALSE en caso contrario.
es_numerico <- function(columna) {
  all(sapply(columna, is.numeric))
}

#' Método para calcular la correlación de Pearson entre dos columnas numéricas.
#' 
#' @param col1 Primera columna de valores numéricos.
#' @param col2 Segunda columna de valores numéricos.
#' @return Valor de correlación de Pearson entre col1 y col2.
correlacion_pearson <- function(col1, col2) {
  media1 <- mean(col1)
  media2 <- mean(col2)
  num <- sum((col1 - media1) * (col2 - media2))
  den1 <- sqrt(sum((col1 - media1) ^ 2))
  den2 <- sqrt(sum((col2 - media2) ^ 2))
  if (den1 != 0 && den2 != 0) {
    num / (den1 * den2)
  } else {
    0
  }
}

#' Método para calcular la información mutua entre dos columnas categóricas.
#' 
#' @param col1 Primera columna de valores.
#' @param col2 Segunda columna de valores.
#' @return Valor de información mutua entre col1 y col2.
informacion_mutua <- function(col1, col2) {
  # Contadores de frecuencias conjuntas y marginales
  conteo_conjunto <- table(col1, col2)
  conteo_col1 <- rowSums(conteo_conjunto)
  conteo_col2 <- colSums(conteo_conjunto)
  total <- sum(conteo_conjunto)
  
  # Cálculo de la información mutua
  informacion_mutua <- 0
  for (i in seq_len(nrow(conteo_conjunto))) {
    for (j in seq_len(ncol(conteo_conjunto))) {
      conteo <- conteo_conjunto[i, j]
      if (conteo > 0) {
        p_xy <- conteo / total
        p_x <- conteo_col1[i] / total
        p_y <- conteo_col2[j] / total
        informacion_mutua <- informacion_mutua + p_xy * log2(p_xy / (p_x * p_y))
      }
    }
  }
  informacion_mutua
}

#' Método para calcular la correlación entre todas las combinaciones de columnas en el DataFrame.
#' 
#' Para columnas numéricas se usa la correlación de Pearson, y para categóricas, la información mutua.
#' 
#' @param calculadora Objeto de clase Correlacion.
#' @return Diccionario con las correlaciones entre pares de columnas.
#'         Las llaves son tuplas (nombre_col1, nombre_col2) y los valores son los coeficientes de correlación.
calcular_correlacion_por_pares <- function(calculadora) {
  resultados_correlacion <- list()
  columnas <- names(calculadora$dataframe$datos)
  numero_columnas <- length(columnas)
  
  for (i in seq_len(numero_columnas - 1)) {
    col1_name <- columnas[i]
    col1 <- obtener_columna(calculadora$dataframe, col1_name)
    for (j in seq(i + 1, numero_columnas)) {
      col2_name <- columnas[j]
      col2 <- obtener_columna(calculadora$dataframe, col2_name)
      if (es_numerico(col1) && es_numerico(col2)) {
        correlacion <- correlacion_pearson(col1, col2)
      } else {
        correlacion <- informacion_mutua(col1, col2)
      }
      resultados_correlacion[[paste(col1_name, col2_name, sep = "_")]] <- correlacion
    }
  }
  resultados_correlacion
}
