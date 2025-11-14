const http = require('http');
const mysql = require('mysql2/promise');
const crypto = require('crypto');
const url = require('url');
const { dbConfig, createConnection, testConnection } = require('./db.js');

// Las contraseñas se guardan en texto plano (sin encriptación)
function encryptPassword(password) {
  return password; // Devuelve la contraseña tal como está
}

// Función para manejar CORS
function setCORSHeaders(res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
}

// Función para parsear el body de la petición
function parseBody(req) {
  return new Promise((resolve, reject) => {
    let body = '';
    req.on('data', chunk => {
      body += chunk.toString();
    });
    req.on('end', () => {
      try {
        resolve(JSON.parse(body));
      } catch (error) {
        resolve({});
      }
    });
    req.on('error', reject);
  });
}

// Crear servidor HTTP
const server = http.createServer(async (req, res) => {
  setCORSHeaders(res);
  
  // Manejar preflight requests
  if (req.method === 'OPTIONS') {
    res.writeHead(200);
    res.end();
    return;
  }

  const parsedUrl = url.parse(req.url, true);
  const path = parsedUrl.pathname;
  
  console.log(`${req.method} ${path}`);

  try {
    // Conectar a la base de datos usando el módulo db.js
    const connection = await createConnection();

    if (path === '/api/auth/fuerza-publica/register' && req.method === 'POST') {
      // REGISTRO DE USUARIO
      const body = await parseBody(req);
      const { identificacion, nombres, apellidos, password } = body;

      if (!identificacion || !nombres || !apellidos || !password) {
        res.writeHead(400, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'Todos los campos son obligatorios' }));
        await connection.end();
        return;
      }

      // Verificar si ya existe
      const [existing] = await connection.execute(
        'SELECT id FROM usuario_fuerza_publica WHERE identificacion = ? AND activo = true',
        [identificacion]
      );

      if (existing.length > 0) {
        res.writeHead(400, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'Ya existe un usuario con esta identificación' }));
        await connection.end();
        return;
      }

      // Insertar nuevo usuario
      const hashedPassword = encryptPassword(password);
      const [result] = await connection.execute(
        'INSERT INTO usuario_fuerza_publica (identificacion, nombres, apellidos, password, estado_judicial, activo) VALUES (?, ?, ?, ?, ?, ?)',
        [identificacion, nombres, apellidos, hashedPassword, 'No Requerido', true]
      );

      res.writeHead(201, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({
        success: true,
        message: 'Usuario registrado exitosamente',
        userId: result.insertId,
        identificacion: identificacion
      }));

    } else if (path === '/api/auth/fuerza-publica/login' && req.method === 'POST') {
      // LOGIN DE USUARIO
      const body = await parseBody(req);
      const { identificacion, password } = body;

      if (!identificacion || !password) {
        res.writeHead(400, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'Identificación y contraseña son obligatorios' }));
        await connection.end();
        return;
      }

      // Buscar usuario
      const hashedPassword = encryptPassword(password);
      const [users] = await connection.execute(
        'SELECT id, identificacion, nombres, apellidos FROM usuario_fuerza_publica WHERE identificacion = ? AND password = ? AND activo = true',
        [identificacion, hashedPassword]
      );

      if (users.length === 0) {
        res.writeHead(401, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'Credenciales inválidas' }));
        await connection.end();
        return;
      }

      const user = users[0];
      
      // Actualizar último acceso
      await connection.execute(
        'UPDATE usuario_fuerza_publica SET ultimo_acceso = NOW() WHERE id = ?',
        [user.id]
      );

      // Generar token simple
      const token = `fp-token-${user.id}-${Date.now()}`;

      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({
        success: true,
        token: token,
        userId: user.id,
        identificacion: user.identificacion,
        nombres: user.nombres,
        apellidos: user.apellidos,
        tipo: 'FUERZA_PUBLICA'
      }));

    } else if (path.startsWith('/api/auth/fuerza-publica/validate/') && req.method === 'GET') {
      // VALIDAR USUARIO
      const identificacion = path.split('/').pop();
      
      const [users] = await connection.execute(
        'SELECT id FROM usuario_fuerza_publica WHERE identificacion = ? AND activo = true',
        [identificacion]
      );

      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({
        exists: users.length > 0,
        identificacion: identificacion
      }));

    } else if (path === '/' && req.method === 'GET') {
      // Página de estado del servidor
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({
        status: 'OK',
        message: 'Servidor KonCheck Fuerza Pública funcionando',
        database: 'koncheck_db conectada ✅',
        endpoints: [
          'POST /api/auth/fuerza-publica/register',
          'POST /api/auth/fuerza-publica/login',
          'GET /api/auth/fuerza-publica/validate/{id}',
          'GET /api/auth/fuerza-publica/profile/{id}',
          'POST /api/auth/fuerza-publica/change-password',
          'GET /api/test-db',
          'GET /api/health'
        ]
      }));

    } else if (path === '/favicon.ico' && req.method === 'GET') {
      // Ignorar favicon
      res.writeHead(204);
      res.end();

    } else if (path === '/api/health' && req.method === 'GET') {
      // Health check
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ status: 'healthy', timestamp: new Date().toISOString() }));

    } else if (path === '/api/test-db' && req.method === 'GET') {
      // Prueba de conexión a la base de datos
      try {
        const [rows] = await connection.execute('SELECT COUNT(*) as total_users FROM usuario_fuerza_publica WHERE activo = true');
        const [tables] = await connection.execute('SHOW TABLES');
        
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({
          success: true,
          message: 'Conexión a base de datos exitosa',
          database: 'koncheck_db',
          total_users: rows[0].total_users,
          tables: tables.map(t => Object.values(t)[0]),
          timestamp: new Date().toISOString()
        }));
      } catch (dbError) {
        res.writeHead(500, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({
          success: false,
          error: 'Error conectando a la base de datos',
          details: dbError.message
        }));
      }

    } else if (path.startsWith('/api/auth/fuerza-publica/profile/') && req.method === 'GET') {
      // OBTENER PERFIL DE USUARIO
      const identificacion = path.split('/').pop();
      
      const [users] = await connection.execute(
        'SELECT id, identificacion, nombres, apellidos, estado_judicial, fecha_creacion, ultimo_acceso FROM usuario_fuerza_publica WHERE identificacion = ? AND activo = true',
        [identificacion]
      );

      if (users.length === 0) {
        res.writeHead(404, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'Usuario no encontrado' }));
        await connection.end();
        return;
      }

      const user = users[0];
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({
        success: true,
        usuario: {
          id: user.id,
          identificacion: user.identificacion,
          nombres: user.nombres,
          apellidos: user.apellidos,
          estado_judicial: user.estado_judicial,
          fecha_creacion: user.fecha_creacion,
          ultimo_acceso: user.ultimo_acceso
        }
      }));

    } else if (path === '/api/auth/fuerza-publica/change-password' && req.method === 'POST') {
      // CAMBIAR CONTRASEÑA
      const body = await parseBody(req);
      const { identificacion, newPassword } = body;

      if (!identificacion || !newPassword) {
        res.writeHead(400, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'Identificación y nueva contraseña son obligatorios' }));
        await connection.end();
        return;
      }

      // Validar longitud de contraseña
      if (newPassword.length > 10) {
        res.writeHead(400, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'La contraseña no puede tener más de 10 caracteres' }));
        await connection.end();
        return;
      }

      // Verificar que el usuario existe
      const [users] = await connection.execute(
        'SELECT id FROM usuario_fuerza_publica WHERE identificacion = ? AND activo = true',
        [identificacion]
      );

      if (users.length === 0) {
        res.writeHead(404, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'Usuario no encontrado' }));
        await connection.end();
        return;
      }

      // Actualizar contraseña
      const hashedPassword = encryptPassword(newPassword);
      await connection.execute(
        'UPDATE usuario_fuerza_publica SET password = ?, fecha_actualizacion = NOW() WHERE identificacion = ?',
        [hashedPassword, identificacion]
      );

      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({
        success: true,
        message: 'Contraseña actualizada exitosamente'
      }));

    } else {
      // Ruta no encontrada
      console.log(`❌ Ruta no encontrada: ${req.method} ${path}`);
      res.writeHead(404, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ error: 'Ruta no encontrada', path: path, method: req.method }));
    }

    await connection.end();

  } catch (error) {
    console.error('Error:', error);
    res.writeHead(500, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ error: 'Error interno del servidor' }));
  }
});

