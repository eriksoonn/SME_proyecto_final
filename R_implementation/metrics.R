Metricas <- function() {
  structure(list(), class = "Metricas")
}

#' Método para calcular la varianza de una columna numérica.
#'
#' @param columna (list[float | int]) Lista de valores numéricos.
#' @return float: Varianza de los valores en la columna.
varianza <- function(columna) {
  media <- mean(columna)
  sum((columna - media)^2) / length(columna)
}

#' Método para calcular la entropía de una columna categórica.
#'
#' @param columna (list) Lista de valores categóricos.
#' @return float: Entropía de los valores en la columna.
entropia <- function(columna) {
  conteo_valores <- table(columna)
  total <- length(columna)
  -sum((conteo_valores / total) * log2(conteo_valores / total))
}

#' Método para calcular el AUC (Área Bajo la Curva) de una columna en función de una columna de clase binaria.
#'
#' @param columna (list[float | int]) Lista de valores numéricos para ordenar.
#' @param columna_clase (list[int]) Lista binaria de clases asociadas a cada valor en columna.
#' @return float: Valor de AUC calculado para la columna y columna_clase.
auc <- function(columna, columna_clase) {
  pares_ordenados <- data.frame(valor = columna, clase = columna_clase)
  pares_ordenados <- pares_ordenados[order(pares_ordenados$valor), ]
  
  conteo_positivos <- sum(pares_ordenados$clase)
  conteo_negativos <- length(pares_ordenados$clase) - conteo_positivos
  suma_rangos <- 0
  rango <- 1
  indices_actuales_empatados <- c(1)
  
  for (idx in 2:nrow(pares_ordenados)) {
    if (pares_ordenados$valor[idx] == pares_ordenados$valor[idx - 1]) {
      indices_actuales_empatados <- c(indices_actuales_empatados, idx)
    } else {
      len_empate <- length(indices_actuales_empatados)
      rango_promedio <- (2 * rango + len_empate - 1) / 2
      suma_rangos <- suma_rangos + sum(rango_promedio * (pares_ordenados$clase[indices_actuales_empatados] == 1))
      rango <- rango + len_empate
      indices_actuales_empatados <- c(idx)
    }
  }
  
  if (length(indices_actuales_empatados) > 0) {
    len_empate <- length(indices_actuales_empatados)
    rango_promedio <- (2 * rango + len_empate - 1) / 2
    suma_rangos <- suma_rangos + sum(rango_promedio * (pares_ordenados$clase[indices_actuales_empatados] == 1))
  }
  
  (suma_rangos - conteo_positivos * (conteo_positivos + 1) / 2) / (conteo_positivos * conteo_negativos)
}

#' Método para calcular una métrica para una columna en un data.frame.
#'
#' @param df (DataFramePersonalizado) DataFrame con los datos.
#' @param nombre_columna (str) Nombre de la columna para la cual calcular la métrica.
#' @param nombre_columna_clase (str, opcional) Nombre de la columna de clase si es necesaria para el cálculo.
#' @return dict: Diccionario con la métrica calculada.
calcular_metrica <- function(df, nombre_columna, nombre_columna_clase = NULL) {
  # Obtener la columna deseada del DataFrame
  columna <- obtener_columna(df, nombre_columna)
  
  # Verificar si la columna está vacía o no existe
  if (is.null(columna) || length(columna) == 0) {
    stop("La columna está vacía o no existe. No se pueden calcular métricas.")
  }
  
  # Calcular el número de valores únicos y el total de valores
  valores_unicos <- unique(columna)
  num_unicos <- length(valores_unicos)
  total_valores <- length(columna)
  ratio_unicos <- num_unicos / total_valores
  
  # Determinar si la columna es numérica
  es_numerica <- all(sapply(columna, is.numeric))
  
  if (es_numerica) {
    # Decidir si tratar como categórica o numérica basado en los valores únicos
    if (num_unicos <= 10 && ratio_unicos < 0.5) {
      # Tratar como categórica y calcular entropía
      return(list("Entropía" = entropia(columna)))
    } else {
      # Tratar como numérica y calcular varianza o AUC si se proporciona la columna de clase
      if (!is.null(nombre_columna_clase)) {
        columna_clase <- obtener_columna(df, nombre_columna_clase)
        
        # Verificar si la columna de clase está vacía o no existe
        if (is.null(columna_clase) || length(columna_clase) == 0) {
          stop("La columna de clase está vacía o no existe. No se pueden calcular métricas.")
        }
        
        return(list(
          "Varianza" = varianza(columna),
          "AUC" = auc(columna, columna_clase)
        ))
      }
      return(list("Varianza" = varianza(columna)))
    }
  } else {
    # Si no es numérica, tratar como categórica y calcular entropía
    return(list("Entropía" = entropia(columna)))
  }
}