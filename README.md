# KonCheck Backend

Backend REST API para el sistema KonCheck de gestión de ciudadanos.

## Tecnologías

- **Java 17**
- **Jakarta EE 10** (JAX-RS, JPA, CDI, EJB)
- **Hibernate 6.3** (ORM)
- **MySQL 8.0**
- **GlassFish 7** (Servidor de aplicaciones)
- **JWT** (Autenticación)
- **BCrypt** (Hash de contraseñas)
- **Maven** (Gestión de dependencias)

## Estructura del Proyecto

\`\`\`
koncheck-backend/
├── pom.xml
├── docker-compose.yml
├── src/main/
│   ├── java/edu/konrad/
│   │   ├── model/              # Entidades JPA
│   │   │   ├── Persona.java
│   │   │   ├── Administrador.java
│   │   │   ├── Ciudadano.java
│   │   │   └── Documento.java
│   │   ├── repository/         # Repositorios (acceso a BD)
│   │   │   ├── GenericRepository.java
│   │   │   ├── AdministradorRepository.java
│   │   │   └── CiudadanoRepository.java
│   │   ├── service/            # Lógica de negocio
│   │   │   ├── AdministradorService.java
│   │   │   └── CiudadanoService.java
│   │   ├── rest/               # Endpoints REST
│   │   │   ├── RestApplication.java
│   │   │   ├── CorsFilter.java
│   │   │   ├── AuthResource.java
│   │   │   └── CiudadanoResource.java
│   │   └── security/           # Seguridad y JWT
│   │       ├── JwtUtil.java
│   │       └── AuthFilter.java
│   └── resources/
│       ├── META-INF/
│       │   └── persistence.xml
│       └── logging.properties
└── scripts/                    # Scripts SQL
    ├── 01_create_tables.sql
    └── 02_insert_test_data.sql
\`\`\`

## Configuración

### 1. Base de Datos (Docker)

Iniciar MySQL con Docker:

\`\`\`bash
docker-compose up -d
\`\`\`

Esto creará:
- Base de datos: `koncheck_db`
- Usuario: `koncheck`
- Password: `KonCheck2025!`
- Puerto: `3306`

### 2. GlassFish

#### Crear JDBC Connection Pool:

\`\`\`bash
asadmin create-jdbc-connection-pool \
  --datasourceclassname com.mysql.cj.jdbc.MysqlDataSource \
  --restype javax.sql.DataSource \
  --property user=koncheck:password=KonCheck2025!:serverName=localhost:portNumber=3306:databaseName=koncheck_db \
  KonCheckPool
\`\`\`

#### Crear JDBC Resource:

\`\`\`bash
asadmin create-jdbc-resource --connectionpoolid KonCheckPool jdbc/koncheckDS
\`\`\`

#### Verificar conexión:

\`\`\`bash
asadmin ping-connection-pool KonCheckPool
\`\`\`

### 3. Compilar y Desplegar

\`\`\`bash
# Compilar
mvn clean package

# Desplegar en GlassFish
asadmin deploy target/koncheck-backend.war

# O copiar manualmente a:
cp target/koncheck-backend.war $GLASSFISH_HOME/glassfish/domains/domain1/autodeploy/
\`\`\`

## API Endpoints

### Autenticación (Público)

#### Registrar Administrador
\`\`\`http
POST /api/auth/register
Content-Type: application/json

{
  "correo": "admin@koncheck.com",
  "password": "Admin123"
}
\`\`\`

#### Login
\`\`\`http
POST /api/auth/login
Content-Type: application/json

{
  "correo": "admin@koncheck.com",
  "password": "Admin123"
}
\`\`\`

Respuesta:
\`\`\`json
{
  "success": true,
  "message": "Login exitoso",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "administrador": {
    "id": 1,
    "correo": "admin@koncheck.com",
    "nombres": "Admin",
    "apellidos": "Sistema"
  }
}
\`\`\`

#### Validar Token
\`\`\`http
GET /api/auth/validate
Authorization: Bearer {token}
\`\`\`

### Ciudadanos (Requiere Autenticación)

Todas las peticiones deben incluir el header:
\`\`\`
Authorization: Bearer {token}
\`\`\`

#### Listar Todos
\`\`\`http
GET /api/ciudadanos
\`\`\`

#### Buscar
\`\`\`http
GET /api/ciudadanos?search=Juan
GET /api/ciudadanos?estado=Requerido
\`\`\`

#### Obtener por ID
\`\`\`http
GET /api/ciudadanos/{id}
\`\`\`

#### Obtener por Identificación
\`\`\`http
GET /api/ciudadanos/identificacion/1088765432
\`\`\`

#### Crear Ciudadano
\`\`\`http
POST /api/ciudadanos
Content-Type: application/json
Authorization: Bearer {token}

{
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
\`\`\`

#### Actualizar Ciudadano
\`\`\`http
PUT /api/ciudadanos/{id}
Content-Type: application/json
Authorization: Bearer {token}

{
  "nombres": "Juan Carlos",
  "apellidos": "Pérez García",
  "identificacion": "1088765432",
  "fechaNacimiento": "1990-05-20",
  "lugarNacimiento": "Bogotá",
  "rh": "O+",
  "fechaExpedicion": "2008-05-20",
  "lugarExpedicion": "Bogotá",
  "estatura": "1.76",
  "estadoJudicial": "Requerido"
}
\`\`\`

#### Eliminar Ciudadano
\`\`\`http
DELETE /api/ciudadanos/{id}
Authorization: Bearer {token}
\`\`\`

#### Contar Ciudadanos
\`\`\`http
GET /api/ciudadanos/count
Authorization: Bearer {token}
\`\`\`

## Datos de Prueba

Después de ejecutar los scripts SQL, tendrás:

**Administrador:**
- Correo: `admin@koncheck.com`
- Password: `Admin123`

**Ciudadanos:**
1. Juan Pérez - 1088765432
2. María Gómez - 1054223781
3. Carlos Rodríguez - 1092345876
4. Luisa Martínez - 1067890234
5. Andrés López - 1034567823

## Seguridad

- **Contraseñas**: Hash BCrypt (12 rounds)
- **Autenticación**: JWT (24 horas de expiración)
- **CORS**: Habilitado para desarrollo (ajustar en producción)
- **SQL Injection**: Protegido mediante JPA/JPQL
- **Validaciones**: En capa de servicio

## Testing con cURL

\`\`\`bash
# Registrar admin
curl -k -X POST https://localhost:8181/koncheck/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"correo":"test@koncheck.com","password":"Test123"}'

# Login
TOKEN=$(curl -k -X POST https://localhost:8181/koncheck/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"correo":"admin@koncheck.com","password":"Admin123"}' \
  | jq -r '.token')

# Listar ciudadanos
curl -k -X GET https://localhost:8181/koncheck/api/ciudadanos \
  -H "Authorization: Bearer $TOKEN"

# Crear ciudadano
curl -k -X POST https://localhost:8181/koncheck/api/ciudadanos \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "nombres":"Pedro",
    "apellidos":"Sánchez",
    "identificacion":"1099887766",
    "fechaNacimiento":"1995-03-15",
    "lugarNacimiento":"Cali",
    "rh":"A+",
    "fechaExpedicion":"2013-03-15",
    "lugarExpedicion":"Cali",
    "estatura":"1.82",
    "estadoJudicial":"No Requerido"
  }'
\`\`\`

## Troubleshooting

### Error: "No se puede conectar a la base de datos"
- Verificar que MySQL esté corriendo: `docker ps`
- Verificar JDBC Resource en GlassFish: `asadmin list-jdbc-resources`
- Ping al connection pool: `asadmin ping-connection-pool KonCheckPool`

### Error: "Token inválido"
- Verificar que el token no haya expirado (24 horas)
- Verificar formato del header: `Authorization: Bearer {token}`

### Error: "Ya existe un ciudadano con esa identificación"
- La identificación debe ser única
- Verificar en BD: `SELECT * FROM personas WHERE identificacion = '...'`

## Producción

Para producción, cambiar:

1. **Secret Key JWT**: Variable de entorno
2. **CORS**: Restringir orígenes permitidos
3. **Logging**: Nivel INFO o WARNING
4. **SSL/TLS**: Habilitar HTTPS
5. **Credenciales BD**: Variables de entorno seguras

## Licencia

Proyecto académico - Universidad Konrad Lorenz

# KonCheck
SW DE VALIDACION 
