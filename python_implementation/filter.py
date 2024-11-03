from metrics import Metricas
from dataframe import DataFrame

class Filtro:
    def __init__(self, dataframe: DataFrame):
        '''
        Constructor que inicializa un filtro de datos con el DataFrame original.
        Parameters:
            dataframe: (DataFramePersonalizado) DataFrame con los datos originales.
        '''
        self.df_original = dataframe
        self.datos_filtrados = {}

    def _validar_columnas(self, columnas: list[str] = None) -> list[str]:
        '''
        Método para validar las columnas especificadas.
        Parameters:
            columnas: (list[str] | None) Lista de nombres de columnas a validar, o None para usar todas las columnas.
        Return:
            list[str]: Lista de columnas válidas que existen en el DataFrame original.
        Exceptions:
            ValueError si `columnas` no es una lista de nombres de columnas.
        '''
        if columnas is None:
            return list(self.df_original.datos.keys())
        if not isinstance(columnas, list) or not all(isinstance(col, str) for col in columnas):
            raise ValueError("`columnas` debe ser una lista de nombres de columnas.")
        return [col for col in columnas if col in self.df_original.datos]

    def filtrar_por_entropia(self, umbral: float, columnas: list[str] = None) -> None:
        '''
        Método para filtrar columnas en función de la entropía.
        Parameters:
            umbral: (float) Umbral de entropía por encima del cual se filtran las columnas.
            columnas: (list[str] | None) Lista de nombres de columnas a filtrar, o None para todas las columnas.
        '''
        columnas_a_filtrar = self._validar_columnas(columnas)
        for nombre_columna in columnas_a_filtrar:
            columna = self.df_original.obtener_columna(nombre_columna)
            valor_entropia = Metricas.entropia(columna)
            if valor_entropia > umbral:
                self.datos_filtrados[nombre_columna] = columna

    def filtrar_por_varianza(self, umbral: float, columnas: list[str] = None) -> None:
        '''
        Método para filtrar columnas en función de la varianza.
        Parameters:
            umbral: (float) Umbral de varianza por encima del cual se filtran las columnas.
            columnas: (list[str] | None) Lista de nombres de columnas a filtrar, o None para todas las columnas.
        '''
        columnas_a_filtrar = self._validar_columnas(columnas)
        for nombre_columna in columnas_a_filtrar:
            columna = self.df_original.obtener_columna(nombre_columna)
            if all(isinstance(x, (int, float)) for x in columna):
                valor_varianza = Metricas.varianza(columna)
                print(valor_varianza)
                if valor_varianza > umbral:
                    self.datos_filtrados[nombre_columna] = columna

    def filtrar_por_auc(self, umbral: float, nombre_columna_clase: str, columnas: list[str] = None) -> None:
        '''
        Método para filtrar columnas en función del AUC (Area Under the Curve) en relación a una columna de clase binaria.
        Parameters:
            umbral: (float) Umbral de AUC por encima del cual se filtran las columnas.
            nombre_columna_clase: (str) Nombre de la columna de clase binaria.
            columnas: (list[str] | None) Lista de nombres de columnas a filtrar, o None para todas las columnas.
        Exceptions:
            ValueError si la columna de clase especificada no existe en el DataFrame.
        '''
        if nombre_columna_clase not in self.df_original.datos:
            raise ValueError(f"La columna de clase especificada '{nombre_columna_clase}' no existe.")
        
        columnas_a_filtrar = self._validar_columnas(columnas)
        for nombre_columna in columnas_a_filtrar:
            if nombre_columna == nombre_columna_clase:
                continue
            columna = self.df_original.obtener_columna(nombre_columna)
            if all(isinstance(x, (int, float)) for x in columna):
                valor_auc = Metricas.auc(columna, self.df_original.obtener_columna(nombre_columna_clase))
                if valor_auc > umbral:
                    self.datos_filtrados[nombre_columna] = columna

    def obtener_data_frame_filtrado(self) -> DataFrame:
        '''
        Método para obtener un nuevo DataFrame con los datos filtrados.
        Return:
            DataFramePersonalizado: DataFrame que contiene solo las columnas que cumplen con los filtros aplicados.
        '''
        return DataFrame(self.datos_filtrados)
