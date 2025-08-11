from hdbcli import dbapi
import json
import os

# ==== CONFIGURACIÓN DE CONEXIÓN ====
host = '192.168.3.242'
puerto = 30015
usuario = 'B1USER'
contraseña = 'SAPB1Admin'

# ==== FUNCIÓN PARA LEER ARCHIVO JSON ====
def leer_json(file):
    with open(file, 'r', encoding='utf-8') as contenido:
        datos = json.load(contenido)
    return datos

try:
    # Verificar si se puede escribir en la carpeta C:\GetterHanaCode
    carpeta_destino = 'C:\\GetterHanaCode'
    os.makedirs(carpeta_destino, exist_ok=True)
    archivo_prueba = os.path.join(carpeta_destino, 'test.txt')
    with open(archivo_prueba, 'w', encoding='utf-8') as f:
        f.write("Prueba de escritura fuera del entorno virtual.")
    print(f"✅ Verificación exitosa: se puede escribir en {carpeta_destino}")
    
    # Eliminar archivo de prueba
    os.remove(archivo_prueba)

    # Conexión a la base de datos
    conexion = dbapi.connect(
        address=host,
        port=puerto,
        user=usuario,
        password=contraseña
    )
    cursor = conexion.cursor()
    print("Conexion establecida")

    # Leer archivo config.json
    archivo = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'config.json')
    empresas = leer_json(archivo)

    # Recorrer cada empresa del archivo JSON
    print("Inicio lectura de empresas")
    for empresa in empresas:
        esquema = empresa['SCHEMA']
        procedures = empresa['PROCEDURES']
        lista_procedures = "','".join(procedures)

        # Consulta para obtener los procedimientos específicos
        sql = f"""
        SELECT SCHEMA_NAME, PROCEDURE_NAME, DEFINITION 
        FROM SYS.PROCEDURES 
        WHERE SCHEMA_NAME = '{esquema}'  
        AND PROCEDURE_NAME IN ('{lista_procedures}')
        """
        
        cursor.execute(sql)
        resultados = cursor.fetchall()

        # Guardar cada procedimiento en un archivo .sql
        for fila in resultados:
            name_archivo = f"{fila['SCHEMA_NAME']}_{fila['PROCEDURE_NAME']}.sql"
            contenido = fila['DEFINITION']
            ruta_guardado = os.path.join(carpeta_destino, name_archivo)

            with open(ruta_guardado, "w", encoding="utf-8") as archivo_sql:
                archivo_sql.write(contenido)

    print("✅ Archivos creados correctamente.")
    cursor.close()
    conexion.close()

except Exception as e:
    print("❌ Error durante la conexión o procesamiento:", e)
