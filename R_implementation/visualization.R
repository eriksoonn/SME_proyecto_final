source("metrics.R")

#' Clase VisualizadorDatos
#'
#' Constructor que inicializa el visualizador de datos con un DataFrame y una calculadora de correlación.
#' @param dataframe (DataFramePersonalizado) DataFrame con los datos.
#' @param correlacion (CalculadoraCorrelacion) Instancia para calcular correlaciones.
#' @return Un objeto de clase VisualizadorDatos.
#' @export
VisualizadorDatos <- function(dataframe, correlacion = NULL) {
  structure(
    list(
      dataframe = dataframe,
      correlacion = correlacion
    ),
    class = "VisualizadorDatos"
  )
}

#' Método para graficar la curva ROC y calcular el AUC.
#'
#' @param visualizador (VisualizadorDatos) El objeto VisualizadorDatos.
#' @param columna_predictora (str) Nombre de la columna con los valores del predictor.
#' @param columna_clase (str) Nombre de la columna con los valores de la clase binaria.
#' @return None
#' @export
graficar_auc <- function(visualizador, columna_predictora, columna_clase) {
  valores_clase <- obtener_columna(visualizador$dataframe, columna_clase)
  valores_predictor <- obtener_columna(visualizador$dataframe, columna_predictora)
  
  pares_ordenados <- data.frame(predictor = valores_predictor, clase = valores_clase)
  pares_ordenados <- pares_ordenados[order(pares_ordenados$predictor), ]
  
  clase_ordenada <- pares_ordenados$clase
  
  tpr <- c(0)
  fpr <- c(0)
  conteo_positivos <- sum(clase_ordenada)
  conteo_negativos <- length(clase_ordenada) - conteo_positivos
  tp <- 0
  fp <- 0
  auc_sum <- 0
  
  for (i in seq_along(clase_ordenada)) {
    if (clase_ordenada[i] == 1) {
      tp <- tp + 1
    } else {
      fp <- fp + 1
    }
    tpr <- c(tpr, tp / conteo_positivos)
    fpr <- c(fpr, fp / conteo_negativos)
    if (i > 1) {
      auc_sum <- auc_sum + (fpr[i] - fpr[i - 1]) * tpr[i]
    }
  }
  
  plot(fpr, tpr, type = "o", xlab = "Tasa de Falsos Positivos", ylab = "Tasa de Verdaderos Positivos",
       main = paste("Curva ROC (AUC =", round(auc_sum, 2), ")"))
  abline(0, 1, col = "red", lty = 2)
}

#' Método para graficar la matriz de correlación o de información mutua entre columnas.
#'
#' @param visualizador (VisualizadorDatos) El objeto VisualizadorDatos.
#' @return None
#' @export
graficar_matriz_correlacion <- function(visualizador) {
  if (is.null(visualizador$correlacion)) return()
  
  resultados_correlacion <- calcular_correlacion_por_pares(visualizador$correlacion)
  columnas <- names(visualizador$dataframe$datos)
  tamano_matriz <- length(columnas)
  matriz_correlacion <- matrix(0, nrow = tamano_matriz, ncol = tamano_matriz)
  
  for (pair in names(resultados_correlacion)) {
    cols <- strsplit(pair, "_")[[1]]
    col1 <- cols[1]
    col2 <- cols[2]
    i <- match(col1, columnas)
    j <- match(col2, columnas)
    matriz_correlacion[i, j] <- matriz_correlacion[j, i] <- resultados_correlacion[[pair]]
  }
  
  image(1:tamano_matriz, 1:tamano_matriz, matriz_correlacion, col = heat.colors(12),
        axes = FALSE, xlab = "", ylab = "", main = "Matriz de Correlación / Información Mutua")
  axis(1, at = 1:tamano_matriz, labels = columnas, las = 2)
  axis(2, at = 1:tamano_matriz, labels = columnas, las = 2)
  box()
}

#' Método para graficar un histograma de entropía de variables categóricas en el DataFrame.
#'
#' @param visualizador (VisualizadorDatos) El objeto VisualizadorDatos.
#' @return None
#' @export
graficar_histograma_entropia <- function(visualizador) {
  columnas <- names(visualizador$dataframe$datos)
  
  es_columna_categorica <- function(col_data) {
    if (length(col_data) == 0) {
      return(FALSE)
    }
    if (is.character(col_data) || is.factor(col_data) || is.logical(col_data)) {
      return(TRUE)
    }
    if (is.numeric(col_data) && length(unique(col_data)) < 10) {
      return(TRUE)
    }
    return(FALSE)
  }
  
  columnas_categoricas <- Filter(function(col_name) {
    col_data <- obtener_columna(visualizador$dataframe, col_name)
    es_columna_categorica(col_data)
  }, columnas)
  
  if (length(columnas_categoricas) == 0) {
    stop("No se encontraron columnas categóricas para graficar entropía.")
  }
  
  valores_entropia <- sapply(columnas_categoricas, function(col_name) {
    col_data <- obtener_columna(visualizador$dataframe, col_name)
    entropia(col_data)
  })
  
  barplot(valores_entropia, names.arg = columnas_categoricas, col = "skyblue", las = 2,
          xlab = "Variables Categóricas", ylab = "Entropía", main = "Entropía de Variables Categóricas")
}

#' Método para graficar diagramas de caja de características continuas en el DataFrame.
#'
#' @param visualizador (VisualizadorDatos) El objeto VisualizadorDatos.
#' @param estandarizado (bool) Indica si las características deben ser estandarizadas antes de graficar.
#' @return None
#' @export
graficar_diagramas_caja_caracteristicas <- function(visualizador, estandarizado = TRUE) {
  columnas_continuas <- Filter(function(col_name) {
    col_data <- obtener_columna(visualizador$dataframe, col_name)
    is.numeric(col_data[1])
  }, names(visualizador$dataframe$datos))
  
  if (estandarizado) {
    visualizador$dataframe <- estandarizar_data_frame(visualizador$dataframe)
  }
  
  datos <- lapply(columnas_continuas, function(col_name) {
    obtener_columna(visualizador$dataframe, col_name)
  })
  
  boxplot(datos, names = columnas_continuas, las = 2, col = "skyblue", 
          ylab = ifelse(estandarizado, "Valores Estandarizados", "Valores"),
          main = paste("Diagramas de Caja de Características Continuas", 
                       ifelse(estandarizado, " (Estandarizado)", "")))
}

# Fuente de funciones auxiliares
source("metrics.R")