const PORT = 3001;
server.listen(PORT, async () => {
  console.log('🚀 Servidor backend ejecutándose en http://localhost:' + PORT);
  console.log('📊 Endpoints disponibles:');
  console.log('   POST /api/auth/fuerza-publica/register');
  console.log('   POST /api/auth/fuerza-publica/login');
  console.log('   GET  /api/auth/fuerza-publica/validate/{id}');
  console.log('   POST /api/auth/fuerza-publica/change-password');
  console.log('   GET  /api/test-db (🆕 Prueba de conexión DB)');
  console.log('   GET  /api/health');
  console.log('');
  
  // Probar conexión a la base de datos al iniciar
  console.log('🔍 Probando conexión a la base de datos...');
  const dbOk = await testConnection();
  if (dbOk) {
    console.log('✅ Base de datos koncheck_db lista');
  } else {
    console.log('❌ Problema con la base de datos - revisa XAMPP');
  }
  
  console.log('');
  console.log('🔑 Credenciales de prueba (sincronizadas con BD real):');
  console.log('   ID: 1234567890 | Password: 123456      | Juan Carlos Pérez García');
  console.log('   ID: 9876543210 | Password: password123 | María Elena Rodríguez López');
  console.log('   ID: 1122334455 | Password: admin2024   | Carlos Alberto Martínez Silva');
  console.log('   ID: 5566778899 | Password: fuerza2024  | Ana Patricia González Ruiz');
  console.log('   ID: 9988776655 | Password: policia123  | Luis Fernando Castro Morales');
});