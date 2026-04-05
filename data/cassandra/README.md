# Cassandra Data

Este directorio contiene los scripts para Cassandra.

## Archivo

- `cassandra_inserts.cql`: script de creación e inserción de datos en Cassandra para el proyecto.

## Uso

1. Iniciar el contenedor Cassandra:

```powershell
docker run --name cassandraBd -d -p 9042:9042 icampo648/cassandra:latest
```

2. Verificar que Cassandra esté lista:

```powershell
docker logs cassandraBd --tail 20
```

3. Cargar el script desde el host:

```powershell
cqlsh 127.0.0.1 9042 -f data/cassandra/cassandra_inserts.cql
```

4. Alternativamente, ejecutar dentro del contenedor:

```powershell
docker exec -i cassandraBd cqlsh 127.0.0.1 9042 < data/cassandra/cassandra_inserts.cql
```

## Notas

- Asegúrate de que el puerto `9042` no esté ocupado.
- El keyspace utilizado es `cassandratp`.
- Si necesitas cambiar el keyspace, edita `cassandra_inserts.cql` antes de cargarlo.
