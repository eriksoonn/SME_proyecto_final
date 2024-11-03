source("dataframe.R")
source("discretize.R")

#' Prueba para el Discretizador con método de ancho igual
#'
#' Verifica que la discretización por ancho igual funcione correctamente.
test_discretizador_ancho_igual <- function() {
  columna <- c(1, 2, 3, 4, 5)
  intervalos <- 2
  discretizador <- Discretizador()
  resultado <- ancho_igual(discretizador, columna, intervalos)
  esperado <- c(0, 0, 0, 1, 1)
  if (!all(resultado == esperado)) {
    print(paste("Falló: Prueba de ancho igual. Obtuvo", toString(resultado)))
  } else {
    print("Aprobado: Prueba de Discretizador Ancho Igual")
  }
}

#' Prueba para el Discretizador con método de frecuencia igual
#'
#' Verifica que la discretización por frecuencia igual funcione correctamente.
test_discretizador_frecuencia_igual <- function() {
  columna <- c(1, 2, 3, 4, 5)
  intervalos <- 2
  discretizador <- Discretizador()
  resultado <- frecuencia_igual(discretizador, columna, intervalos)
  esperado <- c(0, 0, 1, 1, 1)
  if (!all(resultado == esperado)) {
    print(paste("Falló: Prueba de frecuencia igual. Obtuvo", toString(resultado)))
  } else {
    print("Aprobado: Prueba de Discretizador Frecuencia Igual")
  }
}

#' Prueba para el Discretizador con método de k-means
#'
#' Verifica que la discretización usando k-means funcione correctamente.
test_discretizador_k_means <- function() {
  columna <- c(10, 20, 20, 30, 40, 40, 50, 60)
  intervalos <- 3
  discretizador <- Discretizador()
  resultado <- k_means(discretizador, columna, intervalos)
  esperado <- c(0, 0, 0, 1, 1, 1, 2, 2)
  if (!all(resultado == esperado)) {
    print(paste("Falló: Prueba de k-means. Obtuvo", toString(resultado)))
  } else {
    print("Aprobado: Prueba de Discretizador K-means")
  }
}

#' Prueba para el Discretizador con método basado en cuantiles
#'
#' Verifica que la discretización basada en cuantiles funcione correctamente.
test_discretizador_basado_en_cuantiles <- function() {
  columna <- c(5, 15, 25, 35, 45, 55, 65, 75, 85)
  intervalos <- 3
  discretizador <- Discretizador()
  resultado <- basado_en_cuantiles(discretizador, columna, intervalos)
  esperado <- c(0, 0, 0, 1, 1, 1, 2, 2, 2)
  if (!all(resultado == esperado)) {
    print(paste("Falló: Prueba basada en cuantiles. Obtuvo", toString(resultado)))
  } else {
    print("Aprobado: Prueba de Discretizador Basado en Cuantiles")
  }
}

#' Prueba para discretizar una columna usando el método de k-means
#'
#' Verifica que la función discretizar_columna con k-means funcione correctamente.
test_discretizador_discretizar_columna_k_means <- function() {
  df <- DataFrame(list(col = c(10, 20, 20, 30, 40, 40, 50, 60)))
  discretizador <- Discretizador()
  df <- discretizar_columna(discretizador, df, "col", metodo = "k_means", bins = 3)
  resultado <- obtener_columna(df, "col")
  esperado <- c(0, 0, 0, 1, 1, 1, 2, 2)
  if (!all(resultado == esperado)) {
    print(paste("Falló: Prueba de discretizar columna con k-means. Obtuvo", toString(resultado)))
  } else {
    print("Aprobado: Prueba de Discretizador Discretizar Columna K-means")
  }
}

#' Prueba para discretizar una columna usando el método basado en cuantiles
#'
#' Verifica que la función discretizar_columna con cuantiles funcione correctamente.
test_discretizador_discretizar_columna_basado_en_cuantiles <- function() {
  df <- DataFrame(list(col = c(5, 15, 25, 35, 45, 55, 65, 75, 85)))
  discretizador <- Discretizador()
  df <- discretizar_columna(discretizador, df, "col", metodo = "basado_en_cuantiles", bins = 3)
  resultado <- obtener_columna(df, "col")
  esperado <- c(0, 0, 0, 1, 1, 1, 2, 2, 2)
  if (!all(resultado == esperado)) {
    print(paste("Falló: Prueba de discretizar columna basado en cuantiles. Obtuvo", toString(resultado)))
  } else {
    print("Aprobado: Prueba de Discretizador Discretizar Columna Basado en Cuantiles")
  }
}

