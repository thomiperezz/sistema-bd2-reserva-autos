import pyodbc
from flask import Flask, jsonify, request
from cassandra.cluster import Cluster
from cassandra.query import SimpleStatement
from pymongo import MongoClient
from bson import ObjectId
from datetime import datetime, timedelta

app = Flask(__name__)

#===========================================
# CONFIGURACIONES DE CONEXIÓN
#===========================================

#Variables para conectarse a mongodb
client = MongoClient("mongodb://localhost:27017/")
db = client["uber"]

#Metodo para pasar de obj a string
def objectid_to_str(obj):
    if isinstance(obj, ObjectId):
        return str(obj)
    raise TypeError(f"Object of type {obj} is not serializable")

#Conexion con SQL
def get_db_connection():
    conn = pyodbc.connect(
        'DRIVER={ODBC Driver 17 for SQL Server};'
        'SERVER=.;'
        'DATABASE=Practicas;'
        'Trusted_Connection=yes;'
    )
    return conn

#Conexion con cassandra
def get_cassandra_connection():
    cluster = Cluster(['localhost'], port=9042)
    session = cluster.connect()
    session.set_keyspace('cassandratp')
    return session

#===========================================
# ENDPOINTS GET - SQL SERVER
#===========================================

#¿Cual es el top 3 de usuarios que han dado mas reseñas? 
@app.route('/users/top3', methods=['GET'])
def obtener_top_usuarios():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""SELECT TOP 3 id_usuario, COUNT(*) AS total_reseñas
                        FROM Reseña
                        GROUP BY id_usuario
                        ORDER BY total_reseñas DESC;
                        """)
    rows = cursor.fetchall()


    items = []
    for row in rows:
        items.append({"id_usuario": row[0], "total_resenia": row[1]})

    conn.close()

    return jsonify(items)

#¿Cual es el metodo de pago menos utilizado en la plataforma?
@app.route('/pay-method/lessused', methods=['GET'])
def obtener_metodo_pago_menos_utilizado():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""SELECT TOP 1 metodoDePago, COUNT(*) AS total_uso
                        FROM Pago
                        GROUP BY metodoDePago
                        ORDER BY total_uso ASC;
                        """)
    rows = cursor.fetchall()

    items = []
    for row in rows:
        items.append({"metodoDePago": row[0], "total_uso": row[1]})

    conn.close()

    return jsonify(items)

#¿Cuales son los conductores que han estado inactivos en el ultimo mes? 
@app.route('/drivers/inactive', methods=['GET'])
def obtener_conductores_inactivos():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("""SELECT c.id_conductor, c.nombre
                        FROM Conductor c
                        WHERE c.id_conductor NOT IN (
                            SELECT id_conductor
                            FROM Viaje
                            WHERE fecha_hora_final >= DATEADD(DAY, -30, GETDATE()));"""
                        )
    rows = cursor.fetchall()

    items = []
    for row in rows:
        items.append({"id_conductor": row[0], "nombre": row[1]})

    conn.close()
    
    return jsonify(items)

#¿Que conductores y pasajeros han coincidido en mas de 1 viaje en la aplicacion? 
@app.route('/coincidencias', methods=['GET'])
def obtener_viajes_comunes():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""SELECT 
                        v.id_conductor, v.id_usuario, COUNT(v.id_viaje) AS total_viajes 
                        FROM  Viaje v
                        GROUP BY v.id_conductor, v.id_usuario
                        HAVING COUNT(v.id_viaje) > 1;
                        """)
    rows = cursor.fetchall()

    items = []
    for row in rows:
        items.append({"id_coductor": row[0], "id_usuario": row[1], "total_viajes": row[2]})

    conn.close()
    
    return jsonify(items)

#¿Cuantos autos con terminacion de patente en "D" y de Marca Toyota hay en la plataforma? 
@app.route('/cars/toyota', methods=['GET'])
def obtener_autos_toyota():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""SELECT COUNT(*) AS total_veiculos
                        FROM Veiculo
                        WHERE marca = 'Toyota' AND patente LIKE '%D';
                        """)
    rows = cursor.fetchall()

    items = []
    for row in rows:
        items.append({"total Toyotas con D": row[0]})

    conn.close()
    
    return jsonify(items)

