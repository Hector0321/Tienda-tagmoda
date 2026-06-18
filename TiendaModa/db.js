const mysql = require('mysql2/promise');
require('dotenv').config();

let config;

if (process.env.DATABASE_URL) {
  const dbUrl = new URL(process.env.DATABASE_URL);

  config = {
    host: dbUrl.hostname,
    user: dbUrl.username,
    password: dbUrl.password,
    database: dbUrl.pathname.replace('/', ''),
    port: Number(dbUrl.port),
    waitForConnections: true,
    connectionLimit: 10,
    charset: 'utf8mb4'
  };
} else {
  config = {
    host: process.env.MYSQLHOST || process.env.DB_HOST || 'localhost',
    user: process.env.MYSQLUSER || process.env.DB_USER || 'root',
    password: process.env.MYSQLPASSWORD || process.env.DB_PASSWORD || '',
    database: process.env.MYSQLDATABASE || process.env.DB_NAME || 'tienda_moda_node',
    port: Number(process.env.MYSQLPORT || process.env.DB_PORT || 3306),
    waitForConnections: true,
    connectionLimit: 10,
    charset: 'utf8mb4'
  };
}

const pool = mysql.createPool(config);

module.exports = pool;
