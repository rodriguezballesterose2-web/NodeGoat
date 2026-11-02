// default app configuration
const crypto = require("crypto");

const port = process.env.PORT || 4000;
let db = process.env.MONGODB_URI || "mongodb://localhost:27017/nodegoat";

// Los secretos vienen de variables de entorno. En produccion es obligatorio
// definirlos; en desarrollo y pruebas se genera un valor aleatorio temporal.
const isProduction = (process.env.NODE_ENV || "").toLowerCase() === "production";
const secretFromEnv = (name) => {
    if (process.env[name]) {
        return process.env[name];
    }
    if (isProduction) {
        throw new Error(`Falta la variable de entorno obligatoria ${name}`);
    }
    return crypto.randomBytes(32).toString("hex");
};

module.exports = {
    port,
    db,
    cookieSecret: secretFromEnv("COOKIE_SECRET"),
    cryptoKey: secretFromEnv("CRYPTO_KEY"),
    cryptoAlgo: "aes256",
    hostName: "localhost",
    environmentalScripts: []
};
