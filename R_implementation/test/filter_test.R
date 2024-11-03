source("dataframe.R")
source("filter.R")

prueba_filtrar_por_entropia <- function() {
  df <- DataFrame(list(
    'edad' = c(25, 30, 35, 40, 45),
    'ingreso' = c(30000, 50000, 70000, 100000, 120000),
    'categoria' = c(1, 1, 2, 2, 3)
  ))
  filtro_datos <- Filtro(df)
  
  filtrar_por_entropia(filtro_datos, umbral = 2.3)
  df_filtrado <- obtener_data_frame_filtrado(filtro_datos)
  if ('categoria' %in% names(df_filtrado$datos)) {
    print("Fallo: columna 'categoria' esperada en filtro de entropía")
  } else if (!('edad' %in% names(df_filtrado$datos))) {
    print("Fallo: columna 'edad' inesperada en filtro de entropía")
  } else if (!('ingreso' %in% names(df_filtrado$datos))) {
    print("Fallo: columna 'ingreso' inesperada en filtro de entropía")
  } else {
    print("Éxito: Prueba de Filtro por Entropía (todas las columnas)")
  }
  
  filtro_datos <- Filtro(df)
  filtrar_por_entropia(filtro_datos, umbral = 0.5, columnas = list('categoria'))
  df_filtrado <- obtener_data_frame_filtrado(filtro_datos)
  if (!('categoria' %in% names(df_filtrado$datos))) {
    print("Fallo: columna 'categoria' esperada en filtro de entropía (columnas específicas)")
  } else if ('edad' %in% names(df_filtrado$datos)) {
    print("Fallo: columna 'edad' inesperada en filtro de entropía (columnas específicas)")
  } else if ('ingreso' %in% names(df_filtrado$datos)) {
    print("Fallo: columna 'ingreso' inesperada en filtro de entropía (columnas específicas)")
  } else {
    print("Éxito: Prueba de Filtro por Entropía (columnas específicas)")
  }
}

prueba_filtrar_por_varianza <- function() {
  df <- DataFrame(list(
    'edad' = rep(25, 5),
    'ingreso' = c(30000, 50000, 70000, 100000, 120000),
    'categoria' = 1:5
  ))
  filtro_datos <- Filtro(df)
  
  filtrar_por_varianza(filtro_datos, umbral = 1000)
  df_filtrado <- obtener_data_frame_filtrado(filtro_datos)
  if ('ingreso' %in% names(df_filtrado$datos)) {
    print("Éxito: Prueba de Filtro por Varianza (todas las columnas)")
  } else if ('edad' %in% names(df_filtrado$datos)) {
    print("Fallo: columna 'edad' inesperada en filtro de varianza")
  } else if ('categoria' %in% names(df_filtrado$datos)) {
    print("Fallo: columna 'categoria' inesperada en filtro de varianza")
  } else {
    print("Fallo: columna 'ingreso' esperada en filtro de varianza")
  }
  
  filtro_datos <- Filtro(df)
  filtrar_por_varianza(filtro_datos, umbral = 1.5, columnas = list('categoria'))
  df_filtrado <- obtener_data_frame_filtrado(filtro_datos)
  if ('categoria' %in% names(df_filtrado$datos)) {
    print("Éxito: Prueba de Filtro por Varianza (columnas específicas)")
  } else if ('ingreso' %in% names(df_filtrado$datos)) {
    print("Fallo: columna 'ingreso' inesperada en filtro de varianza (columnas específicas)")
  } else if ('edad' %in% names(df_filtrado$datos)) {
    print("Fallo: columna 'edad' inesperada en filtro de varianza (columnas específicas)")
  } else {
    print("Fallo: columna 'categoria' esperada en filtro de varianza (columnas específicas)")
  }
}

prueba_filtrar_por_auc <- function() {
  df <- DataFrame(list(
    'edad' = c(23, 45, 31, 22, 35),
    'ingreso' = c(30000, 50000, 70000, 100000, 120000),
    'compra' = c(1, 0, 1, 0, 1)
  ))
  filtro_datos <- Filtro(df)
  
  filtrar_por_auc(filtro_datos, umbral = 0.4, nombre_columna_clase = 'compra')
  df_filtrado <- obtener_data_frame_filtrado(filtro_datos)
  if ('edad' %in% names(df_filtrado$datos) && 'ingreso' %in% names(df_filtrado$datos)) {
    print("Éxito: Prueba de Filtro por AUC (todas las columnas)")
  } else if ('compra' %in% names(df_filtrado$datos)) {
    print("Fallo: columna 'compra' inesperada en filtro de AUC")
  } else {
    print("Fallo: columnas 'edad' y 'ingreso' esperadas en filtro de AUC")
  }
  
  filtro_datos <- Filtro(df)
  filtrar_por_auc(filtro_datos, umbral = 0.4, nombre_columna_clase = 'compra', columnas = list('edad'))
  df_filtrado <- obtener_data_frame_filtrado(filtro_datos)
  if ('edad' %in% names(df_filtrado$datos)) {
    print("Éxito: Prueba de Filtro por AUC (columnas específicas)")
  } else if ('ingreso' %in% names(df_filtrado$datos)) {
    print("Fallo: columna 'ingreso' inesperada en filtro de AUC (columnas específicas)")
  } else if ('compra' %in% names(df_filtrado$datos)) {
    print("Fallo: columna 'compra' inesperada en filtro de AUC (columnas específicas)")
  } else {
    print("Fallo: columna 'edad' esperada en filtro de AUC (columnas específicas)")
  }
}

prueba_filtrar_por_entropia()
prueba_filtrar_por_varianza()
prueba_filtrar_por_auc()
