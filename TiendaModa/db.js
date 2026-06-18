const mysql = require('mysql2/promise');
require('dotenv').config();

const pool = mysql.createPool({
  uri: process.env.MYSQL_PUBLIC_URL || process.env.MYSQL_URL,
  waitForConnections: true,
  connectionLimit: 10,
  charset: 'utf8mb4'
});

module.exports = pool;
