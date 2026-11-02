#!/bin/bash
# Crea el usuario de la aplicacion con permisos minimos (solo readWrite en nodegoat)
mongo -u "$MONGO_INITDB_ROOT_USERNAME" -p "$MONGO_INITDB_ROOT_PASSWORD" --authenticationDatabase admin nodegoat --quiet --eval "db.createUser({user: '$APP_DB_USER', pwd: '$APP_DB_PASSWORD', roles: [{role: 'readWrite', db: 'nodegoat'}]})"
