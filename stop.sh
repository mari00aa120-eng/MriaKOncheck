#!/bin/bash

echo "======================================"
echo "  KonCheck - Detener Servicios"
echo "======================================"
echo ""

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Detener MySQL
echo -e "${YELLOW}Deteniendo MySQL...${NC}"
docker-compose down
echo -e "${GREEN}✓ MySQL detenido${NC}"

echo ""
echo -e "${GREEN}Servicios detenidos correctamente${NC}"
echo ""
echo "Para iniciar nuevamente, ejecuta: ./start.sh"
