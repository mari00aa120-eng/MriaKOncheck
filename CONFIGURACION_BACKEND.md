# Configuración del Backend KonCheck

## ✅ Verificación Completa del Sistema

### 1. Entidades JPA - CORRECTAMENTE IMPLEMENTADAS

#### Persona.java (Clase Base)
- ✅ Tabla: `personas`
- ✅ Estrategia de herencia: `JOINED` (cada subclase tiene su propia tabla)
- ✅ Campos mapeados correctamente con anotaciones JPA
- ✅ Timestamps automáticos con `@PrePersist` y `@PreUpdate`
- ✅ Identificación única con índice

#### Ciudadano.java (Extiende Persona)
- ✅ Tabla: `ciudadanos`
- ✅ Relación OneToMany con Documentos
- ✅ Estado judicial por defecto: "No Requerido"
- ✅ Métodos helper para gestionar documentos

#### Administrador.java
- ✅ Tabla: `administradores`
- ✅ Correo único con índice
- ✅ Password hasheado con BCrypt
- ✅ Campo activo para soft delete

#### Documento.java
- ✅ Tabla: `documentos`
- ✅ Relación ManyToOne con Ciudadano
- ✅ Timestamps automáticos

### 2. Seguridad JWT - CORRECTAMENTE CONFIGURADA

#### JwtUtil.java
- ✅ Generación de tokens con algoritmo HS256
- ✅ Clave secreta de 256 bits
- ✅ Expiración: 24 horas
- ✅ Claims: userId y correo
- ✅ Validación y extracción de datos del token

#### AuthFilter.java
- ✅ Protege todos los endpoints excepto `/api/auth/*`
- ✅ Valida token en header `Authorization: Bearer <token>`
- ✅ Verifica expiración del token
- ✅ Respuestas JSON en caso de error

### 3. Nombres de Tablas - COINCIDEN PERFECTAMENTE

| Entidad JPA | Tabla SQL | Estado |
|-------------|-----------|--------|
| Persona | personas | ✅ |
| Administrador | administradores | ✅ |
| Ciudadano | ciudadanos | ✅ |
| Documento | documentos | ✅ |

### 4. Configuración MySQL

#### Docker Compose (Recomendado)
\`\`\`yaml
version: '3.8'
services:
  db:
    image: mysql:8.0
    restart: always
    environment:
      MYSQL_DATABASE: koncheck_db
      MYSQL_USER: koncheck
      MYSQL_PASSWORD: KonCheck2025!
      MYSQL_ROOT_PASSWORD: RootKonCheck2025!
    ports:
      - "3306:3306"
    volumes:
      - koncheck-data:/var/lib/mysql
    command: --default-authentication-plugin=mysql_native_password

volumes:
  koncheck-data:
\`\`\`

**Iniciar:** `docker-compose up -d`

#### Configuración Manual MySQL
\`\`\`sql
CREATE DATABASE koncheck_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'koncheck'@'localhost' IDENTIFIED BY 'KonCheck2025!';
GRANT ALL PRIVILEGES ON koncheck_db.* TO 'koncheck'@'localhost';
FLUSH PRIVILEGES;
\`\`\`

---

## 🚀 Pasos de Instalación en GlassFish

### Paso 1: Configurar Connection Pool

1. Abrir GlassFish Admin Console: `http://localhost:4848`
2. Navegar a: **Resources → JDBC → JDBC Connection Pools**
3. Click en **New**
4. Configurar:
   - **Pool Name:** `KonCheckPool`
   - **Resource Type:** `javax.sql.DataSource`
   - **Database Driver Vendor:** `MySQL`
