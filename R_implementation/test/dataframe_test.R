source("dataframe.R")

prueba_inicializacion_data_frame_personalizado <- function() {
  df <- DataFrame(list(col1 = c(1, 2, 3), col2 = c(4, 5, 6)))
  if (!all(obtener_columna(df, "col1") == c(1, 2, 3))) {
    print("Fallo: Prueba de inicialización en col1")
  } else if (!all(obtener_columna(df, "col2") == c(4, 5, 6))) {
    print("Fallo: Prueba de inicialización en col2")
  } else {
    print("Exito: Prueba de Inicialización de DataFrame")
  }
}

prueba_agregar_columna_data_frame_personalizado <- function() {
  df <- DataFrame(list(col1 = c(1, 2, 3)))
  df <- agregar_columna(df, "col2", c(4, 5, 6))
  if (!all(obtener_columna(df, "col2") == c(4, 5, 6))) {
    print("Fallo: Prueba de agregar columna")
  } else {
    tryCatch({
      df <- agregar_columna(df, "col1", c(7, 8, 9))
      print("Fallo: Prueba de agregar columna existente (no se lanzó excepción)")
    }, error = function(e) {
      print("Exito: Prueba de Agregar Columna en DataFrame")
    })
  }
}

prueba_esta_vacio_data_frame_personalizado <- function() {
  df_vacio <- DataFrame(list())
  df_no_vacio <- DataFrame(list(col1 = numeric(0)))
  df_llenado <- DataFrame(list(col1 = c(1)))
  if (!esta_vacio(df_vacio)) {
    print("Fallo: Verificación de DataFrame vacío")
  } else if (!esta_vacio(df_no_vacio)) {
    print("Fallo: Estructura no vacía pero columna vacía")
  } else if (esta_vacio(df_llenado)) {
    print("Fallo: Verificación de DataFrame no vacío")
  } else {
    print("Exito: Prueba de esta_vacio en DataFrame")
  }
}

prueba_escribir_y_leer_csv_data_frame_personalizado <- function() {
  df <- DataFrame(list(
    col1 = c(1, 2, 3),
    col2 = c(4.5, 5.5, 6.5),
    col3 = c("a", "b", "c")
  ))
  ruta_archivo <- 'prueba.csv'
  escribir_a_csv(df, ruta_archivo)
  df_cargado <- leer_desde_csv(ruta_archivo)
  if (!all(obtener_columna(df_cargado, "col1") == c(1, 2, 3))) {
    print("Fallo: Lectura CSV en col1")
  } else if (!all(obtener_columna(df_cargado, "col2") == c(4.5, 5.5, 6.5))) {
    print("Fallo: Lectura CSV en col2")
  } else if (!all(obtener_columna(df_cargado, "col3") == c("a", "b", "c"))) {
    print("Fallo: Lectura CSV en col3")
  } else {
    print("Exito: Prueba de Escritura y Lectura CSV en DataFrame")
  }
  file.remove(ruta_archivo)
}

prueba_escribir_y_leer_txt_data_frame_personalizado <- function() {
  df <- DataFrame(list(
    col1 = c(10, 20, 30),
    col2 = c(40.1, 50.2, 60.3),
    col3 = c("x", "y", "z")
  ))
  ruta_archivo <- 'prueba.txt'
  escribir_a_txt(df, ruta_archivo)
  df_cargado <- leer_desde_txt(ruta_archivo)
  if (!all(obtener_columna(df_cargado, "col1") == c(10, 20, 30))) {
    print("Fallo: Lectura TXT en col1")
  } else if (!all(obtener_columna(df_cargado, "col2") == c(40.1, 50.2, 60.3))) {
    print("Fallo: Lectura TXT en col2")
  } else if (!all(obtener_columna(df_cargado, "col3") == c("x", "y", "z"))) {
    print("Fallo: Lectura TXT en col3")
  } else {
    print("Exito: Prueba de Escritura y Lectura TXT en DataFrame")
  }
  file.remove(ruta_archivo)
}

# Ejecutar las pruebas
prueba_inicializacion_data_frame_personalizado()
prueba_agregar_columna_data_frame_personalizado()
prueba_esta_vacio_data_frame_personalizado()
#prueba_escribir_y_leer_csv_data_frame_personalizado()
prueba_escribir_y_leer_txt_data_frame_personalizado()