#¿Cuales son los usuarios que han dado una calificacion de 5 o una calificacion menor de 2? 
@app.route('/users/fivestars', methods=['GET'])
def obtener_usuarios_calificaciones():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""SELECT DISTINCT id_usuario
                        FROM Reseña
                        WHERE calificacion = 5 OR calificacion <= 2;
                        """)
    rows = cursor.fetchall()

    items = []
    for row in rows:
        items.append({"id_usuario": row[0]})

    conn.close()
    
    return jsonify(items)

#¿Cual es el tiempo promedio de los viajes? 
@app.route('/travels/avgtime', methods=['GET'])
def obtener_tiempo_promedio():
    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""SELECT 
                        CONVERT(VARCHAR, DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', tiempo_viaje)), '00:00:00'), 108) AS TiempoPromedio
                        FROM Viaje;
                        """)
    rows = cursor.fetchall()

    items = []
    for row in rows:
        items.append({"Tiempo_promedio": row[0]})

    conn.close()
    
    return jsonify(items)

#===========================================
# ENDPOINTS GET - MONGODB
#===========================================

#¿Cual es el top 3 de usuarios que han dado mas reseñas? 
@app.route('/mongo/users/top3', methods=['GET'])
def mongo_obtener_top_usuarios():
    pipeline = [
        {"$project": {"nombre": 1, "apellido": 1, "email": 1, "cantidad_reseñas": {"$size": "$reseñasDadas"}}},
        {"$sort": {"cantidad_reseñas": -1}},
        {"$limit": 3}
    ]
    usuarios = list(db.usuarios.aggregate(pipeline))
    for usuario in usuarios:
        usuario["_id"] = objectid_to_str(usuario["_id"])
    
    return jsonify(usuarios)

#¿Cual es el metodo de pago menos utilizado en la plataforma?
@app.route('/mongo/pay-method/lessused', methods=['GET'])
def mongo_obtener_metodo_pago_menos_utilizado():
    pipeline = [
        {"$unwind": "$pagos"},
        {"$group": {"_id": "$pagos.metodoDePago", "cantidad": {"$sum": 1}}},
        {"$sort": {"cantidad": 1}},
        {"$limit": 1}
    ]
    resultado = list(db.usuarios.aggregate(pipeline))
    return jsonify(resultado)

#¿Cuales son los conductores que han estado inactivos en el ultimo mes? 
@app.route('/mongo/drivers/inactive', methods=['GET'])
def mongo_obtener_conductores_inactivos():
    fecha_limite = datetime.now() - timedelta(days=30)
    pipeline = [
        {"$match": {"ultima_actividad": {"$lt": fecha_limite}}},
        {"$project": {"nombre": 1, "apellido": 1, "ultima_actividad": 1}}
    ]
    conductores_inactivos = list(db.conductores.aggregate(pipeline))

    for conductor in conductores_inactivos:
        conductor["_id"]= objectid_to_str(conductor["_id"])

    return jsonify(conductores_inactivos)

#¿Que conductores y pasajeros han coincidido en mas de 1 viaje en la aplicacion? 
@app.route('/mongo/coincidencias', methods=['GET'])
def mongo_obtener_viajes_comunes():
    pipeline = [
        {"$lookup": {
            "from": "usuarios", 
            "localField": "_id",
            "foreignField": "reseñasDadas.id_viaje",
            "as": "pasajeros"
        }},
        
        {"$unwind": "$pasajeros"}, 
        {"$group": {
            "_id": {
                "conductor": "$id_conductor", 
                "pasajero": "$pasajeros._id" 
            },
            "viajes_comunes": {"$sum": 1} 
        }},
        
        {"$match": {"viajes_comunes": {"$gt": 1}}},
        
        {"$lookup": {
            "from": "conductores", 
            "localField": "_id.conductor",
            "foreignField": "_id",
            "as": "conductor_info"
        }},
        
        {"$lookup": {
            "from": "usuarios",
            "localField": "_id.pasajero",
            "foreignField": "_id",
            "as": "pasajero_info"
        }},
        
        {"$project": {
            "conductor": {"$arrayElemAt": ["$conductor_info.nombre", 0]},  
            "pasajero": {"$arrayElemAt": ["$pasajero_info.nombre", 0]}, 
            "viajes_comunes": 1  
        }}
    ]
    

    coincidencias = list(db.viajes.aggregate(pipeline))
    
    for coincidencia in coincidencias:
        if "_id" in coincidencia and "conductor" in coincidencia["_id"]:
            coincidencia["_id"]["conductor"] = objectid_to_str(coincidencia["_id"]["conductor"])
        if "_id" in coincidencia and "pasajero" in coincidencia["_id"]:
            coincidencia["_id"]["pasajero"] = objectid_to_str(coincidencia["_id"]["pasajero"])

    return jsonify(coincidencias)

