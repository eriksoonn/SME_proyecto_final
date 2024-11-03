import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from filter import Filtro
from dataframe import DataFrame

def prueba_filtrar_por_entropia():
    # Verifica el filtro por entropía en todas las columnas y en columnas específicas.
    df = DataFrame({
        'edad': [25, 30, 35, 40, 45],
        'ingreso': [30000, 50000, 70000, 100000, 120000],
        'categoria': [1, 1, 2, 2, 3]
    })
    filtro_datos = Filtro(df)
    
    filtro_datos.filtrar_por_entropia(umbral=2.3)
    df_filtrado = filtro_datos.obtener_data_frame_filtrado()
    assert 'categoria' not in df_filtrado.datos, "Fallo: columna 'categoria' esperada en filtro de entropía"
    assert 'edad' in df_filtrado.datos, "Fallo: columna 'edad' inesperada en filtro de entropía"
    assert 'ingreso' in df_filtrado.datos, "Fallo: columna 'ingreso' inesperada en filtro de entropía"
    print("Éxito: Prueba de Filtro por Entropía (todas las columnas)")

    filtro_datos = Filtro(df)
    filtro_datos.filtrar_por_entropia(umbral=0.5, columnas=['categoria'])
    df_filtrado = filtro_datos.obtener_data_frame_filtrado()
    assert 'categoria' in df_filtrado.datos, "Fallo: columna 'categoria' esperada en filtro de entropía (columnas específicas)"
    assert 'edad' not in df_filtrado.datos, "Fallo: columna 'edad' inesperada en filtro de entropía (columnas específicas)"
    assert 'ingreso' not in df_filtrado.datos, "Fallo: columna 'ingreso' inesperada en filtro de entropía (columnas específicas)"
    print("Éxito: Prueba de Filtro por Entropía (columnas específicas)")

def prueba_filtrar_por_varianza():
    # Verifica el filtro por varianza en todas las columnas y en columnas específicas.
    df = DataFrame({
        'edad': [25, 25, 25, 25, 25],
        'ingreso': [30000, 50000, 70000, 100000, 120000],
        'categoria': [1, 2, 3, 4, 5]
    })
    filtro_datos = Filtro(df)
    
    filtro_datos.filtrar_por_varianza(umbral=1000)
    df_filtrado = filtro_datos.obtener_data_frame_filtrado()
    assert 'ingreso' in df_filtrado.datos, "Fallo: columna 'ingreso' esperada en filtro de varianza"
    assert 'edad' not in df_filtrado.datos, "Fallo: columna 'edad' inesperada en filtro de varianza"
    assert 'categoria' not in df_filtrado.datos, "Fallo: columna 'categoria' inesperada en filtro de varianza"
    print("Éxito: Prueba de Filtro por Varianza (todas las columnas)")

    filtro_datos = Filtro(df)
    filtro_datos.filtrar_por_varianza(umbral=1.5, columnas=['categoria'])
    df_filtrado = filtro_datos.obtener_data_frame_filtrado()
    assert 'ingreso' not in df_filtrado.datos, "Fallo: columna 'ingreso' inesperada en filtro de varianza (columnas específicas)"
    assert 'edad' not in df_filtrado.datos, "Fallo: columna 'edad' inesperada en filtro de varianza (columnas específicas)"
    assert 'categoria' in df_filtrado.datos, "Fallo: columna 'categoria' esperada en filtro de varianza (columnas específicas)"
    print("Éxito: Prueba de Filtro por Varianza (columnas específicas)")

def prueba_filtrar_por_auc():
    # Verifica el filtro por AUC en todas las columnas y en columnas específicas.
    df = DataFrame({
        'edad': [23, 45, 31, 22, 35],
        'ingreso': [30000, 50000, 70000, 100000, 120000],
        'compra': [1, 0, 1, 0, 1]
    })
    filtro_datos = Filtro(df)
    
    filtro_datos.filtrar_por_auc(umbral=0.4, nombre_columna_clase='compra')
    df_filtrado = filtro_datos.obtener_data_frame_filtrado()
    assert 'edad' in df_filtrado.datos, "Fallo: columna 'edad' esperada en filtro de AUC"
    assert 'ingreso' in df_filtrado.datos, "Fallo: columna 'ingreso' esperada en filtro de AUC"
    assert 'compra' not in df_filtrado.datos, "Fallo: columna 'compra' inesperada en filtro de AUC"
    print("Éxito: Prueba de Filtro por AUC (todas las columnas)")

    filtro_datos = Filtro(df)
    filtro_datos.filtrar_por_auc(umbral=0.4, nombre_columna_clase='compra', columnas=['edad'])
    df_filtrado = filtro_datos.obtener_data_frame_filtrado()
    assert 'edad' in df_filtrado.datos, "Fallo: columna 'edad' esperada en filtro de AUC (columnas específicas)"
    assert 'ingreso' not in df_filtrado.datos, "Fallo: columna 'ingreso' inesperada en filtro de AUC (columnas específicas)"
    assert 'compra' not in df_filtrado.datos, "Fallo: columna 'compra' inesperada en filtro de AUC (columnas específicas)"
    print("Éxito: Prueba de Filtro por AUC (columnas específicas)")

if __name__ == "__main__":
    prueba_filtrar_por_entropia()
    prueba_filtrar_por_varianza()
    prueba_filtrar_por_auc()


