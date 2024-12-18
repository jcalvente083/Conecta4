import os

def borrar_archivos(directorio, extensiones):
    """
    Elimina archivos en un directorio con las extensiones especificadas.
    
    Args:
        directorio (str): La ruta del directorio donde se borrarán los archivos.
        extensiones (list): Lista de extensiones de archivo a eliminar (ejemplo: ['.o', '.hi', '.exe']).
    """
    if not os.path.exists(directorio):
        print(f"Error: El directorio '{directorio}' no existe.")
        return
    
    # Recorrer todos los archivos en el directorio
    for archivo in os.listdir(directorio):
        ruta_completa = os.path.join(directorio, archivo)

        # Verificar si es un archivo y si su extensión está en la lista
        if os.path.isfile(ruta_completa) and any(archivo.endswith(ext) for ext in extensiones):
            try:
                os.remove(ruta_completa)
                print(f"Archivo eliminado: {ruta_completa}")
            except Exception as e:
                print(f"No se pudo eliminar {ruta_completa}: {e}")

if __name__ == "__main__":
    # Configurar directorio y extensiones
    directorio_objetivo = "./"  # Ruta al directorio actual, cámbialo si es necesario
    extensiones_a_borrar = [".o", ".hi", ".txt"]

    # Ejecutar la función
    borrar_archivos(directorio_objetivo, extensiones_a_borrar)
