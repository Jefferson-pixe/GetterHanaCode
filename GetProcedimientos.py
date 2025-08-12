from hdbcli import dbapi
import json
import os
import socket
import subprocess
import datetime

# ==== CONFIGURACIÓN DE CONEXIÓN ====
host = '192.168.3.242'
puerto = 30015
usuario = 'B1USER'
contraseña = 'SAPB1Admin'

# ==== FUNCIONES DE UTILIDAD ====
def leer_json(file):
<<<<<<< HEAD
    """Lee un archivo JSON y retorna su contenido."""
    try:
        with open(file, 'r', encoding='utf-8') as contenido:
            return json.load(contenido)
=======
    try:
        with open(file, 'r', encoding='utf-8') as contenido:
            datos = json.load(contenido)
        return datos
>>>>>>> cfde5ea7bdcddc148837e5fd63715ac49e721dac
    except FileNotFoundError:
        raise FileNotFoundError(f"❌ No se encontró el archivo JSON en la ruta: {file}")
    except json.JSONDecodeError as e:
        raise ValueError(f"❌ El archivo JSON tiene un formato inválido: {e}")
<<<<<<< HEAD
=======

# ==== FUNCIÓN PARA PROBAR CONEXIÓN DE RED ====
def probar_puerto(host, puerto):
    try:
        sock = socket.create_connection((host, puerto), timeout=5)
        sock.close()
        return True
    except Exception as e:
        print(f"❌ No se puede conectar a {host}:{puerto} - {e}")
        return False

# ==== FUNCIÓN PARA EJECUTAR COMANDOS GIT ====
def ejecutar_git(comando):
    resultado = subprocess.run(comando, shell=True, text=True, capture_output=True)
    if resultado.returncode != 0:
        print(f"❌ Error ejecutando '{comando}': {resultado.stderr}")
    else:
        print(f"✅ Ejecutado: {comando}")

# ==== FUNCIÓN PARA HACER COMMIT AUTOMÁTICO ====
def commit_automatico():
    # Verificar si hay cambios
    cambios = subprocess.run("git status --porcelain", shell=True, text=True, capture_output=True)
    if cambios.stdout.strip() == "":
        print("📭 No hay cambios para commitear.")
        return

    ejecutar_git("git add .")
    mensaje = f"Actualización automática SPs {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}"
    ejecutar_git(f'git commit -m "{mensaje}"')
    ejecutar_git("git push origin main")  # Cambia 'main' si tu rama se llama diferente
>>>>>>> cfde5ea7bdcddc148837e5fd63715ac49e721dac

def probar_puerto(host, puerto):
    """Verifica si el puerto está accesible antes de conectar."""
    try:
        sock = socket.create_connection((host, puerto), timeout=5)
        sock.close()
        return True
    except Exception as e:
        print(f"❌ No se puede conectar a {host}:{puerto} - {e}")
        return False

# ==== FUNCIONES GIT ====
def ejecutar_git(comando):
    """Ejecuta un comando Git y muestra el resultado."""
    resultado = subprocess.run(comando, shell=True, text=True, capture_output=True)
    if resultado.returncode != 0:
        print(f"❌ Error ejecutando '{comando}': {resultado.stderr}")
    else:
        print(f"✅ Ejecutado: {comando}")

def commit_automatico():
    """Realiza commit y push automático subiendo TODOS los SP."""
    # Forzar actualización de fecha en todos los SP para que git los detecte siempre
    for root, _, files in os.walk(carpeta_destino):
        for file in files:
            ruta = os.path.join(root, file)
            os.utime(ruta, None)  # Actualiza fecha de modificación

    ejecutar_git("git add --all")  # Incluye nuevos, modificados y eliminados

    mensaje = f"Actualización automática SPs {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}"
    ejecutar_git(f'git commit -m "{mensaje}"')

    # Traer cambios remotos antes de subir para evitar conflictos
    #ejecutar_git("git pull --rebase origin main")

    ejecutar_git("git push origin main")  # Cambia si tu rama no es 'main'

# ==== BLOQUE PRINCIPAL: EXTRACCIÓN Y CREACIÓN DE SPs ====
try:
<<<<<<< HEAD
=======
    # Carpeta raíz para guardar SPs
