# Data

Este directorio centraliza los datos y los scripts de carga para el proyecto.

## Estructura

- `data/mongo/`: scripts e información de MongoDB
- `data/cassandra/`: scripts e información de Cassandra
- `data/sql/`: scripts e información de SQL

## Uso general

### MongoDB

1. Iniciar el contenedor MongoDB:

```powershell
docker run --name mongo-container -d -p 27017:27017 icampo648/mongo:latest
```

2. Cargar los datos:

```powershell
mongosh --file data/mongo/mongo_inserts.js
```

3. Ver documentación adicional en `data/mongo/README.md`.

### Cassandra

1. Iniciar el contenedor Cassandra:

```powershell
docker run --name cassandraBd -d -p 9042:9042 icampo648/cassandra:latest
```

2. Cargar el script:

```powershell
cqlsh 127.0.0.1 9042 -f data/cassandra/cassandra_inserts.cql
```

3. Ver documentación adicional en `data/cassandra/README.md`.

### SQL Server

1. Iniciar el contenedor SQL Server.

- SQL Server:

```powershell
docker run --name sqlserver-db -e ACCEPT_EULA=Y -e SA_PASSWORD=YourStrong!Passw0rd -e MSSQL_DB=uberdb -p 1433:1433 -d mcr.microsoft.com/mssql/server:2022-latest
```

2. Cargar el script SQL:

- SQL Server:

```powershell
docker exec -i sqlserver-db /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P YourStrong!Passw0rd -d uberdb -i data/sql/TpUberSQL.sql
```

3. Ver documentación adicional en `data/sql/README.md`.

## Notas

- El script unificado de MongoDB se encuentra en `data/mongo/mongo_inserts.js`.
- El script de Cassandra se encuentra en `data/cassandra/cassandra_inserts.cql`.
- El script SQL principal se encuentra en `data/sql/TpUberSQL.sql`.
- La API está configurada para SQL Server; ajusta si usas otro RDBMS.
