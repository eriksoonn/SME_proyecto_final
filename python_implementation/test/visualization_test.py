import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from dataframe import DataFrame
from correlation import Correlacion
from visualization import VisualizadorDatos

def prueba_graficar_auc():
    # Prueba la generación de la curva ROC y el AUC con datos de ingresos y compras.
    df = DataFrame({
        'edad': [23, 45, 31, 22, 35],
        'ingreso': [30000, 50000, 70000, 100000, 120000],
        'compra': [1, 0, 1, 0, 1]
    })
    visualizador = VisualizadorDatos(df)
    try:
        visualizador.graficar_auc('ingreso', 'compra')
        print("Éxito: Prueba de graficar_auc")
    except Exception as e:
        print(f"Fallo: Prueba de graficar_auc con error: {e}")

def prueba_graficar_matriz_correlacion():
    # Prueba la generación de la matriz de correlación con datos de diferentes tipos.
    df = DataFrame({
        'edad': [23, 45, 31, 22, 35],
        'ingreso': [30000, 50000, 70000, 100000, 120000],
        'compra': [1, 0, 1, 0, 1],
        'categoria': [1, 1, 2, 2, 3]
    })
    calculadora_correlacion = Correlacion(df)
    visualizador = VisualizadorDatos(df, calculadora_correlacion)
    try:
        visualizador.graficar_matriz_correlacion()
        print("Éxito: Prueba de graficar_matriz_correlacion")
    except Exception as e:
        print(f"Fallo: Prueba de graficar_matriz_correlacion con error: {e}")

def prueba_graficar_histograma_entropia():
    # Prueba la generación de un histograma de entropía para variables categóricas.
    df = DataFrame({
        'categoria': ['A', 'B', 'A', 'A', 'C'],
        'compra': [1, 0, 1, 0, 1],
        'color': ['rojo', 'azul', 'rojo', 'verde', 'azul']
    })
    visualizador = VisualizadorDatos(df)
    try:
        visualizador.graficar_histograma_entropia()
        print("Éxito: Prueba de graficar_histograma_entropia")
    except Exception as e:
        print(f"Fallo: Prueba de graficar_histograma_entropia con error: {e}")

def prueba_graficar_diagramas_caja_caracteristicas():
    # Prueba la generación de diagramas de caja para características continuas (edad, ingreso, puntaje).
    df = DataFrame({
        'edad': [23, 45, 31, 22, 35],
        'ingreso': [30000, 50000, 70000, 100000, 120000],
        'puntaje': [80, 90, 85, 88, 92]
    })
    visualizador = VisualizadorDatos(df)
    
    try:
        visualizador.graficar_diagramas_caja_caracteristicas()
        print("Éxito: Prueba de graficar_diagramas_caja_caracteristicas")
    except Exception as e:
        print(f"Fallo: Prueba de graficar_diagramas_caja_caracteristicas con error: {e}")

if __name__ == "__main__":
    prueba_graficar_auc()
    prueba_graficar_matriz_correlacion()
    prueba_graficar_histograma_entropia()
    prueba_graficar_diagramas_caja_caracteristicas()