5. Click **Next**
6. Configurar propiedades adicionales:
   \`\`\`
   serverName: localhost
   portNumber: 3306
   databaseName: koncheck_db
   user: koncheck
   password: KonCheck2025!
   useSSL: false
   allowPublicKeyRetrieval: true
   \`\`\`
7. Click **Finish**
8. **Ping** para verificar conexión

### Paso 2: Crear JDBC Resource

1. Navegar a: **Resources → JDBC → JDBC Resources**
2. Click en **New**
3. Configurar:
   - **JNDI Name:** `jdbc/koncheckDS`
   - **Pool Name:** `KonCheckPool`
4. Click **OK**

### Paso 3: Desplegar la Aplicación

#### Opción A: Desde Admin Console
1. Navegar a: **Applications**
2. Click **Deploy**
3. Seleccionar el archivo `koncheck-backend.war`
4. **Context Root:** `/koncheck`
5. Click **OK**

#### Opción B: Desde línea de comandos
\`\`\`bash
asadmin deploy --contextroot /koncheck target/koncheck-backend.war
\`\`\`

### Paso 4: Ejecutar Scripts SQL

Conectarse a MySQL y ejecutar en orden:
\`\`\`bash
mysql -u koncheck -p koncheck_db < scripts/01_create_tables.sql
mysql -u koncheck -p koncheck_db < scripts/02_insert_test_data.sql
\`\`\`

---

## 🔌 Endpoints REST Disponibles

### Base URL
\`\`\`
https://localhost:8181/koncheck/api
\`\`\`

### Autenticación (No requiere token)

#### Registrar Administrador
\`\`\`http
POST /api/auth/register
Content-Type: application/json

{
  "correo": "admin@koncheck.com",
  "password": "Admin123!"
}

Response 201:
{
  "id": 1,
  "correo": "admin@koncheck.com",
  "activo": true
}
\`\`\`

#### Login
\`\`\`http
POST /api/auth/login
Content-Type: application/json

{
  "correo": "admin@koncheck.com",
  "password": "Admin123!"
}

Response 200:
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "userId": 1,
  "correo": "admin@koncheck.com"
}
\`\`\`

### CRUD Ciudadanos (Requiere token)

**Header requerido en todas las peticiones:**
\`\`\`
Authorization: Bearer <token>
\`\`\`

#### Listar Todos los Ciudadanos
\`\`\`http
GET /api/ciudadanos
Authorization: Bearer <token>

Response 200:
[
  {
    "id": 2,
    "nombres": "Juan",
    "apellidos": "Pérez",
    "identificacion": "1088765432",
    "fechaNacimiento": "1990-05-20",
    "lugarNacimiento": "Bogotá",
    "rh": "O+",
    "fechaExpedicion": "2008-05-20",
    "lugarExpedicion": "Bogotá",
    "estatura": "1.75",
    "estadoJudicial": "No Requerido"
  }
]
\`\`\`

#### Obtener Ciudadano por ID
\`\`\`http
GET /api/ciudadanos/{id}
Authorization: Bearer <token>

Response 200:
{
  "id": 2,
  "nombres": "Juan",
  "apellidos": "Pérez",
  ...
}
\`\`\`

#### Crear Ciudadano
\`\`\`http
POST /api/ciudadanos
Authorization: Bearer <token>
Content-Type: application/json

{
  "nombres": "Carlos",
  "apellidos": "Gómez",
  "identificacion": "1098765432",
  "fechaNacimiento": "1995-03-15",
  "lugarNacimiento": "Medellín",
  "rh": "A+",
  "fechaExpedicion": "2013-03-15",
  "lugarExpedicion": "Medellín",
  "estatura": "1.80"
}

Response 201:
{
  "id": 7,
  "nombres": "Carlos",
  "apellidos": "Gómez",
  ...
}
\`\`\`

#### Actualizar Ciudadano
\`\`\`http
PUT /api/ciudadanos/{id}
Authorization: Bearer <token>
Content-Type: application/json

{
  "nombres": "Carlos Andrés",
  "apellidos": "Gómez López",
  "identificacion": "1098765432",
  "fechaNacimiento": "1995-03-15",
  "lugarNacimiento": "Medellín",
  "rh": "A+",
  "fechaExpedicion": "2013-03-15",
  "lugarExpedicion": "Medellín",
  "estatura": "1.82"
}

Response 200:
{
  "id": 7,
  "nombres": "Carlos Andrés",
  ...
}
\`\`\`

#### Eliminar Ciudadano
\`\`\`http
DELETE /api/ciudadanos/{id}
Authorization: Bearer <token>

Response 204: No Content
\`\`\`

---

## 🔧 Integración con Frontend

### Configurar CORS en el Frontend

Los archivos HTML ya están listos, solo necesitas actualizar la URL base de la API:

\`\`\`javascript
// En cada archivo HTML, buscar y actualizar:
const API_BASE_URL = 'https://localhost:8181/koncheck/api';
\`\`\`

### Ejemplo de Llamada desde el Frontend

#### Login (IngresarAd.html)
\`\`\`javascript
async function login() {
  const correo = document.getElementById('correo').value;
  const password = document.getElementById('password').value;
  
  try {
    const response = await fetch(`${API_BASE_URL}/auth/login`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ correo, password })
    });
    
    if (response.ok) {
      const data = await response.json();
      localStorage.setItem('token', data.token);
      localStorage.setItem('userId', data.userId);
      window.location.href = '../Dashboard/dashboard.html';
    } else {
      alert('Credenciales incorrectas');
    }
  } catch (error) {
    console.error('Error:', error);
    alert('Error de conexión');
  }
}
\`\`\`

#### Crear Ciudadano (crearCiudadano.html)
\`\`\`javascript
async function crearCiudadano() {
  const token = localStorage.getItem('token');
  
  const ciudadano = {
    nombres: document.getElementById('nombres').value,
    apellidos: document.getElementById('apellidos').value,
    identificacion: document.getElementById('identificacion').value,
    fechaNacimiento: document.getElementById('fechaNacimiento').value,
    lugarNacimiento: document.getElementById('lugarNacimiento').value,
    rh: document.getElementById('rh').value,
    fechaExpedicion: document.getElementById('fechaExpedicion').value,
    lugarExpedicion: document.getElementById('lugarExpedicion').value,
    estatura: document.getElementById('estatura').value
  };
  
  try {
    const response = await fetch(`${API_BASE_URL}/ciudadanos`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`
      },
      body: JSON.stringify(ciudadano)
    });
    
    if (response.ok) {
      alert('Ciudadano creado exitosamente');
      window.location.href = '../Dashboard/dashboard.html';
    } else {
      alert('Error al crear ciudadano');
    }
  } catch (error) {
    console.error('Error:', error);
    alert('Error de conexión');
  }
}
\`\`\`

---

## 🧪 Testing con Postman/cURL

### Registrar Admin
\`\`\`bash
curl -k -X POST https://localhost:8181/koncheck/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "correo": "admin@test.com",
    "password": "Admin123!"
  }'
\`\`\`

### Login
\`\`\`bash
curl -k -X POST https://localhost:8181/koncheck/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "correo": "admin@test.com",
    "password": "Admin123!"
  }'
\`\`\`

### Listar Ciudadanos
\`\`\`bash
curl -k -X GET https://localhost:8181/koncheck/api/ciudadanos \
  -H "Authorization: Bearer <tu-token-aqui>"
\`\`\`

---

## 📋 Checklist de Verificación

- [ ] MySQL corriendo en localhost:3306
- [ ] Base de datos `koncheck_db` creada
- [ ] Usuario `koncheck` con permisos
- [ ] GlassFish corriendo en localhost:8181
- [ ] Connection Pool `KonCheckPool` configurado y ping exitoso
- [ ] JDBC Resource `jdbc/koncheckDS` creado
- [ ] Scripts SQL ejecutados (tablas creadas)
- [ ] Aplicación desplegada en GlassFish
- [ ] Endpoint `/api/auth/register` responde
- [ ] Endpoint `/api/auth/login` responde
- [ ] Endpoints `/api/ciudadanos` protegidos con JWT
- [ ] CORS habilitado en CorsFilter
- [ ] Frontend actualizado con URL correcta de API

---

## 🐛 Troubleshooting

### Error: "No se puede conectar a la base de datos"
- Verificar que MySQL esté corriendo: `docker ps` o `systemctl status mysql`
- Verificar credenciales en Connection Pool
- Hacer ping al Connection Pool desde GlassFish Admin Console

### Error: "Token inválido"
- Verificar que el token se esté enviando en el header `Authorization: Bearer <token>`
- Verificar que el token no haya expirado (24 horas)
- Hacer login nuevamente para obtener un nuevo token

### Error: "CORS policy"
- Verificar que CorsFilter esté desplegado
- Verificar que el frontend esté usando la URL correcta
- Abrir consola del navegador para ver detalles del error CORS

### Error: "Tabla no existe"
- Ejecutar scripts SQL en orden
- Verificar que JPA esté usando la base de datos correcta
- Revisar logs de GlassFish: `glassfish/domains/domain1/logs/server.log`

---

## 📚 Recursos Adicionales

- [Documentación GlassFish](https://javaee.github.io/glassfish/)
- [Documentación JPA](https://jakarta.ee/specifications/persistence/)
- [Documentación JAX-RS](https://jakarta.ee/specifications/restful-ws/)
- [JWT.io](https://jwt.io/) - Decodificar y verificar tokens

---

## 🔐 Seguridad en Producción

**IMPORTANTE:** Antes de desplegar en producción:

1. Cambiar la clave secreta JWT en `JwtUtil.java` y moverla a variable de entorno
2. Usar HTTPS en lugar de HTTP
3. Configurar rate limiting para prevenir ataques de fuerza bruta
4. Implementar refresh tokens para mayor seguridad
5. Habilitar logs de auditoría
6. Configurar backups automáticos de la base de datos
7. Usar contraseñas fuertes para MySQL
8. Restringir acceso a GlassFish Admin Console

---

**Versión:** 1.0  
**Fecha:** 2025  
**Proyecto:** KonCheck Backend
