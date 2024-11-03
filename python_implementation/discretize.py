import math

class Discretizador:
    # Diccionario para almacenar puntos de corte por método de discretización
    puntos_corte = {}

    @staticmethod
    def ancho_igual(columna: list[float | int], bins: int) -> list[int]:
        '''
        Método para discretizar una columna en intervalos de ancho igual.
        Parameters:
            columna: (list[float | int]) Lista de valores numéricos a discretizar.
            bins: (int) Número de intervalos (bins).
        Return:
            list[int]: Lista de valores discretizados en función del intervalo correspondiente.
        '''
        min_valor, max_valor = min(columna), max(columna)
        rango = max_valor - min_valor + 1e-10  # Para evitar divisiones por cero
        ancho = rango / bins
        puntos_corte = [min_valor + i * ancho for i in range(1, bins)]
        Discretizador.puntos_corte['ancho_igual'] = puntos_corte
        discretizado = [
            min(bins - 1, int((valor - min_valor) / rango * bins)) for valor in columna
        ]
        return discretizado

    @staticmethod
    def frecuencia_igual(columna: list[float | int], bins: int) -> list[int]:
        '''
        Método para discretizar una columna en intervalos de frecuencia igual.
        Parameters:
            columna: (list[float | int]) Lista de valores numéricos a discretizar.
            bins: (int) Número de intervalos (bins).
        Return:
            list[int]: Lista de valores discretizados en función del intervalo correspondiente.
        '''
        valores_ordenados = sorted(columna)
        n = len(columna)
        tamano_bin = n // bins
        puntos_corte = [valores_ordenados[(i + 1) * tamano_bin - 1] for i in range(bins - 1)]
        Discretizador.puntos_corte['frecuencia_igual'] = puntos_corte
        discretizado = [0] * n
        for indice_bin in range(bins):
            inicio = indice_bin * tamano_bin
            fin = inicio + tamano_bin if indice_bin < bins - 1 else n
            for i in range(inicio, fin):
                discretizado[columna.index(valores_ordenados[i])] = indice_bin
        return discretizado

    @staticmethod
    def k_means(columna: list[float | int], bins: int) -> list[int]:
        '''
        Método para discretizar una columna usando el algoritmo de k-means.
        Parameters:
            columna: (list[float | int]) Lista de valores numéricos a discretizar.
            bins: (int) Número de intervalos (bins).
        Return:
            list[int]: Lista de valores discretizados en función del intervalo correspondiente.
        '''
        min_valor, max_valor = min(columna), max(columna)
        centroides = [min_valor + (i + 0.5) * (max_valor - min_valor) / bins for i in range(bins)]
        centroides_previos = [None] * bins
        while centroides != centroides_previos:
            clusters = [[] for _ in range(bins)]
            for valor in columna:
                indice_mas_cercano = min(range(bins), key=lambda i: abs(valor - centroides[i]))
                clusters[indice_mas_cercano].append(valor)
            centroides_previos = centroides[:]
            centroides = [sum(cluster) / len(cluster) if cluster else centroides[i]
                          for i, cluster in enumerate(clusters)]
        Discretizador.puntos_corte['k_means'] = [(centroides[i] + centroides[i + 1]) / 2 for i in range(bins - 1)]
        discretizado = [
            next((i for i, corte in enumerate(Discretizador.puntos_corte['k_means']) if valor < corte), bins - 1)
            for valor in columna
        ]
        return discretizado

    @staticmethod
    def basado_en_cuantiles(columna: list[float | int], bins: int) -> list[int]:
        '''
        Método para discretizar una columna basada en cuantiles.
        Parameters:
            columna: (list[float | int]) Lista de valores numéricos a discretizar.
            bins: (int) Número de intervalos (bins).
        Return:
            list[int]: Lista de valores discretizados en función del intervalo correspondiente.
        '''
        valores_ordenados = sorted(columna)
        n = len(valores_ordenados)
        tamano_bin = n / bins
        puntos_corte = [(valores_ordenados[int(i * tamano_bin - 1)] + valores_ordenados[int(i * tamano_bin)]) / 2 for i in range(1, bins)]
        Discretizador.puntos_corte['basado_en_cuantiles'] = puntos_corte
        return [next((i for i, corte in enumerate(puntos_corte) if valor < corte), bins - 1) for valor in columna]

    @staticmethod
    def discretizar_columna(df, nombre_columna: str, metodo: str = 'ancho_igual', bins: int = 3) -> None:
        '''
        Método para discretizar una columna de un data.frame usando un método específico.
        Parameters:
            df: (objeto) DataFrame con la columna a discretizar.
            nombre_columna: (str) Nombre de la columna a discretizar.
            metodo: (str) Método de discretización ('ancho_igual', 'frecuencia_igual', 'k_means', 'basado_en_cuantiles').
            bins: (int) Número de intervalos (bins).
        Return:
            None
        '''
        columna = df.obtener_columna(nombre_columna)
        if metodo == 'ancho_igual':
            discretizado = Discretizador.ancho_igual(columna, bins)
        elif metodo == 'frecuencia_igual':
            discretizado = Discretizador.frecuencia_igual(columna, bins)
        elif metodo == 'k_means':
            discretizado = Discretizador.k_means(columna, bins)
        elif metodo == 'basado_en_cuantiles':
            discretizado = Discretizador.basado_en_cuantiles(columna, bins)
        else:
            raise ValueError("Método de discretización no válido. Use 'ancho_igual', 'frecuencia_igual', 'k_means', o 'basado_en_cuantiles'.")
        df.datos[nombre_columna] = discretizado

    @staticmethod
    def obtener_rangos_bins(metodo: str = 'ancho_igual', decimales: int = 8) -> list[tuple[float, float]]:
        '''
        Método para obtener los rangos de cada bin en función del método de discretización usado.
        Parameters:
            metodo: (str) Método de discretización para el cual obtener los rangos de bins.
            decimales: (int) Número de decimales para redondear los puntos de corte.
        Return:
            list[tuple[float, float]]: Lista de tuplas que representan los rangos de cada bin.
        Exceptions:
            ValueError si no existen puntos de corte para el método especificado.
        '''
        if metodo not in Discretizador.puntos_corte:
            raise ValueError("No existen puntos de corte para el método especificado.")
        
        puntos_corte = Discretizador.puntos_corte[metodo]
        rangos_bins = []
        corte_previo = float('-inf')
        for corte in puntos_corte:
            rangos_bins.append((corte_previo, round(corte, decimales)))
            corte_previo = round(corte, decimales)
        rangos_bins.append((corte_previo, float('inf')))
        
        return rangos_bins
