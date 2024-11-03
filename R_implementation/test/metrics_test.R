source("dataframe.R")
source("metrics.R")

#' Verifica el cálculo de la varianza para una columna numérica.
prueba_varianza <- function() {
  columna <- c(1, 2, 3, 4, 5)
  resultado <- varianza(columna)
  esperado <- 2.0
  if (abs(resultado - esperado) < 1e-5) {
    print("Éxito: Prueba de Varianza")
  } else {
    print(paste("Fallo: Prueba de Varianza. Obtenido", resultado))
  }
}

#' Verifica el cálculo de la entropía para una columna categórica.
prueba_entropia <- function() {
  columna <- c(1, 1, 2, 2, 2, 3, 3)
  resultado <- entropia(columna)
  total <- length(columna)
  p1 <- 3 / total
  p2 <- 2 / total
  p3 <- 2 / total 
  esperado <- -(p1 * log2(p1) + p2 * log2(p2) + p3 * log2(p3)) 
  if (abs(resultado - esperado) < 1e-5) {
    print("Éxito: Prueba de Entropía")
  } else {
    print(paste("Fallo: Prueba de Entropía. Obtenido", resultado))
  }
}

#' Verifica el cálculo del AUC para una columna de valores y su correspondiente columna de clase.
prueba_auc <- function() {
  columna <- c(0.1, 0.4, 0.35, 0.8)
  columna_clase <- c(0, 1, 0, 1)
  resultado <- auc(columna, columna_clase)
  esperado <- 1.0
  if (abs(resultado - esperado) < 1e-5) {
    print("Éxito: Prueba de AUC")
  } else {
    print(paste("Fallo: Prueba de AUC. Obtenido", resultado))
  }
}

#' Verifica el cálculo de la métrica de varianza en una columna numérica usando un data.frame.
prueba_calcular_metrica_varianza <- function() {
  df <- DataFrame(list(edad = c(20, 25, 30, 35, 40)))
  resultado <- calcular_metrica(df, "edad")
  esperado <- list("Varianza" = 50.0)
  if (resultado$Varianza == esperado$Varianza) {
    print("Éxito: Prueba de Calcular Métrica Varianza")
  } else {
    print(paste("Fallo: Prueba de Calcular Métrica Varianza. Obtenido", resultado$Varianza))
  }
}

#' Verifica el cálculo de la métrica de entropía en una columna categórica usando un data.frame.
prueba_calcular_metrica_entropia <- function() {
  df <- DataFrame(list(compra = c(1, 1, 0, 0, 1)))
  resultado <- calcular_metrica(df, "compra")
  total <- length(obtener_columna(df, "compra"))
  p1 <- 3 / total
  p2 <- 2 / total
  esperado_entropia <- -(p1 * log2(p1) + p2 * log2(p2))
  esperado <- list("Entropía" = esperado_entropia)
  if (abs(resultado$Entropía - esperado$Entropía) < 1e-5) {
    print("Éxito: Prueba de Calcular Métrica Entropía")
  } else {
    print(paste("Fallo: Prueba de Calcular Métrica Entropía. Obtenido", resultado))
  }
}

#' Verifica el cálculo de la métrica de varianza y AUC en una columna numérica y su columna de clase asociada.
prueba_calcular_metrica_auc <- function() {
  df <- DataFrame(list(
    ingreso = c(30000, 40000, 50000, 60000),
    compra = c(0, 1, 0, 1)
  ))
  resultado <- calcular_metrica(df, "ingreso", "compra")
  esperado <- list("Varianza" = 125000000.0, "AUC" = 0.75)
  
  if (abs(resultado$Varianza - esperado$Varianza) < 1e-5) {
    print("Éxito: Prueba de Calcular Métrica Varianza")
  } else {
    print(paste("Fallo: Prueba de Calcular Métrica Varianza. Varianza obtenida", resultado$Varianza))
  }
  
  if (abs(resultado$AUC - esperado$AUC) < 1e-5) {
    print("Éxito: Prueba de Calcular Métrica AUC")
  } else {
    print(paste("Fallo: Prueba de Calcular Métrica AUC. AUC obtenida", resultado$AUC))
  }
}

#' Verifica el cálculo de la métrica de entropía categórica usando un data.frame.
prueba_calcular_metrica_entropia_categorica <- function() {
  df <- DataFrame(list(categoria = c('A', 'B', 'A', 'B', 'C')))
  resultado <- calcular_metrica(df, "categoria")
  
  total <- length(obtener_columna(df, "categoria"))
  pA <- 2 / total
  pB <- 2 / total
  pC <- 1 / total
  esperado <- list("Entropía" = -(pA * log2(pA) + pB * log2(pB) + pC * log2(pC)))
  
  if (abs(resultado$Entropía - esperado$Entropía) < 1e-5) {
    print("Éxito: Prueba de Calcular Métrica Entropía Categórica")
  } else {
    print(paste("Fallo: Prueba de Calcular Métrica Entropía Categórica. Obtenido", resultado))
  }
}

# Ejecuta todas las pruebas
prueba_varianza()
prueba_entropia()
prueba_auc()
prueba_calcular_metrica_varianza()
prueba_calcular_metrica_entropia()
prueba_calcular_metrica_auc()
prueba_calcular_metrica_entropia_categorica()
