const _ = require("underscore");
const path = require("path");
const util = require("util");

const finalEnv = process.env.NODE_ENV || "development";

const allConf = require(path.resolve(__dirname + "/../config/env/all.js"));
const envConf = require(path.resolve(__dirname + "/../config/env/" + finalEnv.toLowerCase() + ".js")) || {};

const config = { ...allConf, ...envConf };

// No se imprimen secretos ni la cadena de conexion (lleva la contrasena de la base de datos)
const hidden = ["db", "cookieSecret", "cryptoKey", "zapApiKey"];
const safeConfig = Object.fromEntries(
    Object.entries(config).map(([key, value]) => [key, hidden.includes(key) ? "[oculto]" : value])
);

console.log(`Current Config:`);
console.log(util.inspect(safeConfig, false, null));

module.exports = config;
