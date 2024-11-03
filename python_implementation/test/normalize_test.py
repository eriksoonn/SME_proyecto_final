import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from normalize import EscaladorDatos
from dataframe import DataFrame

def prueba_normalizar_min_max():
    # Verifica la normalización min-max en una columna numérica.
    columna = [10, 20, 30, 40, 50]
    resultado = EscaladorDatos.normalizar_min_max(columna)
    esperado = [0.0, 0.25, 0.5, 0.75, 1.0]
    tolerancia = 1e-5
    assert all(abs(r - e) < tolerancia for r, e in zip(resultado, esperado)), f"Fallo: Prueba de Normalización Min-Max. Obtenido {resultado}"
    print("Éxito: Prueba de Normalización Min-Max")

def prueba_estandarizar():
    # Verifica la estandarización de una columna numérica.
    columna = [10, 20, 30, 40, 50]
    resultado = EscaladorDatos.estandarizar(columna)
    esperado = [-1.41421, -0.70711, 0.0, 0.70711, 1.41421]
    tolerancia = 1e-3
    assert all(abs(r - e) < tolerancia for r, e in zip(resultado, esperado)), f"Fallo: Prueba de Estandarización. Obtenido {resultado}"
    print("Éxito: Prueba de Estandarización")

def prueba_normalizar_data_frame():
    # Verifica la normalización min-max en un DataFrame, asegurando que las columnas numéricas se normalizan y las categóricas permanecen iguales.
    df = DataFrame({
        'edad': [25, 30, 35, 40, 45],
        'ingreso': [30000, 50000, 70000, 100000, 120000],
        'categoria': ['A', 'B', 'A', 'B', 'C']
    })
    EscaladorDatos.normalizar_data_frame(df)
    esperado_edad = [0.0, 0.25, 0.5, 0.75, 1.0]
    esperado_ingreso = [0.0, 0.22222, 0.44444, 0.77778, 1.0]
    tolerancia = 1e-3
    assert all(abs(r - e) < tolerancia for r, e in zip(df.obtener_columna('edad'), esperado_edad)), f"Fallo: Prueba de normalización DataFrame 'edad'. Obtenido {df.obtener_columna('edad')}"
    assert all(abs(r - e) < tolerancia for r, e in zip(df.obtener_columna('ingreso'), esperado_ingreso)), f"Fallo: Prueba de normalización DataFrame 'ingreso'. Obtenido {df.obtener_columna('ingreso')}"
    assert df.obtener_columna('categoria') == ['A', 'B', 'A', 'B', 'C'], f"Fallo: Prueba de normalización DataFrame 'categoria'. Obtenido {df.obtener_columna('categoria')}"
    print("Éxito: Prueba de Normalización de DataFrame")

def prueba_estandarizar_data_frame():
    # Verifica la estandarización en un DataFrame, asegurando que las columnas numéricas se estandarizan y las categóricas permanecen iguales.
    df = DataFrame({
        'edad': [25, 30, 35, 40, 45],
        'ingreso': [30000, 50000, 70000, 100000, 120000],
        'categoria': ['A', 'B', 'A', 'B', 'C']
    })
    EscaladorDatos.estandarizar_data_frame(df)
    esperado_edad = [-1.41421, -0.70711, 0.0, 0.70711, 1.41421]
    esperado_ingreso = [-1.34890, -0.73576, -0.12262, 0.79708, 1.41022]
    tolerancia = 1e-3
    assert all(abs(r - e) < tolerancia for r, e in zip(df.obtener_columna('edad'), esperado_edad)), f"Fallo: Prueba de estandarización DataFrame 'edad'. Obtenido {df.obtener_columna('edad')}"
    assert all(abs(r - e) < tolerancia for r, e in zip(df.obtener_columna('ingreso'), esperado_ingreso)), f"Fallo: Prueba de estandarización DataFrame 'ingreso'. Obtenido {df.obtener_columna('ingreso')}"
    assert df.obtener_columna('categoria') == ['A', 'B', 'A', 'B', 'C'], f"Fallo: Prueba de estandarización DataFrame 'categoria'. Obtenido {df.obtener_columna('categoria')}"
    print("Éxito: Prueba de Estandarización de DataFrame")

def prueba_es_columna_numerica():
    # Verifica si una columna es numérica o no.
    columna_numerica = [1, 2, 3, 4, 5]
    columna_no_numerica = [1, "dos", 3, 4, 5]
    assert EscaladorDatos.es_columna_numerica(columna_numerica), "Fallo: Verificación de columna numérica"
    assert not EscaladorDatos.es_columna_numerica(columna_no_numerica), "Fallo: Verificación de columna no numérica"
    print("Éxito: Prueba de es_columna_numerica")

if __name__ == "__main__":
    prueba_normalizar_min_max()
    prueba_estandarizar()
    prueba_normalizar_data_frame()
    prueba_estandarizar_data_frame()
    prueba_es_columna_numerica()