#¿Cuales son los usuarios que han dado una calificacion de 5 o una calificacion menor de 2? 
@app.route('/mongo/users/stars', methods=['GET'])
def mongo_obtener_usuarios_calificaciones():
    pipeline = [
        {"$unwind": "$reseñasDadas"},
        {"$match": {"$or": [{"reseñasDadas.calificacion": 5}, {"reseñasDadas.calificacion": {"$lte": 2}}]}},
        {"$project": {"nombre": 1, "apellido": 1, "email": 1, "reseñasDadas.calificacion": 1}}
    ]
    usuarios = list(db.usuarios.aggregate(pipeline))

    for usuario in usuarios:
        usuario["_id"] = objectid_to_str(usuario["_id"])
    
    return jsonify(usuarios)

#¿Cual es el tiempo promedio de los viajes? 
@app.route('/mongo/travels/avgtime', methods=['GET'])
def mongo_obtener_tiempo_promedio():
    pipeline = [
        {"$group": {"_id": None, "tiempo_promedio": {"$avg": "$tiempo_viaje"}}}
    ]
    resultado = list(db.viajes.aggregate(pipeline))
    return jsonify(resultado)

#===========================================
# ENDPOINTS GET - CASSANDRA
#===========================================

#¿Cuantos autos con terminacion de patente en "D" y de Marca Toyota hay en la plataforma? 
@app.route('/cassandra/cars/toyota', methods=['GET'])
def cassandra_obtener_autos_toyota():
    session = get_cassandra_connection()

    query = SimpleStatement("""SELECT * FROM Vehiculos                                                                                    
                                 WHERE marca = 'Toyota' AND ultima_letra_patente = 'D';""")
    rows = session.execute(query)

    reseñas = []
    for row in rows:
        reseñas.append({
            'id_vehiculo': row.id_vehiculo,
            'modelo': row.modelo,
            'patente': row.patente
        })

    return jsonify(reseñas)

#¿Cuales son los usuarios que han dado una calificacion de 5 o una calificacion menor de 2? 
@app.route('/cassandra/users/stars', methods=['GET'])
def cassandra_obtener_usuarios_calificaciones():
    session = get_cassandra_connection()

    query = SimpleStatement("""
        SELECT *
        FROM resenas 
        WHERE calificacion IN (1,5);
    """)
    
    rows = session.execute(query)

    usuarios = []
    for row in rows:
        usuarios.append({
            'id_usuario': row.id_usuario,
            'calificacion': row.calificacion
        })

    return jsonify(usuarios)

#===========================================
# ENDPOINTS POST - MONGODB
#===========================================

