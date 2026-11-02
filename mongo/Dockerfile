FROM mongo:4.4.30
# Se eliminan herramientas de respaldo e importacion que la aplicacion no usa
# y gosu (solo se invoca cuando el contenedor corre como root; el compose usa user: mongodb).
# Estos binarios contienen la libreria estandar de Go con vulnerabilidades criticas.
RUN rm -f /usr/bin/bsondump /usr/bin/mongodump /usr/bin/mongoexport /usr/bin/mongofiles \
          /usr/bin/mongoimport /usr/bin/mongorestore /usr/bin/mongostat /usr/bin/mongotop \
          /usr/local/bin/gosu
USER mongodb
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD mongo --quiet --eval "quit(db.adminCommand('ping').ok === 1 ? 0 : 1)"
