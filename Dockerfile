# Etapa 1: instalar solo dependencias de produccion
FROM node:22-alpine AS build
WORKDIR /usr/src/app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev --no-audit --no-fund

# Etapa 2: imagen final, sin privilegios
FROM node:22-alpine
ENV NODE_ENV=production
ENV USER=node
ENV WORKDIR=/home/node/app
WORKDIR $WORKDIR
COPY --from=build --chown=node:node /usr/src/app/node_modules node_modules
COPY --chown=node:node package.json package-lock.json server.js ./
COPY --chown=node:node app app
COPY --chown=node:node config config
COPY --chown=node:node artifacts artifacts
# Se elimina npm: la app arranca con node y npm de la imagen base trae vulnerabilidades
RUN rm -rf /usr/local/lib/node_modules/npm /usr/local/bin/npm /usr/local/bin/npx
USER $USER
EXPOSE 4000
HEALTHCHECK --interval=30s --timeout=5s --start-period=40s --retries=3 \
  CMD node -e "require('http').get('http://127.0.0.1:4000/login',r=>process.exit(r.statusCode<500?0:1)).on('error',()=>process.exit(1))"
