@echo off
echo ========================================
echo    INICIANDO SERVIDOR KONCHECK
echo ========================================
echo.

echo Probando conexion a la base de datos...
node test-db-connection.js
echo.

echo Iniciando servidor en puerto 3001...
echo.
echo Abre tu navegador en:
echo http://localhost:3001/
echo http://localhost:3001/api/test-db
echo.
echo Presiona Ctrl+C para detener el servidor
echo.

node backend-simple.js

pause