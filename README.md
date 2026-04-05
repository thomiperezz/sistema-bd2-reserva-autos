# Sistema de Reserva de Autos (Proyecto BD2)

![Python](https://img.shields.io/badge/python-3.8+-blue.svg) ![SQL Server](https://img.shields.io/badge/SQL%20Server-2022-blue.svg) ![MongoDB](https://img.shields.io/badge/MongoDB-5.0+-green.svg) ![Cassandra](https://img.shields.io/badge/Cassandra-4.0+-green.svg) ![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)

Proyecto similar a Uber que utiliza múltiples bases de datos: SQL Server, MongoDB y Cassandra.

## Requisitos previos

- Docker y Docker Compose instalados
- Python 3.8+
- PowerShell (para scripts de automatización)

## Estructura de carpetas

- `data/mongo/`: scripts y documentación de MongoDB
- `data/cassandra/`: scripts de Cassandra
- `data/sql/`: scripts SQL
- `notebooks/`: notebooks Jupyter del proyecto
- `docs/`: diagramas y presentaciones
- `src/`: código Python del proyecto

## Archivos principales

- `data/mongo/mongo_inserts.js`: script unificado de inserción de datos para MongoDB
- `data/cassandra/cassandra_inserts.cql`: script de Cassandra
- `data/sql/TpUberSQL.sql`: script SQL principal
- `src/API-Proyecto-BD2.py`: código Python del proyecto
- `notebooks/ApiBd2Notebook.ipynb`: notebook de análisis/consulta
- `docs/Diagrama ER - TPUberSQL.jpeg`: diagrama ER
- `docs/Presentación TPO BDII.pdf`: presentación del proyecto
- `data/README.md`: guía centralizada de carga de datos

## Comandos Docker

- MongoDB:

```powershell
docker run --name mongo-container -d -p 27017:27017 icampo648/mongo:latest
```

- Cassandra:

```powershell
docker run --name cassandraBd -d -p 9042:9042 icampo648/cassandra:latest
```

- SQL Server:

```powershell
docker run --name sqlserver-db -e ACCEPT_EULA=Y -e SA_PASSWORD=YourStrong!Passw0rd -e MSSQL_DB=uberdb -p 1433:1433 -d mcr.microsoft.com/mssql/server:2022-latest
```

- MySQL (alternativa):

```powershell
docker run --name mysql-db -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=uberdb -p 3306:3306 -d mysql:latest
```

## Docker Compose

También podés usar `docker-compose` para levantar todas las bases de datos juntas.

```powershell
docker compose up -d
```

Para detener y eliminar los contenedores:

```powershell
docker compose down
```

## Cargar datos

### MongoDB

1. Iniciar el contenedor MongoDB:

```powershell
docker start mongo-container
```

2. Cargar los datos:

```powershell
mongosh --file data/mongo/mongo_inserts.js
```

### Cassandra

1. Iniciar el contenedor Cassandra:

```powershell
docker start cassandraBd
```

2. Conectarse y ejecutar el script:

```powershell
cqlsh 127.0.0.1 9042 -f data/cassandra/cassandra_inserts.cql
```

### SQL Server

1. Iniciar el contenedor SQL Server.

2. Cargar el script SQL:

```powershell
docker exec -i sqlserver-db /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P YourStrong!Passw0rd -d uberdb -i data/sql/TpUberSQL.sql
```

## Automatización

Puedes usar el script de PowerShell `setup-databases.ps1` para crear los contenedores y cargar los datos.

```powershell
.\setup-databases.ps1
```

Opciones:

- `.\setup-databases.ps1 -All`
- `.\setup-databases.ps1 -Mongo`
- `.\setup-databases.ps1 -Cassandra`
- `.\setup-databases.ps1 -SqlServer`
- `.\setup-databases.ps1 -MySQL`

## Notas

- `data/mongo/mongo_inserts.js` consolida y normaliza los inserts de `mongo.txt` e `inserts mongo.txt`.
- El archivo SQL principal está en `data/sql/TpUberSQL.sql`.
- El script de Cassandra está en `data/cassandra/cassandra_inserts.cql`.
- La API usa SQL Server por defecto; ajusta `get_db_connection()` si usas otro RDBMS.

## Instalación de dependencias

Instala las dependencias de Python:

```powershell
pip install -r requirements.txt
```

## Ejecutar la API

Una vez que las bases de datos estén corriendo y los datos cargados:

```powershell
python src/API-Proyecto-BD2.py
```

La API estará disponible en `http://localhost:5000`.

## Endpoints de la API

### SQL Server
- `GET /users/top3` - Top 3 usuarios con más reseñas
- `GET /pay-method/lessused` - Método de pago menos utilizado
- `GET /drivers/inactive` - Conductores inactivos en el último mes
- `GET /coincidencias` - Conductores y pasajeros que coincidieron en más de 1 viaje
- `GET /cars/toyota` - Autos Toyota con patente terminada en 'D'
- `GET /users/fivestars` - Usuarios con calificación 5 o menor a 2
- `GET /travels/avgtime` - Tiempo promedio de viajes

### MongoDB
- `GET /mongo/users/top3` - Top 3 usuarios con más reseñas
- `GET /mongo/pay-method/lessused` - Método de pago menos utilizado
- `GET /mongo/drivers/inactive` - Conductores inactivos
- `GET /mongo/coincidencias` - Coincidencias de viajes
- `GET /mongo/users/stars` - Usuarios por calificaciones
- `GET /mongo/travels/avgtime` - Tiempo promedio
- `POST /mongo/conductores` - Insertar conductor
- `POST /mongo/usuarios` - Insertar usuario
- `POST /mongo/vehiculos` - Insertar vehículo
- `POST /mongo/viajes` - Insertar viaje
- `POST /mongo/usuarios/resena` - Agregar reseña
- `POST /mongo/usuarios/pago` - Agregar pago

### Cassandra
- `GET /cassandra/cars/toyota` - Autos Toyota con patente terminada en 'D'
- `GET /cassandra/users/stars` - Usuarios por calificaciones
- `POST /cassandra/resenas` - Insertar reseña
- `POST /cassandra/vehiculos` - Insertar vehículo
