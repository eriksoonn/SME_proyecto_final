source("dataframe.R")
source("correlation.R")

prueba_correlacion_pearson <- function() {
  df <- DataFrame(list(
    x = c(1, 2, 3, 4, 5),
    y = c(2, 4, 6, 8, 10)
  ))
  calculadora_correlacion <- Correlacion(df)
  correlaciones <- calcular_correlacion_por_pares(calculadora_correlacion)
  correlacion_esperada <- 1.0
  resultado <- correlaciones[["x_y"]]
  if (abs(resultado - correlacion_esperada) < 1e-5) {
    print("Éxito: Prueba de Correlación de Pearson")
  } else {
    stop(paste("Fallo: Prueba de correlación de Pearson. Obtenido", resultado))
  }
}

prueba_correlacion_cero <- function() {
  df <- DataFrame(list(
    x = c(1, 2, 3, 4, 5),
    y = c(5, 4, 3, 2, 1)
  ))
  calculadora_correlacion <- Correlacion(df)
  correlaciones <- calcular_correlacion_por_pares(calculadora_correlacion)
  correlacion_esperada <- -1.0
  resultado <- correlaciones[["x_y"]]
  if (abs(resultado - correlacion_esperada) < 1e-5) {
    print("Éxito: Prueba de Correlación Cero")
  } else {
    stop(paste("Fallo: Prueba de correlación cero. Obtenido", resultado))
  }
}

prueba_informacion_mutua <- function() {
  df <- DataFrame(list(
    a = c("gato", "perro", "perro", "pájaro", "pájaro"),
    b = c("manzana", "banana", "banana", "cereza", "cereza")
  ))
  calculadora_correlacion <- Correlacion(df)
  correlaciones <- calcular_correlacion_por_pares(calculadora_correlacion)
  info_mutua_esperada <- 1.5219280948873621
  resultado <- correlaciones[["a_b"]]
  if (abs(resultado - info_mutua_esperada) < 1e-5) {
    print("Éxito: Prueba de Información Mutua")
  } else {
    stop(paste("Fallo: Prueba de información mutua. Obtenido", resultado))
  }
}

prueba_correlacion_mixta <- function() {
  df <- DataFrame(list(
    num = c(10, 20, 30, 40, 50),
    cat = c(1, 1, 2, 2, 3),
    otro_num = c(15, 25, 35, 45, 55)
  ))
  calculadora_correlacion <- Correlacion(df)
  correlaciones <- calcular_correlacion_por_pares(calculadora_correlacion)
  
  correlacion_pearson_esperada <- 1.0
  resultado_pearson <- correlaciones[["num_otro_num"]]
  if (abs(resultado_pearson - correlacion_pearson_esperada) < 1e-5) {
    print("Éxito: Prueba de Correlación Mixta (Pearson)")
  } else {
    stop(paste("Fallo: Prueba de correlación mixta (Pearson). Obtenido", resultado_pearson))
  }
  
  resultado_mutua <- correlaciones[["num_cat"]]
  if (is.numeric(resultado_mutua) && resultado_mutua >= 0) {
    print("Éxito: Prueba de Correlación Mixta (Información Mutua)")
  } else {
    stop(paste("Fallo: Prueba de correlación mixta (Información Mutua). Obtenido", resultado_mutua))
  }
}

prueba_correlacion_pearson()
prueba_correlacion_cero()
prueba_informacion_mutua()
prueba_correlacion_mixta()