#' Prueba para obtener los rangos de bins usando k-means
#'
#' Verifica que la función obtener_rangos_bins con k-means funcione correctamente.
test_discretizador_obtener_rangos_bins_k_means <- function() {
  columna <- c(10, 20, 20, 30, 40, 40, 50, 60)
  intervalos <- 3
  discretizador <- Discretizador()
  k_means(discretizador, columna, intervalos)
  resultado <- obtener_rangos_bins(discretizador, metodo = "k_means")
  rangos_esperados <- list(
    c(-Inf, round(26.66666667, 8)),
    c(round(26.66666667, 8), round(45.83333333, 8)),
    c(round(45.83333333, 8), Inf)
  )
  resultado_redondeado <- lapply(resultado, function(rango) c(round(rango[1], 8), round(rango[2], 8)))
  if (!all(mapply(function(r, e) all(r == e), resultado_redondeado, rangos_esperados))) {
    print(paste("Falló: Obtener rangos de bins para k-means. Esperado", toString(rangos_esperados), ", obtuvo", toString(resultado_redondeado)))
  } else {
    print("Aprobado: Prueba de Discretizador Obtener Rangos de Bins K-means")
  }
}

#' Prueba para obtener los rangos de bins usando cuantiles
#'
#' Verifica que la función obtener_rangos_bins con cuantiles funcione correctamente.
test_discretizador_obtener_rangos_bins_basado_en_cuantiles <- function() {
  columna <- c(5, 15, 25, 35, 45, 55, 65, 75, 85)
  intervalos <- 3
  discretizador <- Discretizador()
  basado_en_cuantiles(discretizador, columna, intervalos)
  resultado <- obtener_rangos_bins(discretizador, metodo = "basado_en_cuantiles")
  rangos_esperados <- list(
    c(-Inf, 30.0),
    c(30.0, 60.0),
    c(60.0, Inf)
  )
  for (i in seq_along(resultado)) {
    inferior_resultado <- resultado[[i]][1]
    superior_resultado <- resultado[[i]][2]
    inferior_esperado <- rangos_esperados[[i]][1]
    superior_esperado <- rangos_esperados[[i]][2]
    if (is.infinite(inferior_resultado) && is.infinite(inferior_esperado)) {
      verificacion_inferior <- TRUE
    } else {
      verificacion_inferior <- abs(inferior_resultado - inferior_esperado) < 1e-10
    }
    if (is.infinite(superior_resultado) && is.infinite(superior_esperado)) {
      verificacion_superior <- TRUE
    } else {
      verificacion_superior <- abs(superior_resultado - superior_esperado) < 1e-10
    }
    if (!(verificacion_inferior && verificacion_superior)) {
      print(paste("Falló: Obtener rangos de bins para basado en cuantiles. Esperado", toString(rangos_esperados[[i]]), ", obtuvo", toString(resultado[[i]])))
      return()
    }
  }
  print("Aprobado: Prueba de Discretizador Obtener Rangos de Bins Basado en Cuantiles")
}

#' Ejecuta todas las pruebas del Discretizador
#'
#' Corre todas las funciones de prueba para verificar el correcto funcionamiento del Discretizador.
ejecutar_todas_las_pruebas <- function() {
  test_discretizador_ancho_igual()
  test_discretizador_frecuencia_igual()
  test_discretizador_k_means()
  test_discretizador_basado_en_cuantiles()
  test_discretizador_discretizar_columna_k_means()
  test_discretizador_discretizar_columna_basado_en_cuantiles()
  test_discretizador_obtener_rangos_bins_k_means()
  test_discretizador_obtener_rangos_bins_basado_en_cuantiles()
}

# Ejecutar todas las pruebas
ejecutar_todas_las_pruebas()
