#' Clase para manipular un data.frame personalizado con métodos para añadir y acceder columnas,
#' validar si está vacío, y exportar o importar datos en formatos CSV y TXT.
#'
#' @docType class
#' @name DataFrame
#' @export
DataFrame <- function(datos) {
  structure(list(datos = datos), class = "DataFrame")
}

#' Método para añadir una columna al data.frame.
#'
#' @param object Instancia del data.frame personalizado.
#' @param nombre_columna Nombre de la nueva columna.
#' @param valores Lista de valores para la columna.
#' @return El data.frame actualizado.
#' @examples
#' df <- DataFrame(list(col1 = c(1, 2, 3)))
#' df <- agregar_columna(df, "nueva_columna", c(4, 5, 6))
agregar_columna <- function(object, nombre_columna, valores) {
  if (nombre_columna %in% names(object$datos)) {
    stop(sprintf("La columna '%s' ya existe.", nombre_columna))
  }
  object$datos[[nombre_columna]] <- valores
  return(object)
}

#' Método para obtener los valores de una columna específica.
#'
#' @param object Instancia del data.frame personalizado.
#' @param nombre_columna Nombre de la columna a obtener.
#' @return Lista de valores de la columna solicitada.
#' @examples
#' obtener_columna(df, "col1")
obtener_columna <- function(object, nombre_columna) {
  if (!(nombre_columna %in% names(object$datos))) {
    stop(sprintf("La columna '%s' no existe.", nombre_columna))
  }
  return(object$datos[[nombre_columna]])
}

#' Método para verificar si el data.frame está vacío.
#'
#' @param object Instancia del data.frame personalizado.
#' @return TRUE si no hay datos o todas las columnas están vacías, FALSE en caso contrario.
#' @examples
#' esta_vacio(df)
esta_vacio <- function(object) {
  return(length(object$datos) == 0 || all(sapply(object$datos, function(valores) length(valores) == 0)))
}

#' Método para escribir el data.frame en un archivo CSV.
#'
#' @param object Instancia del data.frame personalizado.
#' @param ruta_archivo Ruta donde se guardará el archivo CSV.
#' @return None
#' @examples
#' escribir_a_csv(df, "datos.csv")
escribir_a_csv <- function(object, ruta_archivo) {
  datos_df <- as.data.frame(object$datos)
  write.csv(datos_df, ruta_archivo, row.names = FALSE)
}

#' Método para escribir el data.frame en un archivo TXT con valores separados por tabulaciones.
#'
#' @param object Instancia del data.frame personalizado.
#' @param ruta_archivo Ruta donde se guardará el archivo TXT.
#' @return None
#' @examples
#' escribir_a_txt(df, "datos.txt")
escribir_a_txt <- function(object, ruta_archivo) {
  datos_df <- as.data.frame(object$datos)
  write.table(datos_df, ruta_archivo, sep = "\t", row.names = FALSE, quote = FALSE)
}

#' Método para representar el data.frame como una cadena de texto.
#'
#' @param object Instancia del data.frame personalizado.
#' @return Cadena de texto que representa el data.frame.
#' @examples
#' print(df)
print.DataFrame <- function(object) {
  datos_df <- as.data.frame(object$datos)
  print(datos_df)
}

#' Método de clase para leer un archivo CSV y crear un data.frame personalizado.
#'
#' @param ruta_archivo Ruta del archivo CSV a leer.
#' @return Nueva instancia de la clase con datos cargados desde el CSV.
#' @examples
#' df <- leer_desde_csv("datos.csv")
leer_desde_csv <- function(ruta_archivo) {
  lineas <- readLines(ruta_archivo)
  encabezados <- strsplit(lineas[1], ",")[[1]]
  datos <- setNames(vector("list", length(encabezados)), encabezados)
  for (linea in lineas[-1]) {
    valores <- strsplit(linea, ",")[[1]]
    for (i in seq_along(encabezados)) {
      datos[[encabezados[i]]] <- c(datos[[encabezados[i]]], .convertir_tipo(valores[i]))
    }
  }
  DataFrame(datos)
}


#' Método de clase para leer un archivo TXT con valores separados por tabulaciones y crear un data.frame personalizado.
#'
#' @param ruta_archivo Ruta del archivo TXT a leer.
#' @return Nueva instancia de la clase con datos cargados desde el TXT.
#' @examples
#' df <- leer_desde_txt("datos.txt")
leer_desde_txt <- function(ruta_archivo) {
  lineas <- readLines(ruta_archivo)
  encabezados <- strsplit(lineas[1], "\t")[[1]]
  datos <- setNames(vector("list", length(encabezados)), encabezados)
  for (linea in lineas[-1]) {
    valores <- strsplit(linea, "\t")[[1]]
    for (i in seq_along(encabezados)) {
      datos[[encabezados[i]]] <- c(datos[[encabezados[i]]], .convertir_tipo(valores[i]))
    }
  }
  DataFrame(datos)
}

#' Método estático para convertir un valor en el tipo de dato adecuado (int, float o str).
#'
#' @param valor Valor a convertir.
#' @return Valor convertido al tipo de dato adecuado.
.convertir_tipo <- function(valor) {
  num_val <- suppressWarnings(as.numeric(valor))
  if (!is.na(num_val)) {
    if (num_val == as.integer(num_val)) {
      return(as.integer(num_val))
    } else {
      return(num_val)
    }
  } else {
    return(valor)
  }
}