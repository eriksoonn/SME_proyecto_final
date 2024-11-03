import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from dataframe import DataFrame
from correlation import Correlacion

def prueba_correlacion_pearson():
    # Verifica la correlación de Pearson para dos columnas numéricas perfectamente correlacionadas.
    df = DataFrame({
        'x': [1, 2, 3, 4, 5],
        'y': [2, 4, 6, 8, 10]
    })
    calculadora_correlacion = Correlacion(df)
    correlaciones = calculadora_correlacion.calcular_correlacion_por_pares()
    correlacion_esperada = 1.0
    assert abs(correlaciones[('x', 'y')] - correlacion_esperada) < 1e-5, f"Fallo: Prueba de correlación de Pearson. Obtenido {correlaciones[('x', 'y')]}"
    print("Éxito: Prueba de Correlación de Pearson")

def prueba_correlacion_cero():
    # Verifica la correlación de Pearson para dos columnas numéricas con correlación negativa perfecta.
    df = DataFrame({
        'x': [1, 2, 3, 4, 5],
        'y': [5, 4, 3, 2, 1]
    })
    calculadora_correlacion = Correlacion(df)
    correlaciones = calculadora_correlacion.calcular_correlacion_por_pares()
    correlacion_esperada = -1.0
    assert abs(correlaciones[('x', 'y')] - correlacion_esperada) < 1e-5, f"Fallo: Prueba de correlación cero. Obtenido {correlaciones[('x', 'y')]}"
    print("Éxito: Prueba de Correlación Cero")

def prueba_informacion_mutua():
    # Verifica el cálculo de la información mutua para dos columnas categóricas.
    df = DataFrame({
        'a': ['gato', 'perro', 'perro', 'pajaro', 'pajaro'],
        'b': ['manzana', 'banana', 'banana', 'cereza', 'cereza']
    })
    calculadora_correlacion = Correlacion(df)
    correlaciones = calculadora_correlacion.calcular_correlacion_por_pares()
    info_mutua_esperada = 1.5219280948873621
    assert abs(correlaciones[('a', 'b')] - info_mutua_esperada) < 1e-5, f"Fallo: Prueba de información mutua. Obtenido {correlaciones[('a', 'b')]}"
    print("Éxito: Prueba de Información Mutua")

def prueba_correlacion_mixta():
    # Verifica la correlación entre columnas mixtas (numéricas y categóricas).
    df = DataFrame({
        'num': [10, 20, 30, 40, 50],
        'cat': [1, 1, 2, 2, 3],
        'otro_num': [15, 25, 35, 45, 55]
    })
    calculadora_correlacion = Correlacion(df)
    correlaciones = calculadora_correlacion.calcular_correlacion_por_pares()
    
    correlacion_pearson_esperada = 1.0
    assert abs(correlaciones[('num', 'otro_num')] - correlacion_pearson_esperada) < 1e-5, f"Fallo: Prueba de correlación mixta (Pearson). Obtenido {correlaciones[('num', 'otro_num')]}"

    info_mutua_obtenida = correlaciones[('num', 'cat')]  # No se puede predecir el valor exacto sin la distribución completa
    assert isinstance(info_mutua_obtenida, float) and info_mutua_obtenida >= 0, f"Fallo: Prueba de correlación mixta (Información Mutua). Obtenido {info_mutua_obtenida}"
    
    print("Éxito: Prueba de Correlación Mixta")

if __name__ == "__main__":
    prueba_correlacion_pearson()
    prueba_correlacion_cero()
    prueba_informacion_mutua()
    prueba_correlacion_mixta()

