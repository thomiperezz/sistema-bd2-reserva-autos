# MongoDB Data

Este directorio contiene los scripts de MongoDB para el proyecto.

## Archivos

- `mongo_inserts.js`: Script unificado de inserción de datos para MongoDB.

## Uso

1. Iniciar MongoDB en Docker:

```powershell
docker run --name mongo-container -d -p 27017:27017 icampo648/mongo:latest
```

2. Cargar los datos:

```powershell
mongosh --file data/mongo/mongo_inserts.js
```
