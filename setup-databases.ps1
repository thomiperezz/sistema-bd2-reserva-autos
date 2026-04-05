param(
    [switch]$All,
    [switch]$Mongo,
    [switch]$Cassandra,
    [switch]$SqlServer,
    [switch]$MySQL
)

function Test-Docker {
    try {
        docker version | Out-Null
        return $true
    } catch {
        Write-Error 'Docker no está disponible. Asegurate de que Docker esté instalado y en ejecución.'
        return $false
    }
}

function Get-ContainerExists {
    param([string]$Name)
    $containers = docker ps -a --format '{{.Names}}'
    return $containers -contains $Name
}

function Start-Or-Create-Container {
    param(
        [string]$Name,
        [string]$CreateCommand
    )

    if (Get-ContainerExists -Name $Name) {
        Write-Host "El contenedor '$Name' ya existe. Iniciando si está detenido..."
        docker start $Name | Out-Null
    } else {
        Write-Host "Creando y ejecutando el contenedor '$Name'..."
        Invoke-Expression $CreateCommand
    }
}

function Load-MongoData {
    Write-Host 'Cargando datos en MongoDB...'
    docker cp .\data\mongo\mongo_inserts.js mongo-container:/tmp/mongo_inserts.js
    docker exec mongo-container mongosh /tmp/mongo_inserts.js
}

function Load-CassandraData {
    Write-Host 'Cargando datos en Cassandra...'
    docker cp .\data\cassandra\cassandra_inserts.cql cassandraBd:/tmp/cassandra_inserts.cql
    docker exec cassandraBd cqlsh 127.0.0.1 9042 -f /tmp/cassandra_inserts.cql
}

function Load-SqlServerData {
    Write-Host 'Cargando datos en SQL Server...'
    docker cp .\data\sql\TpUberSQL.sql sqlserver-db:/tmp/TpUberSQL.sql
    docker exec sqlserver-db /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P YourStrong!Passw0rd -d uberdb -i /tmp/TpUberSQL.sql
}

function Load-MySQLData {
    Write-Host 'Cargando datos en MySQL...'
    docker exec -i mysql-db mysql -uroot -proot uberdb < .\data\sql\TpUberSQL.sql
}

if (-not ($All -or $Mongo -or $Cassandra -or $SqlServer -or $MySQL)) {
    $All = $true
}

if (-not (Test-Docker)) {
    exit 1
}

if ($All -or $Mongo) {
    Start-Or-Create-Container -Name 'mongo-container' -CreateCommand 'docker run --name mongo-container -d -p 27017:27017 icampo648/mongo:latest'
    Load-MongoData
}

if ($All -or $Cassandra) {
    Start-Or-Create-Container -Name 'cassandraBd' -CreateCommand 'docker run --name cassandraBd -d -p 9042:9042 icampo648/cassandra:latest'
    Load-CassandraData
}

if ($All -or $SqlServer) {
    Start-Or-Create-Container -Name 'sqlserver-db' -CreateCommand 'docker run --name sqlserver-db -e ACCEPT_EULA=Y -e SA_PASSWORD=YourStrong!Passw0rd -e MSSQL_DB=uberdb -p 1433:1433 -d mcr.microsoft.com/mssql/server:2022-latest'
    Load-SqlServerData
}

if ($All -or $MySQL) {
    Start-Or-Create-Container -Name 'mysql-db' -CreateCommand 'docker run --name mysql-db -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=uberdb -p 3306:3306 -d mysql:latest'
    Load-MySQLData
}

Write-Host 'Proceso finalizado.'
