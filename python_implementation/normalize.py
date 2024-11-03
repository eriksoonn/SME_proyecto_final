class EscaladorDatos:
    @staticmethod
    def es_columna_numerica(columna: list) -> bool:
        '''
        Método para verificar si todos los elementos de una columna son numéricos.
        Parámetros:
            columna: (list) Lista de elementos a verificar.
        Retorno:
            bool: True si todos los elementos son de tipo int o float, False en caso contrario.
        '''
        return all(isinstance(x, (int, float)) for x in columna)

    @staticmethod
    def normalizar_min_max(columna: list[float | int], decimales: int = 3) -> list[float]:
        '''
        Método para normalizar una columna utilizando la escala min-max.
        Parámetros:
            columna: (list[float | int]) Lista de valores numéricos a normalizar.
            decimales: (int) Número de decimales para redondear los valores normalizados.
        Retorno:
            list[float]: Lista de valores normalizados con la escala min-max.
        '''
        min_val, max_val = min(columna), max(columna)
        if max_val == min_val:
            return [round(0.5, decimales)] * len(columna)
        return [round((x - min_val) / (max_val - min_val), decimales) for x in columna]

    @staticmethod
    def estandarizar(columna: list[float | int], decimales: int = 3) -> list[float]:
        '''
        Método para estandarizar una columna, restando la media y dividiendo por la desviación estándar.
        Parámetros:
            columna: (list[float | int]) Lista de valores numéricos a estandarizar.
            decimales: (int) Número de decimales para redondear los valores estandarizados.
        Retorno:
            list[float]: Lista de valores estandarizados.
        '''
        media = sum(columna) / len(columna)
        varianza = sum((x - media) ** 2 for x in columna) / len(columna)
        desviacion_estandar = varianza ** 0.5
        if desviacion_estandar == 0:
            return [round(0.0, decimales)] * len(columna)
        return [round((x - media) / desviacion_estandar, decimales) for x in columna]

    @staticmethod
    def normalizar_data_frame(df, decimales: int = 3) -> None:
        '''
        Método para normalizar cada columna numérica de un data.frame usando la escala min-max.
        Parámetros:
            df: (objeto) DataFrame personalizado con los datos a normalizar.
            decimales: (int) Número de decimales para redondear los valores normalizados.
        Retorno:
            None
        '''
        for nombre_columna in df.datos:
            columna = df.obtener_columna(nombre_columna)
            if EscaladorDatos.es_columna_numerica(columna):
                df.datos[nombre_columna] = EscaladorDatos.normalizar_min_max(columna, decimales)

    @staticmethod
    def estandarizar_data_frame(df, decimales: int = 3) -> None:
        '''
        Método para estandarizar cada columna numérica de un data.frame, restando la media y dividiendo por la desviación estándar.
        Parámetros:
            df: (objeto) DataFrame personalizado con los datos a estandarizar.
            decimales: (int) Número de decimales para redondear los valores estandarizados.
        Retorno:
            None
        '''
        for nombre_columna in df.datos:
            columna = df.obtener_columna(nombre_columna)
            if EscaladorDatos.es_columna_numerica(columna):
                df.datos[nombre_columna] = EscaladorDatos.estandarizar(columna, decimales)
