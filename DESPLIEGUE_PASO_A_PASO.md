# Guía de Despliegue Paso a Paso - KonCheck Backend

## Requisitos Previos

- Java JDK 17 o superior
- Maven 3.8+
- GlassFish 7.x
- MySQL 8.0+
- Docker (opcional, para MySQL)

---

## Paso 1: Configurar Base de Datos MySQL

### Opción A: Con Docker (Recomendado)

\`\`\`bash
# Iniciar MySQL con Docker
docker-compose up -d

# Verificar que esté corriendo
docker ps
\`\`\`

### Opción B: MySQL Local

\`\`\`bash
# Conectar a MySQL
mysql -u root -p

# Crear base de datos
CREATE DATABASE koncheck_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

# Crear usuario
CREATE USER 'koncheck'@'localhost' IDENTIFIED BY 'TuPasswordFuerte';
GRANT ALL PRIVILEGES ON koncheck_db.* TO 'koncheck'@'localhost';
FLUSH PRIVILEGES;
\`\`\`

---

## Paso 2: Ejecutar Scripts SQL

\`\`\`bash
# Conectar a la base de datos
mysql -u koncheck -p koncheck_db

# Ejecutar scripts
source scripts/01_create_tables.sql
source scripts/02_insert_test_data.sql
\`\`\`

**Verificar tablas creadas:**
\`\`\`sql
USE koncheck_db;
SHOW TABLES;
DESCRIBE personas;
DESCRIBE ciudadanos;
DESCRIBE administradores;
\`\`\`

---

## Paso 3: Configurar GlassFish

### 3.1 Iniciar GlassFish

\`\`\`bash
cd $GLASSFISH_HOME/bin
./asadmin start-domain
\`\`\`

### 3.2 Crear JDBC Connection Pool

\`\`\`bash
./asadmin create-jdbc-connection-pool \
  --datasourceclassname com.mysql.cj.jdbc.MysqlDataSource \
  --restype javax.sql.DataSource \
  --property user=koncheck:password=TuPasswordFuerte:serverName=localhost:portNumber=3306:databaseName=koncheck_db:useSSL=false:allowPublicKeyRetrieval=true \
  koncheckPool
\`\`\`

### 3.3 Crear JDBC Resource

\`\`\`bash
./asadmin create-jdbc-resource \
  --connectionpoolid koncheckPool \
  jdbc/koncheckDS
\`\`\`

### 3.4 Verificar Conexión

\`\`\`bash
./asadmin ping-connection-pool koncheckPool
\`\`\`

Debe mostrar: `Command ping-connection-pool executed successfully.`

### 3.5 Configurar Variable de Entorno JWT (IMPORTANTE)

\`\`\`bash
# Generar clave segura
openssl rand -base64 64

# Configurar en GlassFish
./asadmin create-jvm-options "-DJWT_SECRET_KEY=TuClaveGeneradaAqui"

# Reiniciar dominio
./asadmin restart-domain
\`\`\`

---

## Paso 4: Compilar el Proyecto

\`\`\`bash
# Limpiar y compilar
mvn clean package

# Verificar que se generó el WAR
ls -lh target/koncheck-backend.war
\`\`\`

---

## Paso 5: Desplegar en GlassFish

### Opción A: Línea de Comandos

\`\`\`bash
./asadmin deploy --force=true target/koncheck-backend.war
\`\`\`

### Opción B: Consola de Administración

1. Abrir navegador: `http://localhost:4848`
2. Ir a: Applications → Deploy
3. Seleccionar archivo: `target/koncheck-backend.war`
4. Context Root: `/api`
5. Click en "OK"

---

## Paso 6: Verificar Despliegue

### 6.1 Health Check

