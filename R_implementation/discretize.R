# Define Discretizador as an environment-based S3 class
Discretizador <- function() {
  e <- new.env()
  e$puntos_corte <- list()
  class(e) <- "Discretizador"
  return(e)
}

#' Método para discretizar una columna en intervalos de ancho igual.
#'
#' @param discretizador (Discretizador) Objeto de la clase Discretizador.
#' @param columna (numeric) Lista de valores numéricos a discretizar.
#' @param bins (int) Número de intervalos (bins).
#' @return (numeric) Lista de valores discretizados en función del intervalo correspondiente.
ancho_igual <- function(discretizador, columna, bins) {
  min_valor <- min(columna)
  max_valor <- max(columna)
  rango <- max_valor - min_valor + 1e-10
  ancho <- rango / bins
  puntos_corte <- min_valor + seq_len(bins - 1) * ancho
  discretizador$puntos_corte[["ancho_igual"]] <- puntos_corte
  discretizado <- sapply(columna, function(valor) {
    min(bins - 1, floor((valor - min_valor) / rango * bins))
  })
  return(discretizado)
}

#' Método para discretizar una columna en intervalos de frecuencia igual.
#'
#' @param discretizador (Discretizador) Objeto de la clase Discretizador.
#' @param columna (numeric) Lista de valores numéricos a discretizar.
#' @param bins (int) Número de intervalos (bins).
#' @return (numeric) Lista de valores discretizados en función del intervalo correspondiente.
frecuencia_igual <- function(discretizador, columna, bins) {
  valores_ordenados <- sort(columna)
  n <- length(columna)
  tamano_bin <- n %/% bins
  puntos_corte <- valores_ordenados[(1:(bins - 1)) * tamano_bin]
  discretizador$puntos_corte[["frecuencia_igual"]] <- puntos_corte
  discretizado <- numeric(n)
  for (indice_bin in 0:(bins - 1)) {
    inicio <- indice_bin * tamano_bin + 1
    fin <- if (indice_bin < bins - 1) inicio + tamano_bin - 1 else n
    indices <- match(valores_ordenados[inicio:fin], columna)
    discretizado[indices] <- indice_bin
  }
  return(discretizado)
}

#' Método para discretizar una columna usando el algoritmo de k-means.
#'
#' @param discretizador (Discretizador) Objeto de la clase Discretizador.
#' @param columna (numeric) Lista de valores numéricos a discretizar.
#' @param bins (int) Número de intervalos (bins).
#' @return (numeric) Lista de valores discretizados en función del intervalo correspondiente.
k_means <- function(discretizador, columna, bins) {
  min_valor <- min(columna)
  max_valor <- max(columna)
  centroides <- min_valor + ((0:(bins - 1)) + 0.5) * (max_valor - min_valor) / bins
  centroides_previos <- rep(NA, bins)
  
  while (!all(centroides == centroides_previos, na.rm = TRUE)) {
    clusters <- vector("list", bins)
    for (valor in columna) {
      distancias <- abs(valor - centroides)
      indice_mas_cercano <- which.min(distancias)
      clusters[[indice_mas_cercano]] <- c(clusters[[indice_mas_cercano]], valor)
    }
    centroides_previos <- centroides
    centroides <- sapply(seq_len(bins), function(i) {
      if (length(clusters[[i]]) > 0) {
        mean(clusters[[i]])
      } else {
        centroides[i]
      }
    })
  }
  
  puntos_corte <- (centroides[-bins] + centroides[-1]) / 2
  discretizador$puntos_corte[["k_means"]] <- round(puntos_corte, 8)
  discretizado <- sapply(columna, function(valor) {
    idx <- which(valor < puntos_corte)[1]
    if (is.na(idx)) bins - 1 else idx - 1
  })
  return(discretizado)
}

#' Método para discretizar una columna basada en cuantiles.
#'
#' @param discretizador (Discretizador) Objeto de la clase Discretizador.
#' @param columna (numeric) Lista de valores numéricos a discretizar.
#' @param bins (int) Número de intervalos (bins).
#' @return (numeric) Lista de valores discretizados en función del intervalo correspondiente.
basado_en_cuantiles <- function(discretizador, columna, bins) {
  probabilidades <- seq(0, 1, length.out = bins + 1)
  bordes_bin <- quantile(columna, probs = probabilidades)
  puntos_corte <- bordes_bin[-c(1, bins + 1)]
  discretizador$puntos_corte[["basado_en_cuantiles"]] <- round(puntos_corte, 8)
  
  discretizado <- cut(columna, breaks = bordes_bin, labels = FALSE, include.lowest = TRUE) - 1
  return(discretizado)
}

#' Método para discretizar una columna de un data.frame usando un método específico.
#'
#' @param discretizador (Discretizador) Objeto de la clase Discretizador.
#' @param df (data.frame) DataFrame con la columna a discretizar.
#' @param nombre_columna (str) Nombre de la columna a discretizar.
#' @param metodo (str) Método de discretización ('ancho_igual', 'frecuencia_igual', 'k_means', 'basado_en_cuantiles').
#' @param bins (int) Número de intervalos (bins).
#' @return (data.frame) El data.frame con la columna discretizada.
discretizar_columna <- function(discretizador, df, nombre_columna, metodo = "ancho_igual", bins = 3) {
  columna <- obtener_columna(df, nombre_columna)
  if (metodo == "ancho_igual") {
    discretizado <- ancho_igual(discretizador, columna, bins)
  } else if (metodo == "frecuencia_igual") {
    discretizado <- frecuencia_igual(discretizador, columna, bins)
  } else if (metodo == "k_means") {
    discretizado <- k_means(discretizador, columna, bins)
  } else if (metodo == "basado_en_cuantiles") {
    discretizado <- basado_en_cuantiles(discretizador, columna, bins)
  } else {
    stop("Método de discretización no válido. Use 'ancho_igual', 'frecuencia_igual', 'k_means', o 'basado_en_cuantiles'.")
  }
  
  df$datos[[nombre_columna]] <- discretizado
  return(df)
}

#' Método para obtener los rangos de cada bin en función del método de discretización usado.
#'
#' @param discretizador (Discretizador) Objeto de la clase Discretizador.
#' @param metodo (str) Método de discretización para el cual obtener los rangos de bins.
#' @param decimales (int) Número de decimales para redondear los puntos de corte.
#' @return (list) Lista de tuplas que representan los rangos de cada bin.
#' @examples
#' # Ejemplo de uso
#' discretizador <- Discretizador()
#' columna <- c(1, 2, 3, 4, 5)
#' discretizado <- ancho_igual(discretizador, columna, bins = 3)
#' rangos <- obtener_rangos_bins(discretizador, metodo = "ancho_igual")
obtener_rangos_bins <- function(discretizador, metodo = "ancho_igual", decimales = 8) {
  if (!(metodo %in% names(discretizador$puntos_corte))) {
    stop("No existen puntos de corte para el método especificado.")
  }
  puntos_corte <- discretizador$puntos_corte[[metodo]]
  rangos_bins <- list()
  corte_previo <- -Inf
  for (corte in puntos_corte) {
    rangos_bins <- append(rangos_bins, list(c(corte_previo, round(corte, decimales))))
    corte_previo <- round(corte, decimales)
  }
  rangos_bins <- append(rangos_bins, list(c(corte_previo, Inf)))
  return(rangos_bins)
}
