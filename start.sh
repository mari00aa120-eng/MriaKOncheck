#!/bin/bash

echo "======================================"
echo "  KonCheck - Inicio Rápido"
echo "======================================"
echo ""

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Verificar Docker
echo -e "${YELLOW}[1/6]${NC} Verificando Docker..."
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker no está instalado${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Docker encontrado${NC}"

# Verificar Maven
echo -e "${YELLOW}[2/6]${NC} Verificando Maven..."
if ! command -v mvn &> /dev/null; then
    echo -e "${RED}Error: Maven no está instalado${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Maven encontrado${NC}"

# Iniciar MySQL
echo -e "${YELLOW}[3/6]${NC} Iniciando MySQL con Docker..."
docker-compose up -d
sleep 5
echo -e "${GREEN}✓ MySQL iniciado${NC}"

# Compilar proyecto
echo -e "${YELLOW}[4/6]${NC} Compilando proyecto..."
mvn clean package -DskipTests
if [ $? -ne 0 ]; then
    echo -e "${RED}Error al compilar el proyecto${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Proyecto compilado${NC}"

# Ejecutar scripts SQL
echo -e "${YELLOW}[5/6]${NC} Ejecutando scripts SQL..."
sleep 3
docker exec -i koncheck-mysql mysql -ukoncheck -pKonCheck2025! koncheck_db < scripts/01_create_tables.sql
docker exec -i koncheck-mysql mysql -ukoncheck -pKonCheck2025! koncheck_db < scripts/02_insert_test_data.sql
echo -e "${GREEN}✓ Base de datos configurada${NC}"

# Instrucciones finales
echo -e "${YELLOW}[6/6]${NC} Configuración completada"
echo ""
echo -e "${GREEN}======================================"
echo "  Próximos pasos:"
echo "======================================${NC}"
echo ""
echo "1. Configurar GlassFish Connection Pool:"
echo "   asadmin create-jdbc-connection-pool \\"
echo "     --datasourceclassname com.mysql.cj.jdbc.MysqlDataSource \\"
echo "     --restype javax.sql.DataSource \\"
echo "     --property serverName=localhost:portNumber=3306:databaseName=koncheck_db:user=koncheck:password=KonCheck2025!:useSSL=false:allowPublicKeyRetrieval=true \\"
echo "     KonCheckPool"
echo ""
echo "2. Crear JDBC Resource:"
echo "   asadmin create-jdbc-resource \\"
echo "     --connectionpoolid KonCheckPool \\"
echo "     jdbc/koncheckDS"
echo ""
echo "3. Desplegar aplicación:"
echo "   asadmin deploy --contextroot /koncheck target/koncheck-backend.war"
echo ""
echo "4. Probar API:"
echo "   curl http://localhost:8080/koncheck/api/auth/login \\"
echo "     -H 'Content-Type: application/json' \\"
echo "     -d '{\"correo\":\"admin@koncheck.com\",\"password\":\"Admin123\"}'"
echo ""
echo -e "${GREEN}======================================"
echo "  Base de datos MySQL:"
echo "======================================${NC}"
echo "  Host: localhost:3306"
echo "  Database: koncheck_db"
echo "  User: koncheck"
echo "  Password: KonCheck2025!"
echo ""
echo -e "${GREEN}======================================"
echo "  Credenciales de prueba:"
echo "======================================${NC}"
echo "  Correo: admin@koncheck.com"
echo "  Password: Admin123"
echo ""
