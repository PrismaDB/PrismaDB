#!/bin/bash

ContainerName=prismadb_mssql_proxy
ServerAddress=prismadb_mysql_db
ServerPort=1433
Database=testdb
ListenPort=4000

while getopts n:h:p:d:l:a:s: option; do
    case "${option}" in
    n) ContainerName=${OPTARG} ;;
    h) ServerAddress=${OPTARG} ;;
    p) ServerPort=${OPTARG} ;;
    d) Database=${OPTARG} ;;
    l) ListenPort=${OPTARG} ;;
    esac
done

echo "Starting up Prisma/DB Microsoft SQL Server Proxy container '${ContainerName}' on port ${ListenPort}... "

./kill-proxy.sh ${ContainerName}

docker run -d \
    --link=${ServerAddress} \
    -p ${ListenPort}:${ListenPort} \
    -e ListenPort=${ListenPort} \
    -e DataSource=${ServerAddress},${ServerPort} \
    -e InitialCatalog=${Database} \
    --name ${ContainerName} \
    aprismatic/prismadb-proxy-mssql-trial:alpine
