import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from dataframe import DataFrame
from metrics import Metricas
import math

def prueba_varianza():
    # Verifica el cálculo de la varianza para una columna numérica.
    columna = [1, 2, 3, 4, 5]
    resultado = Metricas.varianza(columna)
    esperado = 2.0
    assert abs(resultado - esperado) < 1e-5, f"Fallo: Prueba de varianza. Obtenido {resultado}"
    print("Exito: Prueba de Varianza")

def prueba_entropia():
    # Verifica el cálculo de la entropía para una columna categórica.
    columna = [1, 1, 2, 2, 2, 3, 3]
    resultado = Metricas.entropia(columna)
    total = len(columna)
    p1 = 3 / total
    p2 = 2 / total
    p3 = 2 / total 
    esperado = -(p1 * math.log2(p1) + p2 * math.log2(p2) + p3 * math.log2(p3)) 
    assert abs(resultado - esperado) < 1e-5, f"Fallo: Prueba de entropía. Obtenido {resultado}"
    print("Exito: Prueba de Entropía")

def prueba_auc():
    # Verifica el cálculo del AUC para una columna de valores y su correspondiente columna de clase.
    columna = [0.1, 0.4, 0.35, 0.8]
    columna_clase = [0, 1, 0, 1]
    resultado = Metricas.auc(columna, columna_clase)
    esperado = 1.0
    assert abs(resultado - esperado) < 1e-5, f"Fallo: Prueba de AUC. Obtenido {resultado}"
    print("Exito: Prueba de AUC")

def prueba_calcular_metrica_varianza():
    # Verifica el cálculo de la métrica de varianza en una columna numérica usando un data.frame.
    df = DataFrame({'edad': [20, 25, 30, 35, 40]})
    resultado = Metricas.calcular_metrica(df, 'edad')
    esperado = {"Varianza": 50.0}
    assert resultado == esperado, f"Fallo: Prueba de calcular_metrica para varianza. Obtenido {resultado}"
    print("Exito: Prueba de Calcular Métrica Varianza")

def prueba_calcular_metrica_entropia():
    # Verifica el cálculo de la métrica de entropía en una columna categórica usando un data.frame.
    df = DataFrame({'compra': [1, 1, 0, 0, 1]})
    resultado = Metricas.calcular_metrica(df, 'compra')
    total = len(df.obtener_columna('compra'))
    p1 = 3 / total
    p2 = 2 / total
    esperado_entropia = -(p1 * math.log2(p1) + p2 * math.log2(p2))
    esperado = {"Entropía": esperado_entropia}
    assert abs(resultado['Entropía'] - esperado['Entropía']) < 1e-5, f"Fallo: Prueba de calcular_metrica para entropía. Obtenido {resultado}"
    print("Exito: Prueba de Calcular Métrica Entropía")

def prueba_calcular_metrica_auc():
    # Verifica el cálculo de la métrica de varianza y AUC en una columna numérica y su columna de clase asociada.
    df = DataFrame({
        'ingreso': [30000, 40000, 50000, 60000],
        'compra': [0, 1, 0, 1]
    })
    resultado = Metricas.calcular_metrica(df, 'ingreso', 'compra')
    esperado = {"Varianza": 125000000.0, "AUC": 0.75}
    assert abs(resultado["Varianza"] - esperado["Varianza"]) < 1e-5, f"Fallo: Prueba de calcular_metrica para varianza y AUC. Varianza obtenida {resultado['Varianza']}"
    assert abs(resultado["AUC"] - esperado["AUC"]) < 1e-5, f"Fallo: Prueba de calcular_metrica para AUC. AUC obtenida {resultado['AUC']}"
    print("Exito: Prueba de Calcular Métrica AUC")

def prueba_calcular_metrica_entropia_categorica():
    df = DataFrame({'categoria': ['A', 'B', 'A', 'B', 'C']})
    resultado = Metricas.calcular_metrica(df, 'categoria')
    
    total = len(df.obtener_columna('categoria'))
    pA = 2 / total
    pB = 2 / total
    pC = 1 / total
    esperado = {"Entropía": -(pA * math.log2(pA) + pB * math.log2(pB) + pC * math.log2(pC))}
    
    assert abs(resultado['Entropía'] - esperado['Entropía']) < 1e-5, f"Fallo: Prueba de calcular_metrica para entropía categórica. Obtenido {resultado}"
    print("Éxito: Prueba de Calcular Métrica Entropía Categórica")


if __name__ == "__main__":
    prueba_varianza()
    prueba_entropia()
    prueba_auc()
    prueba_calcular_metrica_varianza()
    prueba_calcular_metrica_entropia()
    prueba_calcular_metrica_auc()
    prueba_calcular_metrica_entropia_categorica()
