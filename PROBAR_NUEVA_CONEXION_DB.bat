@echo off
echo ========================================
echo    PROBANDO NUEVA CONEXION BASE DATOS
echo ========================================
echo.

echo 1. Probando conexion directa...
node test-db-connection.js
echo.

echo 2. Iniciando servidor backend...
echo Presiona Ctrl+C para detener el servidor
echo.
echo Abre en tu navegador:
echo http://localhost:3001/api/test-db
echo http://localhost:3001/
echo.
echo O abre el archivo: test-nueva-conexion-db.html
echo.

node backend-simple.js

pause