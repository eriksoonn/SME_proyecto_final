import matplotlib.pyplot as plt
from normalize import EscaladorDatos
from metrics import Metricas
from dataframe import DataFrame
from correlation import Correlacion

class VisualizadorDatos:
    def __init__(self, dataframe: DataFrame, correlacion: Correlacion=None):
        '''
        Constructor que inicializa el visualizador de datos con un DataFrame, una calculadora de correlación y una calculadora de métricas.
        Parámetros:
            dataframe: (DataFramePersonalizado) DataFrame con los datos.
            calculadora_correlacion: (CalculadoraCorrelacion) Instancia para calcular correlaciones.
            calculadora_metricas: (CalculadoraMetricas) Instancia para calcular métricas.
        '''
        self.dataframe = dataframe
        self.correlacion = correlacion

    def graficar_auc(self, columna_predictora: str, columna_clase: str) -> None:
        '''
        Método para graficar la curva ROC y calcular el AUC.
        Parámetros:
            columna_predictora: (str) Nombre de la columna con los valores del predictor.
            columna_clase: (str) Nombre de la columna con los valores de la clase binaria.
        Retorno:
            None
        '''
        valores_clase = self.dataframe.obtener_columna(columna_clase)
        valores_predictor = self.dataframe.obtener_columna(columna_predictora)
        
        pares_ordenados = sorted(zip(valores_predictor, valores_clase), key=lambda x: x[0])
        _, clase_ordenada = zip(*pares_ordenados)

        tpr, fpr = [0], [0]
        conteo_positivos = sum(clase_ordenada)
        conteo_negativos = len(clase_ordenada) - conteo_positivos
        tp, fp = 0, 0
        auc_sum = 0

        for i in range(len(clase_ordenada)):
            if clase_ordenada[i] == 1:
                tp += 1
            else:
                fp += 1
            tpr.append(tp / conteo_positivos)
            fpr.append(fp / conteo_negativos)
            if i > 0:
                auc_sum += (fpr[i] - fpr[i - 1]) * tpr[i]

        plt.plot(fpr, tpr, marker='o')
        plt.plot([0, 1], [0, 1], 'r--')
        plt.xlabel("Tasa de Falsos Positivos")
        plt.ylabel("Tasa de Verdaderos Positivos")
        plt.title(f"Curva ROC (AUC = {auc_sum:.2f})")
        plt.show()

    def graficar_matriz_correlacion(self) -> None:
        '''
        Método para graficar la matriz de correlación o de información mutua entre columnas.
        Retorno:
            None
        '''
        if self.correlacion is None: return
        
        resultados_correlacion = self.correlacion.calcular_correlacion_por_pares()
        columnas = list(self.dataframe.datos.keys())
        tamano_matriz = len(columnas)
        matriz_correlacion = [[0] * tamano_matriz for _ in range(tamano_matriz)]

        for (col1, col2), valor_corr in resultados_correlacion.items():
            i, j = columnas.index(col1), columnas.index(col2)
            matriz_correlacion[i][j] = matriz_correlacion[j][i] = valor_corr

        fig, ax = plt.subplots()
        cax = ax.matshow(matriz_correlacion, cmap='coolwarm')
        plt.colorbar(cax)
        ax.set_xticks(range(len(columnas)))
        ax.set_yticks(range(len(columnas)))
        ax.set_xticklabels(columnas, rotation=90)
        ax.set_yticklabels(columnas)
        plt.title("Matriz de Correlación / Información Mutua")
        plt.show()

    def graficar_histograma_entropia(self) -> None:
        '''
        Método para graficar un histograma de entropía de variables categóricas en el DataFrame.
        Retorno:
            None
        '''
        columnas_categoricas = [
            col for col in self.dataframe.datos.keys()
            if isinstance(self.dataframe.obtener_columna(col)[0], str)
            or isinstance(self.dataframe.obtener_columna(col)[0], int)
        ]
        
        valores_entropia = [
            Metricas.entropia(self.dataframe.obtener_columna(col))
            for col in columnas_categoricas
        ]

        plt.bar(columnas_categoricas, valores_entropia, color='skyblue')
        plt.xlabel("Variables Categóricas")
        plt.ylabel("Entropía")
        plt.title("Entropía de Variables Categóricas")
        plt.xticks(rotation=45)
        plt.show()

    def graficar_diagramas_caja_caracteristicas(self, estandarizado: bool = True) -> None:
        '''
        Método para graficar diagramas de caja de características continuas en el DataFrame.
        Parámetros:
            estandarizado: (bool) Indica si las características deben ser estandarizadas antes de graficar.
        Retorno:
            None
        '''
        columnas_continuas = [
            col for col in self.dataframe.datos.keys()
            if isinstance(self.dataframe.obtener_columna(col)[0], (int, float))
        ]
        
        if estandarizado:
            EscaladorDatos.estandarizar_data_frame(self.dataframe)

        datos = [self.dataframe.obtener_columna(col) for col in columnas_continuas]

        plt.boxplot(datos, vert=True, patch_artist=True, labels=columnas_continuas)
        plt.ylabel("Valores Estandarizados" if estandarizado else "Valores")
        plt.title("Diagramas de Caja de Características Continuas" + (" (Estandarizado)" if estandarizado else ""))
        plt.xticks(rotation=45)
        plt.show()

