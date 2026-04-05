# SQL Data

Este directorio contiene los scripts SQL del proyecto.

## Archivo

- `TpUberSQL.sql`: script SQL principal para crear la base de datos, tablas e insertar datos de ejemplo del proyecto.

## Uso

### SQL Server

1. Iniciar el contenedor SQL Server:

```powershell
docker run --name sqlserver-db -e ACCEPT_EULA=Y -e SA_PASSWORD=YourStrong!Passw0rd -e MSSQL_DB=uberdb -p 1433:1433 -d mcr.microsoft.com/mssql/server:2022-latest
```

2. Cargar el script SQL:

```powershell
docker exec -i sqlserver-db /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P YourStrong!Passw0rd -d uberdb -i data/sql/TpUberSQL.sql
```

## Notas

- Si necesitas cambiar el nombre de la base de datos, recuerda actualizar el contenedor y el script SQL.
- En SQL Server, `sqlcmd` debe poder acceder al schema `uberdb`.
- Asegúrate de que la contraseña SA cumpla con los requisitos de complejidad de SQL Server.
