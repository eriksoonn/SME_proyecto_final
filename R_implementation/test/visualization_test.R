source("dataframe.R")
source("visualization.R")
source("correlation.R")
source("normalize.R")

#' Prueba la generación de la curva ROC y el AUC con datos de ingresos y compras.
#' @export
prueba_graficar_auc <- function() {
  df <- DataFrame(list(
    edad = c(23, 45, 31, 22, 35),
    ingreso = c(30000, 50000, 70000, 100000, 120000),
    compra = c(1, 0, 1, 0, 1)
  ))
  visualizador <- VisualizadorDatos(df)
  tryCatch({
    graficar_auc(visualizador, "ingreso", "compra")
    print("Éxito: Prueba de graficar_auc")
  }, error = function(e) {
    print(paste("Fallo: Prueba de graficar_auc con error:", e$message))
  })
}

#' Prueba la generación de la matriz de correlación con datos de diferentes tipos.
#' @export
prueba_graficar_matriz_correlacion <- function() {
  df <- DataFrame(list(
    edad = c(23, 45, 31, 22, 35),
    ingreso = c(30000, 50000, 70000, 100000, 120000),
    compra = c(1, 0, 1, 0, 1),
    categoria = c(1, 1, 2, 2, 3)
  ))
  correlacion <- Correlacion(df)
  visualizador <- VisualizadorDatos(df, correlacion)
  tryCatch({
    graficar_matriz_correlacion(visualizador)
    print("Éxito: Prueba de graficar_matriz_correlacion")
  }, error = function(e) {
    print(paste("Fallo: Prueba de graficar_matriz_correlacion con error:", e$message))
  })
}

#' Prueba la generación de un histograma de entropía para variables categóricas.
#' @export
prueba_graficar_histograma_entropia <- function() {
  df <- DataFrame(list(
    categoria = c("A", "B", "A", "A", "C"),
    compra = c(1, 0, 1, 0, 1),
    color = c("rojo", "azul", "rojo", "verde", "azul")
  ))
  visualizador <- VisualizadorDatos(df)
  tryCatch({
    graficar_histograma_entropia(visualizador)
    print("Éxito: Prueba de graficar_histograma_entropia")
  }, error = function(e) {
    print(paste("Fallo: Prueba de graficar_histograma_entropia con error:", e$message))
  })
}

#' Prueba la generación de diagramas de caja para características continuas (edad, ingreso, puntaje).
#' @export
prueba_graficar_diagramas_caja_caracteristicas <- function() {
  df <- DataFrame(list(
    edad = c(23, 45, 31, 22, 35),
    ingreso = c(30000, 50000, 70000, 100000, 120000),
    puntaje = c(80, 90, 85, 88, 92)
  ))
  visualizador <- VisualizadorDatos(df)
  tryCatch({
    graficar_diagramas_caja_caracteristicas(visualizador)
    print("Éxito: Prueba de graficar_diagramas_caja_caracteristicas")
  }, error = function(e) {
    print(paste("Fallo: Prueba de graficar_diagramas_caja_caracteristicas con error:", e$message))
  })
}

# Ejecutar todas las pruebas
prueba_graficar_auc()
prueba_graficar_matriz_correlacion()
prueba_graficar_histograma_entropia()
prueba_graficar_diagramas_caja_caracteristicas()