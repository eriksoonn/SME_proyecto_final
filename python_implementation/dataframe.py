'''
Clase para manipular un data.frame personalizado con métodos para añadir y acceder columnas,
validar si está vacío, y exportar o importar datos en formatos CSV y TXT.
'''

class DataFrame:
    def __init__(self, datos: dict[str, list]):
        '''
        Constructor para inicializar el data.frame personalizado.
        Parameters:
            datos: (dict[str, list]) Diccionario que representa el data.frame, donde las llaves son nombres de columnas y los valores son listas con datos de cada columna.
        '''
        self.datos = datos
    
    def agregar_columna(self, nombre_columna: str, valores: list) -> None:
        '''
        Método para añadir una columna al data.frame.
        Parameters:
            nombre_columna: (str) Nombre de la nueva columna.
            valores: (list) Lista de valores para la columna.
        Return:
            None
        Exceptions:
            ValueError si la columna ya existe.
        '''
        if nombre_columna in self.datos:
            raise ValueError(f"La columna '{nombre_columna}' ya existe.")
        
        self.datos[nombre_columna] = valores
    
    def obtener_columna(self, nombre_columna: str) -> list:
        '''
        Método para obtener los valores de una columna específica.
        Parameters:
            nombre_columna: (str) Nombre de la columna a obtener.
        Return:
            list: Lista de valores de la columna solicitada.
        Exceptions:
            KeyError si la columna no existe.
        '''
        if nombre_columna not in self.datos:
            raise KeyError(f"La columna '{nombre_columna}' no existe.")
        
        return self.datos[nombre_columna]

    def esta_vacio(self) -> bool:
        '''
        Método para verificar si el data.frame está vacío.
        Return:
            bool: True si no hay datos o todas las columnas están vacías, False en caso contrario.
        '''
        return not bool(self.datos) or all(len(valores) == 0 for valores in self.datos.values())

    def __repr__(self) -> str:
        '''
        Método para representar el data.frame como una cadena de texto.
        Return:
            str: Representación visual del data.frame.
        '''
        filas = len(next(iter(self.datos.values()), []))
        return "\n".join(
            " | ".join(f"{self.datos[col][fila]}" for col in self.datos)
            for fila in range(filas)
        )
    
    def escribir_a_csv(self, ruta_archivo: str) -> None:
        '''
        Método para escribir el data.frame en un archivo CSV.
        Parameters:
            ruta_archivo: (str) Ruta donde se guardará el archivo CSV.
        Return:
            None
        '''
        with open(ruta_archivo, 'w') as archivo:
            archivo.write(','.join(self.datos.keys()) + '\n')
            filas = len(next(iter(self.datos.values()), []))
            for fila in range(filas):
                archivo.write(','.join(str(self.datos[col][fila]) for col in self.datos) + '\n')

    @classmethod
    def leer_desde_csv(cls, ruta_archivo: str) -> "DataFrame":
        '''
        Método de clase para leer un archivo CSV y crear un data.frame personalizado.
        Parameters:
            ruta_archivo: (str) Ruta del archivo CSV a leer.
        Return:
            DataFramePersonalizado: Nueva instancia de la clase con datos cargados desde el CSV.
        '''
        with open(ruta_archivo, 'r') as archivo:
            lineas = archivo.readlines()
            encabezados = lineas[0].strip().split(',')
            datos = {encabezado: [] for encabezado in encabezados}
            for linea in lineas[1:]:
                valores = linea.strip().split(',')
                for encabezado, valor in zip(encabezados, valores):
                    datos[encabezado].append(cls._convertir_tipo(valor))
            return cls(datos)

    def escribir_a_txt(self, ruta_archivo: str) -> None:
        '''
        Método para escribir el data.frame en un archivo TXT con valores separados por tabulaciones.
        Parameters:
            ruta_archivo: (str) Ruta donde se guardará el archivo TXT.
        Return:
            None
        '''
        with open(ruta_archivo, 'w') as archivo:
            archivo.write('\t'.join(self.datos.keys()) + '\n')
            filas = len(next(iter(self.datos.values()), []))
            for fila in range(filas):
                archivo.write('\t'.join(str(self.datos[col][fila]) for col in self.datos) + '\n')

    @classmethod
    def leer_desde_txt(cls, ruta_archivo: str) -> "DataFrame":
        '''
        Método de clase para leer un archivo TXT con valores separados por tabulaciones y crear un data.frame personalizado.
        Parameters:
            ruta_archivo: (str) Ruta del archivo TXT a leer.
        Return:
            DataFramePersonalizado: Nueva instancia de la clase con datos cargados desde el TXT.
        '''
        with open(ruta_archivo, 'r') as archivo:
            lineas = archivo.readlines()
            encabezados = lineas[0].strip().split('\t')
            datos = {encabezado: [] for encabezado in encabezados}
            for linea in lineas[1:]:
                valores = linea.strip().split('\t')
                for encabezado, valor in zip(encabezados, valores):
                    datos[encabezado].append(cls._convertir_tipo(valor))
            return cls(datos)

    @staticmethod
    def _convertir_tipo(valor: str) -> int | float | str:
        '''
        Método estático para convertir un valor en el tipo de dato adecuado (int, float o str).
        Parameters:
            valor: (str) Valor a convertir.
        Return:
            int | float | str: Valor convertido al tipo de dato adecuado.
        '''
        try:
            return int(valor)
        except ValueError:
            try:
                return float(valor)
            except ValueError:
                return valor