>>>>>>> cfde5ea7bdcddc148837e5fd63715ac49e721dac
    carpeta_destino = r'C:\GetterHanaCode\GetterHanaCode'
    os.makedirs(carpeta_destino, exist_ok=True)

    # Verificación de escritura
    archivo_prueba = os.path.join(carpeta_destino, 'test.txt')
    with open(archivo_prueba, 'w', encoding='utf-8') as f:
        f.write("Prueba de escritura fuera del entorno virtual.")
    print(f"✅ Verificación de permisos: se puede escribir en {carpeta_destino}")
    os.remove(archivo_prueba)

    # Probar conexión de red antes de conectar a HANA
    if not probar_puerto(host, puerto):
        raise ConnectionError("No hay acceso de red al servidor SAP HANA. Revisa firewall o VPN.")

    # Conexión a la base de datos
    try:
        conexion = dbapi.connect(
            address=host,
            port=puerto,
            user=usuario,
            password=contraseña
        )
        cursor = conexion.cursor()
        print("✅ Conexión establecida con SAP HANA.")
    except Exception as e:
        raise ConnectionError(f"❌ Error al conectar a SAP HANA: {e}")

    # Leer archivo config.json
    archivo_config = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'config.json')
    empresas = leer_json(archivo_config)

<<<<<<< HEAD
    # Para guardar SP que cambiaron
    sp_cambiados = []

=======
    # Recorrer cada empresa
>>>>>>> cfde5ea7bdcddc148837e5fd63715ac49e721dac
    print("📌 Inicio lectura de empresas...")
    for empresa in empresas:
        esquema = empresa['SCHEMA']
        procedures = empresa['PROCEDURES']
        lista_procedures = "','".join(procedures)

<<<<<<< HEAD
        carpeta_empresa = os.path.join(carpeta_destino, esquema)
        os.makedirs(carpeta_empresa, exist_ok=True)

=======
        # Crear carpeta para el esquema
        carpeta_empresa = os.path.join(carpeta_destino, esquema)
        os.makedirs(carpeta_empresa, exist_ok=True)

        # Consulta para obtener procedimientos
>>>>>>> cfde5ea7bdcddc148837e5fd63715ac49e721dac
        sql = f"""
        SELECT SCHEMA_NAME, PROCEDURE_NAME, DEFINITION 
        FROM SYS.PROCEDURES 
        WHERE SCHEMA_NAME = '{esquema}'  
        AND PROCEDURE_NAME IN ('{lista_procedures}')
        """

        try:
            cursor.execute(sql)
            resultados = cursor.fetchall()

            if not resultados:
                print(f"⚠ No se encontraron procedimientos para el esquema {esquema}.")
                continue

<<<<<<< HEAD
            for schema_name, proc_name, definition in resultados:
                nombre_archivo = f"{schema_name}_{proc_name}.sql"
                ruta_guardado = os.path.join(carpeta_empresa, nombre_archivo)

                # Revisar si hubo cambio
                contenido_anterior = None
                if os.path.exists(ruta_guardado):
                    with open(ruta_guardado, "r", encoding="utf-8") as f:
                        contenido_anterior = f.read()

                if contenido_anterior != definition:
                    with open(ruta_guardado, "w", encoding="utf-8") as archivo_sql:
                        archivo_sql.write(definition)
                    sp_cambiados.append(f"{schema_name}.{proc_name}")

=======
            # Guardar cada procedimiento
            for schema_name, proc_name, definition in resultados:
                name_archivo = f"{schema_name}_{proc_name}.sql"
                ruta_guardado = os.path.join(carpeta_empresa, name_archivo)
                with open(ruta_guardado, "w", encoding="utf-8") as archivo_sql:
                    archivo_sql.write(definition)
>>>>>>> cfde5ea7bdcddc148837e5fd63715ac49e721dac
            print(f"✅ Procedimientos guardados para {esquema}.")

        except Exception as e:
            print(f"❌ Error ejecutando la consulta para el esquema {esquema}: {e}")

    cursor.close()
    conexion.close()
    print("🏁 Proceso finalizado correctamente.")

<<<<<<< HEAD
    # Mostrar resumen de cambios
    if sp_cambiados:
        print("🔔 Cambios detectados en los siguientes SP:")
        for sp in sp_cambiados:
            print(f"   - {sp}")
    else:
        print("📭 No se detectaron cambios en ningún SP.")

    # Siempre hacer commit automático de todos los SP
=======
    # Commit automático a GitHub
>>>>>>> cfde5ea7bdcddc148837e5fd63715ac49e721dac
    commit_automatico()

except Exception as e:
    print("❌ Error general:", e)
