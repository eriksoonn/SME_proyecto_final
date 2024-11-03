import math

class Metricas:
    @staticmethod
    def varianza(columna: list[float | int]) -> float:
        '''
        Método para calcular la varianza de una columna numérica.
        Parametros:
            columna: (list[float | int]) Lista de valores numéricos.
        Return:
            float: Varianza de los valores en la columna.
        '''
        media = sum(columna) / len(columna)
        return sum((x - media) ** 2 for x in columna) / len(columna)

    @staticmethod
    def entropia(columna: list) -> float:
        '''
        Método para calcular la entropía de una columna categórica.
        Parametros:
            columna: (list) Lista de valores categóricos.
        Return:
            float: Entropía de los valores en la columna.
        '''
        conteo_valores = {}
        for valor in columna:
            conteo_valores[valor] = conteo_valores.get(valor, 0) + 1
        total = len(columna)
        return -sum((conteo / total) * math.log2(conteo / total) for conteo in conteo_valores.values())

    @staticmethod
    def auc(columna: list[float | int], columna_clase: list[int]) -> float:
        '''
        Método para calcular el AUC (Area Under the Curve) de una columna en función de una columna de clase binaria.
        Parametros:
            columna: (list[float | int]) Lista de valores numéricos para ordenar.
            columna_clase: (list[int]) Lista binaria de clases asociadas a cada valor en columna.
        Return:
            float: Valor de AUC calculado para la columna y columna_clase.
        '''
        pares_ordenados = sorted(zip(columna, columna_clase), key=lambda x: x[0])
        conteo_positivos = sum(columna_clase)
        conteo_negativos = len(columna_clase) - conteo_positivos

        suma_rangos = 0
        rango = 1
        indices_actuales_empatados = [0]

        for idx in range(1, len(pares_ordenados)):
            if pares_ordenados[idx][0] == pares_ordenados[idx - 1][0]:
                indices_actuales_empatados.append(idx)
            else:
                len_empate = len(indices_actuales_empatados)
                rango_promedio = (2 * rango + len_empate - 1) / 2
                suma_rangos += sum(
                    rango_promedio for k in indices_actuales_empatados if pares_ordenados[k][1] == 1
                )
                rango += len_empate
                indices_actuales_empatados = [idx]

        if indices_actuales_empatados:
            len_empate = len(indices_actuales_empatados)
            rango_promedio = (2 * rango + len_empate - 1) / 2
            suma_rangos += sum(
                rango_promedio for k in indices_actuales_empatados if pares_ordenados[k][1] == 1
            )

        return (suma_rangos - conteo_positivos * (conteo_positivos + 1) / 2) / (conteo_positivos * conteo_negativos)


    @staticmethod
    def calcular_metrica(df, nombre_columna: str, nombre_columna_clase: str = None) -> dict:
        '''
        Método para calcular una métrica para una columna en un data.frame.
        Parametros:
            df: (DataFramePersonalizado) DataFrame con los datos.
            nombre_columna: (str) Nombre de la columna para la cual calcular la métrica.
            nombre_columna_clase: (str, opcional) Nombre de la columna de clase si es necesaria para el cálculo.
        Return:
            dict: Diccionario con la métrica calculada.
        '''
        columna = df.obtener_columna(nombre_columna)
        valores_unicos = set(columna)
        num_unicos = len(valores_unicos)
        total_valores = len(columna)
        ratio_unicos = num_unicos / total_valores

        es_numerica = all(isinstance(x, (int, float)) for x in columna)

        if es_numerica:
            # Decidir si tratar como categórica o numérica basado en valores únicos
            if num_unicos <= 10 and ratio_unicos < 0.5:
                # Tratar como categórica
                return {"Entropía": Metricas.entropia(columna)}
            else:
                if nombre_columna_clase:
                    columna_clase = df.obtener_columna(nombre_columna_clase)
                    return {
                        "Varianza": Metricas.varianza(columna),
                        "AUC": Metricas.auc(columna, columna_clase)
                    }
                return {"Varianza": Metricas.varianza(columna)}
        else:
            # No numérica, tratar como categórica
            return {"Entropía": Metricas.entropia(columna)}

