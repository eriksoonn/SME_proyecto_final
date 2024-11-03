# Cargar los scripts necesarios
source("dataframe.R")
source("normalize.R")

#' Prueba de normalización min-max
prueba_normalizar_min_max <- function() {
  columna <- c(10, 20, 30, 40, 50)
  resultado <- normalizar_min_max(columna)
  esperado <- c(0.0, 0.25, 0.5, 0.75, 1.0)
  tolerancia <- 1e-5
  if (!all(abs(resultado - esperado) < tolerancia)) {
    stop(paste("Fallo: Prueba de Normalización Min-Max. Obtenido", toString(resultado)))
  }
  print("Éxito: Prueba de Normalización Min-Max")
}

#' Prueba de estandarización
prueba_estandarizar <- function() {
  columna <- c(10, 20, 30, 40, 50)
  resultado <- estandarizar(columna)
  esperado <- c(-1.41421, -0.70711, 0.0, 0.70711, 1.41421)
  tolerancia <- 1e-3
  if (!all(abs(resultado - esperado) < tolerancia)) {
    stop(paste("Fallo: Prueba de Estandarización. Obtenido", toString(resultado)))
  }
  print("Éxito: Prueba de Estandarización")
}

#' Prueba de normalización de DataFrame
prueba_normalizar_data_frame <- function() {
  df <- DataFrame(list(
    edad = c(25, 30, 35, 40, 45),
    ingreso = c(30000, 50000, 70000, 100000, 120000),
    categoria = c("A", "B", "A", "B", "C")
  ))
  df <- normalizar_data_frame(df)
  esperado_edad <- c(0.0, 0.25, 0.5, 0.75, 1.0)
  esperado_ingreso <- c(0.0, 0.22222, 0.44444, 0.77778, 1.0)
  tolerancia <- 1e-3
  edad_resultado <- obtener_columna(df, "edad")
  ingreso_resultado <- obtener_columna(df, "ingreso")
  categoria_resultado <- obtener_columna(df, "categoria")
  
  if (!all(abs(edad_resultado - esperado_edad) < tolerancia)) {
    stop(paste("Fallo: Prueba de normalización DataFrame 'edad'. Obtenido", toString(edad_resultado)))
  }
  if (!all(abs(ingreso_resultado - esperado_ingreso) < tolerancia)) {
    stop(paste("Fallo: Prueba de normalización DataFrame 'ingreso'. Obtenido", toString(ingreso_resultado)))
  }
  if (!identical(categoria_resultado, c("A", "B", "A", "B", "C"))) {
    stop(paste("Fallo: Prueba de normalización DataFrame 'categoria'. Obtenido", toString(categoria_resultado)))
  }
  print("Éxito: Prueba de Normalización de DataFrame")
}

#' Prueba de estandarización de DataFrame
prueba_estandarizar_data_frame <- function() {
  df <- DataFrame(list(
    edad = c(25, 30, 35, 40, 45),
    ingreso = c(30000, 50000, 70000, 100000, 120000),
    categoria = c("A", "B", "A", "B", "C")
  ))
  df <- estandarizar_data_frame(df)
  esperado_edad <- c(-1.41421, -0.70711, 0.0, 0.70711, 1.41421)
  esperado_ingreso <- c(-1.34890, -0.73576, -0.12262, 0.79708, 1.41022)
  tolerancia <- 1e-3
  edad_resultado <- obtener_columna(df, "edad")
  ingreso_resultado <- obtener_columna(df, "ingreso")
  categoria_resultado <- obtener_columna(df, "categoria")
  
  if (!all(abs(edad_resultado - esperado_edad) < tolerancia)) {
    stop(paste("Fallo: Prueba de estandarización DataFrame 'edad'. Obtenido", toString(edad_resultado)))
  }
  if (!all(abs(ingreso_resultado - esperado_ingreso) < tolerancia)) {
    stop(paste("Fallo: Prueba de estandarización DataFrame 'ingreso'. Obtenido", toString(ingreso_resultado)))
  }
  if (!identical(categoria_resultado, c("A", "B", "A", "B", "C"))) {
    stop(paste("Fallo: Prueba de estandarización DataFrame 'categoria'. Obtenido", toString(categoria_resultado)))
  }
  print("Éxito: Prueba de Estandarización de DataFrame")
}

#' Prueba de es_columna_numerica
prueba_es_columna_numerica <- function() {
  columna_numerica <- c(1, 2, 3, 4, 5)
  columna_no_numerica <- c(1, "dos", 3, 4, 5)
  
  if (!es_columna_numerica(columna_numerica)) {
    stop("Fallo: Verificación de columna numérica")
  }
  if (es_columna_numerica(columna_no_numerica)) {
    stop("Fallo: Verificación de columna no numérica")
  }
  print("Éxito: Prueba de es_columna_numerica")
}

#' Ejecutar todas las pruebas
ejecutar_pruebas <- function() {
  prueba_normalizar_min_max()
  prueba_estandarizar()
  prueba_normalizar_data_frame()
  prueba_estandarizar_data_frame()
  prueba_es_columna_numerica()
}

# Ejecutar todas las pruebas si es el script principal
if (sys.nframe() == 0) {
  ejecutar_pruebas()
}