\`\`\`bash
curl -k https://localhost:8181/koncheck/api/health
\`\`\`

**Respuesta esperada:**
\`\`\`json
{
  "status": "UP",
  "database": "OK",
  "timestamp": 1234567890
}
\`\`\`

### 6.2 Registrar Administrador

\`\`\`bash
curl -k -X POST https://localhost:8181/koncheck/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "correo": "admin@koncheck.com",
    "password": "Admin123"
  }'
\`\`\`

### 6.3 Login

\`\`\`bash
curl -k -X POST https://localhost:8181/koncheck/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "correo": "admin@koncheck.com",
    "password": "Admin123"
  }'
\`\`\`

**Guardar el token JWT de la respuesta.**

### 6.4 Listar Ciudadanos

\`\`\`bash
curl -k https://localhost:8181/koncheck/api/ciudadanos \
  -H "Authorization: Bearer TU_TOKEN_JWT_AQUI"
\`\`\`

---

## Paso 7: Configurar Frontend

### 7.1 Actualizar URL del API

Editar `Administrador/js/api-config.js`:

\`\`\`javascript
const API_CONFIG = {
    BASE_URL: 'https://localhost:8181/koncheck/api',
    TIMEOUT: 30000
};
\`\`\`

### 7.2 Servir Frontend

\`\`\`bash
# Opción 1: Python
cd /ruta/al/frontend
python3 -m http.server 8000

# Opción 2: Node.js
npx http-server -p 8000

# Opción 3: PHP
php -S localhost:8000
\`\`\`

### 7.3 Abrir en Navegador

\`\`\`
http://localhost:8000/LandingPage.html
\`\`\`

---

## Solución de Problemas

### Error: "Connection refused"

\`\`\`bash
# Verificar que GlassFish esté corriendo
./asadmin list-domains

# Ver logs
tail -f $GLASSFISH_HOME/glassfish/domains/domain1/logs/server.log
\`\`\`

### Error: "JDBC Resource not found"

\`\`\`bash
# Listar recursos JDBC
./asadmin list-jdbc-resources

# Recrear si es necesario
./asadmin delete-jdbc-resource jdbc/koncheckDS
./asadmin delete-jdbc-connection-pool koncheckPool
# Luego repetir Paso 3.2 y 3.3
\`\`\`

### Error: "Token inválido"

\`\`\`bash
# Verificar variable de entorno JWT
./asadmin list-jvm-options | grep JWT

# Si no existe, configurarla (Paso 3.5)
\`\`\`

### Error CORS

Verificar que `CorsFilter.java` incluya tu origen:
\`\`\`java
private static final List<String> ALLOWED_ORIGINS = Arrays.asList(
    "http://localhost:8000",
    "http://localhost:3000",
    "http://127.0.0.1:8000",
    "https://localhost:8181",  // Backend mismo
    "null"  // Para archivos locales
);
\`\`\`

---

## Comandos Útiles

\`\`\`bash
# Ver aplicaciones desplegadas
./asadmin list-applications

# Redesplegar
./asadmin redeploy target/koncheck-backend.war

# Ver logs en tiempo real
tail -f $GLASSFISH_HOME/glassfish/domains/domain1/logs/server.log

# Detener GlassFish
./asadmin stop-domain

# Limpiar y redesplegar
mvn clean package && ./asadmin redeploy target/koncheck-backend.war
\`\`\`

---

## Checklist de Verificación

- [ ] MySQL corriendo y accesible
- [ ] Tablas creadas correctamente
- [ ] Datos de prueba insertados
- [ ] GlassFish iniciado
- [ ] JDBC Connection Pool creado y funcionando
- [ ] JDBC Resource creado
- [ ] Variable JWT_SECRET_KEY configurada
- [ ] WAR compilado sin errores
- [ ] Aplicación desplegada en GlassFish
- [ ] Health check responde OK
- [ ] Registro de administrador funciona
- [ ] Login genera token JWT
- [ ] Endpoints protegidos requieren token
- [ ] CORS configurado correctamente
- [ ] Frontend puede comunicarse con backend

---

## Próximos Pasos

1. Configurar HTTPS para producción
2. Implementar rate limiting
3. Configurar backups automáticos
4. Configurar monitoreo y alertas
5. Revisar logs de seguridad regularmente

**¡Despliegue completado exitosamente!**
