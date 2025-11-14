@echo off
cls
echo ========================================
echo         SERVIDOR KONCHECK NODEJS
echo ========================================
echo.
echo Iniciando servidor en puerto 3001...
echo.
echo URLs disponibles:
echo   http://localhost:3001/
echo   http://localhost:3001/api/test-db
echo.
echo Credenciales de prueba:
echo   ID: 1234567890 ^| Password: 123456
echo   ID: 9876543210 ^| Password: password123
echo   ID: 1122334455 ^| Password: admin2024
echo   ID: 5566778899 ^| Password: fuerza2024
echo   ID: 9988776655 ^| Password: policia123
echo.
echo Presiona Ctrl+C para detener el servidor
echo ========================================
echo.

node backend-simple.js

pause