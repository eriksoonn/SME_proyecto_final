import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from dataframe import DataFrame

def prueba_inicializacion_data_frame_personalizado():
    # Verifica la correcta inicialización del DataFramePersonalizado y que las columnas contengan los valores esperados.
    df = DataFrame({'col1': [1, 2, 3], 'col2': [4, 5, 6]})
    assert df.obtener_columna('col1') == [1, 2, 3], "Fallo: Prueba de inicialización en col1"
    assert df.obtener_columna('col2') == [4, 5, 6], "Fallo: Prueba de inicialización en col2"
    print("Exito: Prueba de Inicialización de DataFramePersonalizado")

def prueba_agregar_columna_data_frame_personalizado():
    # Verifica la capacidad de agregar una columna y maneja excepciones al intentar añadir una columna ya existente.
    df = DataFrame({'col1': [1, 2, 3]})
    df.agregar_columna('col2', [4, 5, 6])
    assert df.obtener_columna('col2') == [4, 5, 6], "Fallo: Prueba de agregar columna"
    try:
        df.agregar_columna('col1', [7, 8, 9])
        print("Fallo: Prueba de agregar columna existente (no se lanzó excepción)")
    except ValueError:
        print("Exito: Prueba de Agregar Columna en DataFramePersonalizado")

def prueba_esta_vacio_data_frame_personalizado():
    # Verifica que el método `esta_vacio` funcione para data.frames vacíos, semi-vacíos, y llenos.
    df_vacio = DataFrame({})
    df_no_vacio = DataFrame({'col1': []})
    df_llenado = DataFrame({'col1': [1]})
    assert df_vacio.esta_vacio(), "Fallo: Verificación de DataFrame vacío"
    assert df_no_vacio.esta_vacio(), "Fallo: Estructura no vacía pero columna vacía"
    assert not df_llenado.esta_vacio(), "Fallo: Verificación de DataFrame no vacío"
    print("Exito: Prueba de esta_vacio en DataFramePersonalizado")

def prueba_escribir_y_leer_csv_data_frame_personalizado():
    # Prueba la escritura y lectura de datos en formato CSV, verificando la persistencia de los datos originales.
    df = DataFrame({'col1': [1, 2, 3], 'col2': [4.5, 5.5, 6.5], 'col3': ['a', 'b', 'c']})
    ruta_archivo = 'prueba.csv'
    df.escribir_a_csv(ruta_archivo)
    df_cargado = DataFrame.leer_desde_csv(ruta_archivo)
    assert df_cargado.obtener_columna('col1') == [1, 2, 3], "Fallo: Lectura CSV en col1"
    assert df_cargado.obtener_columna('col2') == [4.5, 5.5, 6.5], "Fallo: Lectura CSV en col2"
    assert df_cargado.obtener_columna('col3') == ['a', 'b', 'c'], "Fallo: Lectura CSV en col3"
    os.remove(ruta_archivo)
    print("Exito: Prueba de Escritura y Lectura CSV en DataFramePersonalizado")

def prueba_escribir_y_leer_txt_data_frame_personalizado():
    # Prueba la escritura y lectura de datos en formato TXT, asegurando que los datos persisten correctamente.
    df = DataFrame({'col1': [10, 20, 30], 'col2': [40.1, 50.2, 60.3], 'col3': ['x', 'y', 'z']})
    ruta_archivo = 'prueba.txt'
    df.escribir_a_txt(ruta_archivo)
    df_cargado = DataFrame.leer_desde_txt(ruta_archivo)
    assert df_cargado.obtener_columna('col1') == [10, 20, 30], "Fallo: Lectura TXT en col1"
    assert df_cargado.obtener_columna('col2') == [40.1, 50.2, 60.3], "Fallo: Lectura TXT en col2"
    assert df_cargado.obtener_columna('col3') == ['x', 'y', 'z'], "Fallo: Lectura TXT en col3"
    os.remove(ruta_archivo)
    print("Exito: Prueba de Escritura y Lectura TXT en DataFramePersonalizado")


if __name__ == "__main__":
    prueba_inicializacion_data_frame_personalizado()
    prueba_agregar_columna_data_frame_personalizado()
    prueba_esta_vacio_data_frame_personalizado()
    prueba_escribir_y_leer_csv_data_frame_personalizado()
    prueba_escribir_y_leer_txt_data_frame_personalizado()
