import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from discretize import Discretizador
from dataframe import DataFrame

def prueba_discretizador_ancho_igual():
    # Verifica la discretización de igual ancho.
    columna = [1, 2, 3, 4, 5]
    bins = 2
    resultado = Discretizador.ancho_igual(columna, bins)
    esperado = [0, 0, 0, 1, 1]
    assert resultado == esperado, f"Fallo: Prueba de ancho igual. Obtenido {resultado}"
    print("Exito: Prueba de Discretizador Ancho Igual")

def prueba_discretizador_frecuencia_igual():
    # Verifica la discretización de igual frecuencia.
    columna = [1, 2, 3, 4, 5]
    bins = 2
    resultado = Discretizador.frecuencia_igual(columna, bins)
    esperado = [0, 0, 1, 1, 1]
    assert resultado == esperado, f"Fallo: Prueba de frecuencia igual. Obtenido {resultado}"
    print("Exito: Prueba de Discretizador Frecuencia Igual")

def prueba_discretizador_k_means():
    # Verifica la discretización usando el método k-means.
    columna = [10, 20, 20, 30, 40, 40, 50, 60]
    bins = 3
    resultado = Discretizador.k_means(columna, bins)
    esperado = [0, 0, 0, 1, 1, 1, 2, 2]
    assert resultado == esperado, f"Fallo: Prueba de k-means. Obtenido {resultado}"
    print("Exito: Prueba de Discretizador K-means")

def prueba_discretizador_basado_en_cuantiles():
    # Verifica la discretización basada en cuantiles.
    columna = [5, 15, 25, 35, 45, 55, 65, 75, 85]
    bins = 3
    resultado = Discretizador.basado_en_cuantiles(columna, bins)
    esperado = [0, 0, 0, 1, 1, 1, 2, 2, 2]
    assert resultado == esperado, f"Fallo: Prueba de cuantiles. Obtenido {resultado}"
    print("Exito: Prueba de Discretizador Basado en Cuantiles")

def prueba_discretizador_discretizar_columna_k_means():
    # Verifica la discretización de una columna en un data.frame usando k-means.
    df = DataFrame({'col': [10, 20, 20, 30, 40, 40, 50, 60]})
    Discretizador.discretizar_columna(df, 'col', metodo='k_means', bins=3)
    resultado = df.obtener_columna('col')
    esperado = [0, 0, 0, 1, 1, 1, 2, 2]
    assert resultado == esperado, f"Fallo: Prueba de discretizar columna k-means. Obtenido {resultado}"
    print("Exito: Prueba de Discretizador Discretizar Columna K-means")

def prueba_discretizador_discretizar_columna_basado_en_cuantiles():
    # Verifica la discretización de una columna en un data.frame usando cuantiles.
    df = DataFrame({'col': [5, 15, 25, 35, 45, 55, 65, 75, 85]})
    Discretizador.discretizar_columna(df, 'col', metodo='basado_en_cuantiles', bins=3)
    resultado = df.obtener_columna('col')
    esperado = [0, 0, 0, 1, 1, 1, 2, 2, 2]
    assert resultado == esperado, f"Fallo: Prueba de discretizar columna basado en cuantiles. Obtenido {resultado}"
    print("Exito: Prueba de Discretizador Discretizar Columna Basado en Cuantiles")

def prueba_discretizador_obtener_rangos_bins_k_means():
    # Verifica los rangos de los bins después de discretización k-means.
    columna = [10, 20, 20, 30, 40, 40, 50, 60]
    bins = 3
    Discretizador.k_means(columna, bins)
    resultado = Discretizador.obtener_rangos_bins('k_means')
    rangos_esperados = [
        (-float('inf'), round(26.666666666666664, 8)),
        (round(26.666666666666664, 8), round(45.83333333333333, 8)),
        (round(45.83333333333333, 8), float('inf'))
    ]
    resultado_redondeado = [(round(inf, 8), round(sup, 8)) for inf, sup in resultado]
    assert resultado_redondeado == rangos_esperados, f"Fallo: Obtener rangos de bins k-means. Esperado {rangos_esperados}, obtenido {resultado_redondeado}"
    print("Exito: Prueba de Discretizador Obtener Rangos de Bins K-means")

def prueba_discretizador_obtener_rangos_bins_basado_en_cuantiles():
    # Verifica los rangos de los bins después de discretización basada en cuantiles.
    columna = [5, 15, 25, 35, 45, 55, 65, 75, 85]
    bins = 3
    Discretizador.basado_en_cuantiles(columna, bins)
    resultado = Discretizador.obtener_rangos_bins('basado_en_cuantiles')
    rangos_esperados = [(-float('inf'), 30.0), (30.0, 60.0), (60.0, float('inf'))]
    
    for i in range(len(resultado)):
        if resultado[i][0] == float('-inf'):
            assert resultado[i][0] == rangos_esperados[i][0]
        elif resultado[i][1] == float('inf'):
            assert resultado[i][1] == rangos_esperados[i][1]
        else:
            assert abs(resultado[i][0] - rangos_esperados[i][0]) < 1e-10
            assert abs(resultado[i][1] - rangos_esperados[i][1]) < 1e-10
    
    print("Exito: Prueba de Discretizador Obtener Rangos de Bins Basado en Cuantiles")

if __name__ == "__main__":
    prueba_discretizador_ancho_igual()
    prueba_discretizador_frecuencia_igual()
    prueba_discretizador_k_means()
    prueba_discretizador_basado_en_cuantiles()
    prueba_discretizador_discretizar_columna_k_means()
    prueba_discretizador_discretizar_columna_basado_en_cuantiles()
    prueba_discretizador_obtener_rangos_bins_k_means()
    prueba_discretizador_obtener_rangos_bins_basado_en_cuantiles()