@app.route('/mongo/conductores', methods=['POST'])
def mongo_insertar_conductor():
    try:
        datos = request.get_json()
        
        conductor = {
            "nombre": datos["nombre"],
            "apellido": datos["apellido"],
            "licencia": datos["licencia"],
            "telefono": datos["telefono"],
            "email": datos["email"],
            "ultima_actividad": datetime.now()
        }
        
        resultado = db.conductores.insert_one(conductor)
        return jsonify({"mensaje": "Conductor insertado exitosamente", "id": str(resultado.inserted_id)}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 400

"""
Body request ejemplo:
{
    "nombre": "Juan",
    "apellido": "Pérez",
    "licencia": "ABC123",
    "telefono": "1234567890",
    "email": "juan.perez@email.com"
}
"""

@app.route('/mongo/usuarios', methods=['POST'])
def mongo_insertar_usuario():
    try:
        datos = request.get_json()
        
        usuario = {
            "nombre": datos["nombre"],
            "apellido": datos["apellido"],
            "email": datos["email"],
            "telefono": datos["telefono"],
            "reseñasDadas": datos.get("reseñasDadas", []),
            "pagos": datos.get("pagos", [])
        }
        
        # Convertir las fechas de string a datetime si existen
        for reseña in usuario["reseñasDadas"]:
            if "fecha" in reseña:
                reseña["fecha"] = datetime.fromisoformat(reseña["fecha"].replace("Z", "+00:00"))
        
        for pago in usuario["pagos"]:
            if "fechaPago" in pago:
                pago["fechaPago"] = datetime.fromisoformat(pago["fechaPago"].replace("Z", "+00:00"))
        
        resultado = db.usuarios.insert_one(usuario)
        return jsonify({"mensaje": "Usuario insertado exitosamente", "id": str(resultado.inserted_id)}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 400

"""
Body request ejemplo:
{
    "nombre": "María",
    "apellido": "González",
    "email": "maria.gonzalez@email.com",
    "telefono": "0987654321",
    "reseñasDadas": [
        {
            "id_viaje": "507f1f77bcf86cd799439011",
            "calificacion": 5,
            "comentario": "Excelente servicio",
            "fecha": "2024-03-20T15:30:00Z"
        }
    ],
    "pagos": [
        {
            "id_viaje": "507f1f77bcf86cd799439011",
            "fechaPago": "2024-03-20T15:35:00Z",
            "total": 1500,
            "estado": "completado",
            "metodoDePago": "Tarjeta"
        }
    ]
}
"""

@app.route('/mongo/vehiculos', methods=['POST'])
def mongo_insertar_vehiculo():
    try:
        datos = request.get_json()
        
        # Buscar conductor por email o licencia
        conductor = db.conductores.find_one({
            "$or": [
                {"email": datos.get("email_conductor")},
                {"licencia": datos.get("licencia_conductor")}
            ]
        })
        
        if not conductor:
            return jsonify({"error": "Conductor no encontrado"}), 404
        
        vehiculo = {
            "id_conductor": conductor["_id"],
            "marca": datos["marca"],
            "patente": datos["patente"],
            "modelo": datos["modelo"],
            "año": datos["año"],
            "color": datos["color"],
            "ubicaion": datos["ubicacion"]
        }
        
        resultado = db.vehiculos.insert_one(vehiculo)
        return jsonify({
            "mensaje": "Vehículo insertado exitosamente",
            "id": str(resultado.inserted_id),
            "conductor": conductor["nombre"] + " " + conductor["apellido"]
        }), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 400

"""
Body request ejemplo:
{
    "email_conductor": "juan.perez@email.com",
    "marca": "Toyota",
    "patente": "ABC123",
    "modelo": "Corolla",
    "año": 2020,
    "color": "Rojo",
    "ubicacion": "Buenos Aires"
}
"""

@app.route('/mongo/viajes', methods=['POST'])
def mongo_insertar_viaje():
    try:
        datos = request.get_json()
        
        # Buscar conductor por email o licencia
        conductor = db.conductores.find_one({
            "$or": [
                {"email": datos.get("email_conductor")},
                {"licencia": datos.get("licencia_conductor")}
            ]
        })
        
        if not conductor:
            return jsonify({"error": "Conductor no encontrado"}), 404
            
        # Buscar vehículo por patente
        vehiculo = db.vehiculos.find_one({
            "patente": datos.get("patente_vehiculo")
        })
        
        if not vehiculo:
            return jsonify({"error": "Vehículo no encontrado"}), 404

        # Buscar usuario por email
        usuario = db.usuarios.find_one({"email": datos.get("email_usuario")})
        if not usuario:
            return jsonify({"error": "Usuario no encontrado"}), 404
            
        # Validar método de pago si existe
        if datos.get("pago"):
            metodos_pago_validos = ["Tarjeta", "Efectivo", "Transferencia", "Mercado Pago"]
            if datos["pago"]["metodoDePago"] not in metodos_pago_validos:
                return jsonify({"error": "Método de pago no válido"}), 400
        
        # Crear el viaje
        viaje = {
            "id_conductor": conductor["_id"],
            "id_vehiculo": vehiculo["_id"],
            "id_usuario": usuario["_id"],
            "punto_partida": datos["punto_partida"],
            "destino": datos["destino"],
            "distancia": datos["distancia"],
            "tiempo_viaje": datos["tiempo_viaje"],
            "estado": datos["estado"],
            "fecha_hora_inicio": datetime.fromisoformat(datos["fecha_hora_inicio"].replace("Z", "+00:00")),
            "fecha_hora_final": datetime.fromisoformat(datos["fecha_hora_final"].replace("Z", "+00:00"))
        }
        
        # Insertar el viaje
        resultado_viaje = db.viajes.insert_one(viaje)
        
        # Si hay información de pago, crear y vincular el pago
        if datos.get("pago"):
            nuevo_pago = {
                "id_viaje": resultado_viaje.inserted_id,
                "fechaPago": datetime.fromisoformat(datos["pago"]["fechaPago"].replace("Z", "+00:00")),
                "total": datos["pago"]["total"],
                "estado": datos["pago"]["estado"],
                "metodoDePago": datos["pago"]["metodoDePago"]
            }
            
            # Agregar el pago al usuario
            db.usuarios.update_one(
                {"_id": usuario["_id"]},
                {"$push": {"pagos": nuevo_pago}}
            )
        
        # Si hay información de reseña, crear y vincular la reseña
        if datos.get("reseña"):
            nueva_resena = {
                "id_viaje": resultado_viaje.inserted_id,
                "calificacion": datos["reseña"]["calificacion"],
                "comentario": datos["reseña"]["comentario"],
                "fecha": datetime.fromisoformat(datos["reseña"]["fecha"].replace("Z", "+00:00"))
            }
            
            # Agregar la reseña al usuario
            db.usuarios.update_one(
                {"_id": usuario["_id"]},
                {"$push": {"reseñasDadas": nueva_resena}}
            )
        
        return jsonify({
            "mensaje": "Viaje, pago y reseña registrados exitosamente",
            "id_viaje": str(resultado_viaje.inserted_id),
            "conductor": conductor["nombre"] + " " + conductor["apellido"],
            "usuario": usuario["nombre"] + " " + usuario["apellido"],
            "vehiculo": f"{vehiculo['marca']} {vehiculo['modelo']} ({vehiculo['patente']})"
        }), 201
            
    except Exception as e:
        return jsonify({"error": str(e)}), 400

"""
Body request ejemplo:
{
    "email_conductor": "juan.perez@email.com",
    "patente_vehiculo": "ABC123",
    "email_usuario": "maria.gonzalez@email.com",
    "punto_partida": "Av. Corrientes 1234",
    "destino": "Av. Santa Fe 5678",
    "distancia": 5.2,
    "tiempo_viaje": 15,
    "estado": "completado",
    "fecha_hora_inicio": "2024-03-20T15:00:00Z",
    "fecha_hora_final": "2024-03-20T15:15:00Z",
    "pago": {
        "fechaPago": "2024-03-20T15:16:00Z",
        "total": 1500,
        "estado": "completado",
        "metodoDePago": "Tarjeta"
    },
    "reseña": {
        "calificacion": 5,
        "comentario": "Excelente servicio",
        "fecha": "2024-03-20T15:17:00Z"
    }
}
"""

@app.route('/mongo/usuarios/resena', methods=['POST'])
def mongo_agregar_resena():
    try:
        datos = request.get_json()
        
        # Buscar usuario por email
        usuario = db.usuarios.find_one({"email": datos["email_usuario"]})
        if not usuario:
            return jsonify({"error": "Usuario no encontrado"}), 404
            
        # Verificar que el viaje existe
        viaje = db.viajes.find_one({"_id": ObjectId(datos["id_viaje"])})
        if not viaje:
            return jsonify({"error": "Viaje no encontrado"}), 404
        
        # Crear nueva reseña
        nueva_resena = {
            "id_viaje": ObjectId(datos["id_viaje"]),
            "calificacion": datos["calificacion"],
            "comentario": datos["comentario"],
            "fecha": datetime.fromisoformat(datos["fecha"].replace("Z", "+00:00"))
        }
        
        # Actualizar el documento del usuario
        resultado = db.usuarios.update_one(
            {"email": datos["email_usuario"]},
            {"$push": {"reseñasDadas": nueva_resena}}
        )
        
        if resultado.modified_count > 0:
            return jsonify({
                "mensaje": "Reseña agregada exitosamente",
                "usuario": usuario["nombre"] + " " + usuario["apellido"],
                "calificacion": datos["calificacion"]
            }), 201
        else:
            return jsonify({"error": "No se pudo agregar la reseña"}), 400
            
    except Exception as e:
        return jsonify({"error": str(e)}), 400

"""
Body request ejemplo:
{
    "email_usuario": "maria.gonzalez@email.com",
    "id_viaje": "507f1f77bcf86cd799439011",
    "calificacion": 5,
    "comentario": "Excelente servicio",
    "fecha": "2024-03-20T15:30:00Z"
}
"""

@app.route('/mongo/usuarios/pago', methods=['POST'])
def mongo_agregar_pago():
    try:
        datos = request.get_json()
        
        # Buscar usuario por email
        usuario = db.usuarios.find_one({"email": datos["email_usuario"]})
        if not usuario:
            return jsonify({"error": "Usuario no encontrado"}), 404
            
        # Verificar que el viaje existe
        viaje = db.viajes.find_one({"_id": ObjectId(datos["id_viaje"])})
        if not viaje:
            return jsonify({"error": "Viaje no encontrado"}), 404
        
        # Validar método de pago
        metodos_pago_validos = ["Tarjeta", "Efectivo", "Transferencia", "Mercado Pago"]
        if datos["metodoDePago"] not in metodos_pago_validos:
            return jsonify({"error": "Método de pago no válido"}), 400
        
        # Crear nuevo pago
        nuevo_pago = {
            "id_viaje": ObjectId(datos["id_viaje"]),
            "fechaPago": datetime.fromisoformat(datos["fechaPago"].replace("Z", "+00:00")),
            "total": datos["total"],
            "estado": datos["estado"],
            "metodoDePago": datos["metodoDePago"]
        }
        
        # Actualizar el documento del usuario
        resultado = db.usuarios.update_one(
            {"email": datos["email_usuario"]},
            {"$push": {"pagos": nuevo_pago}}
        )
        
        if resultado.modified_count > 0:
            return jsonify({
                "mensaje": "Pago registrado exitosamente",
                "usuario": usuario["nombre"] + " " + usuario["apellido"],
                "total": datos["total"],
                "metodoDePago": datos["metodoDePago"]
            }), 201
        else:
            return jsonify({"error": "No se pudo registrar el pago"}), 400
            
    except Exception as e:
        return jsonify({"error": str(e)}), 400

"""
Body request ejemplo:
{
    "email_usuario": "maria.gonzalez@email.com",
    "id_viaje": "507f1f77bcf86cd799439011",
    "fechaPago": "2024-03-20T15:35:00Z",
    "total": 1500,
    "estado": "completado",
    "metodoDePago": "Tarjeta"
}
"""

#===========================================
# ENDPOINTS POST - CASSANDRA
#===========================================

@app.route('/cassandra/resenas', methods=['POST'])
def cassandra_insertar_resena():
    try:
        session = get_cassandra_connection()
        datos = request.get_json()
        
        # Validar datos requeridos
        if not all(key in datos for key in ['id_resena', 'id_usuario', 'calificacion']):
            return jsonify({"error": "Faltan datos requeridos"}), 400
            
        # Validar que la calificación esté entre 1 y 5
        if not 1 <= datos['calificacion'] <= 5:
            return jsonify({"error": "La calificación debe estar entre 1 y 5"}), 400

        query = """
            INSERT INTO resenas (id_resena, id_usuario, calificacion)
            VALUES (%s, %s, %s)
        """
        
        session.execute(query, (
            datos['id_resena'],
            datos['id_usuario'],
            datos['calificacion']
        ))
        
        return jsonify({
            "mensaje": "Reseña insertada exitosamente",
            "datos": datos
        }), 201
        
    except Exception as e:
        return jsonify({"error": str(e)}), 400

"""
Body request ejemplo:
{
    "id_resena": 1,
    "id_usuario": 100,
    "calificacion": 5
}
"""

@app.route('/cassandra/vehiculos', methods=['POST'])
def cassandra_insertar_vehiculo():
    try:
        session = get_cassandra_connection()
        datos = request.get_json()
        
        # Validar datos requeridos
        campos_requeridos = ['id_vehiculo', 'marca', 'patente', 'modelo']
        if not all(key in datos for key in campos_requeridos):
            return jsonify({"error": "Faltan datos requeridos"}), 400
        
        # Extraer la última letra de la patente
        ultima_letra_patente = datos['patente'][-1].upper()
        
        query = """
            INSERT INTO Vehiculos (
                id_vehiculo, 
                marca, 
                ultima_letra_patente, 
                patente, 
                modelo
            )
            VALUES (%s, %s, %s, %s, %s)
        """
        
        session.execute(query, (
            datos['id_vehiculo'],
            datos['marca'],
            ultima_letra_patente,
            datos['patente'],
            datos['modelo']
        ))
        
        return jsonify({
            "mensaje": "Vehículo insertado exitosamente",
            "datos": {
                **datos,
                "ultima_letra_patente": ultima_letra_patente
            }
        }), 201
        
    except Exception as e:
        return jsonify({"error": str(e)}), 400

"""
Body request ejemplo:
{
    "id_vehiculo": 1,
    "marca": "Toyota",
    "patente": "ABC123D",
    "modelo": "Corolla"
}
"""

if __name__ == '__main__':
    app.run(debug=True)
