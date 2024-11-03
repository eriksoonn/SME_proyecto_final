import math

class Correlacion:
    def __init__(self, dataframe):
        '''
        Constructor que inicializa la calculadora de correlación con un DataFrame.
        Parameters:
            dataframe: (DataFramePersonalizado) DataFrame con los datos.
        '''
        self.dataframe = dataframe

    def _es_numerico(self, columna: list) -> bool:
        '''
        Método para verificar si todos los elementos de una columna son numéricos.
        Parameters:
            columna: (list) Lista de elementos a verificar.
        Return:
            bool: True si todos los elementos son numéricos (int o float), False en caso contrario.
        '''
        return all(isinstance(x, (int, float)) for x in columna)

    def correlacion_pearson(self, col1: list[float], col2: list[float]) -> float:
        '''
        Método para calcular la correlación de Pearson entre dos columnas numéricas.
        Parameters:
            col1: (list[float]) Primera columna de valores numéricos.
            col2: (list[float]) Segunda columna de valores numéricos.
        Return:
            float: Valor de correlación de Pearson entre col1 y col2.
        '''
        media1, media2 = sum(col1) / len(col1), sum(col2) / len(col2)
        num = sum((x - media1) * (y - media2) for x, y in zip(col1, col2))
        den1 = math.sqrt(sum((x - media1) ** 2 for x in col1))
        den2 = math.sqrt(sum((y - media2) ** 2 for y in col2))
        return num / (den1 * den2) if den1 != 0 and den2 != 0 else 0

    def informacion_mutua(self, col1: list, col2: list) -> float:
        '''
        Método para calcular la información mutua entre dos columnas categóricas.
        Parameters:
            col1: (list) Primera columna de valores.
            col2: (list) Segunda columna de valores.
        Return:
            float: Valor de información mutua entre col1 y col2.
        '''
        # Contadores de frecuencias conjuntas y marginales
        conteo_conjunto = {}
        conteo_col1 = {}
        conteo_col2 = {}
        total = len(col1)
        
        # Construcción de las distribuciones
        for x, y in zip(col1, col2):
            conteo_conjunto[(x, y)] = conteo_conjunto.get((x, y), 0) + 1
            conteo_col1[x] = conteo_col1.get(x, 0) + 1
            conteo_col2[y] = conteo_col2.get(y, 0) + 1
            
        # Cálculo de la información mutua
        informacion_mutua = 0
        for (x, y), conteo in conteo_conjunto.items():
            p_xy = conteo / total
            p_x = conteo_col1[x] / total
            p_y = conteo_col2[y] / total
            informacion_mutua += p_xy * math.log2(p_xy / (p_x * p_y))
            
        return informacion_mutua

    def calcular_correlacion_por_pares(self) -> dict:
        '''
        Método para calcular la correlación entre todas las combinaciones de columnas en el DataFrame.
        Para columnas numéricas se usa la correlación de Pearson, y para categóricas, la información mutua.
        Return:
            dict: Diccionario con las correlaciones entre pares de columnas.
                  Las llaves son tuplas (nombre_col1, nombre_col2) y los valores son los coeficientes de correlación.
        '''
        resultados_correlacion = {}
        columnas = list(self.dataframe.datos.keys())
        
        for i, nombre_col1 in enumerate(columnas):
            for nombre_col2 in columnas[i + 1:]:
                col1 = self.dataframe.obtener_columna(nombre_col1)
                col2 = self.dataframe.obtener_columna(nombre_col2)
                
                # Verifica si ambas columnas son numéricas para usar Pearson, si no, usa información mutua.
                if self._es_numerico(col1) and self._es_numerico(col2):
                    correlacion = self.correlacion_pearson(col1, col2)
                else:
                    correlacion = self.informacion_mutua(col1, col2)
                
                resultados_correlacion[(nombre_col1, nombre_col2)] = correlacion
                
        return resultados_correlacion
