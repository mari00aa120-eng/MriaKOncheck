// db.js
const mysql = require('mysql2/promise');

// Configuración de la base de datos
const dbConfig = {
  host: 'localhost',
  user: 'root',              // tu usuario de MySQL
  password: '',              // deja vacío si no tienes contraseña
  database: 'koncheck_db'    // nombre de tu base
};

// Función para crear conexión
async function createConnection() {
  try {
    const connection = await mysql.createConnection(dbConfig);
    console.log('✅ Conectado correctamente a la base de datos koncheck_db');
    return connection;
  } catch (error) {
    console.error('❌ Error conectando a la base de datos:', error.message);
    throw error;
  }
}

// Función para probar la conexión
async function testConnection() {
  let connection;
  try {
    connection = await createConnection();
    const [rows] = await connection.execute('SELECT 1 as test');
    console.log('🔍 Prueba de conexión exitosa:', rows[0]);
    return true;
  } catch (error) {
    console.error('❌ Error en prueba de conexión:', error.message);
    return false;
  } finally {
    if (connection) {
      await connection.end();
    }
  }
}

module.exports = {
  dbConfig,
  createConnection,
  testConnection
};