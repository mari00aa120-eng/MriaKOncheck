@echo off
cls
echo ========================================
echo      SISTEMA KONCHECK COMPLETO
echo ========================================
echo.
echo 1. Iniciando servidor Node.js...
start /min cmd /c "node backend-simple.js"

echo 2. Esperando que el servidor inicie...
timeout /t 3 /nobreak >nul

echo 3. Abriendo sistema de login...
start "" "login-sistema.html"

echo.
echo ✅ Sistema iniciado correctamente!
echo.
echo 📋 Credenciales de prueba:
echo    ID: 1234567890 ^| Password: 123456
echo    ID: 9876543210 ^| Password: password123
echo    ID: 1122334455 ^| Password: admin2024
echo.
echo 🌐 URLs disponibles:
echo    Login: login-sistema.html
echo    Dashboard: dashboard-usuario.html
echo    API: http://localhost:3001
echo.
echo ⚠️  Para cerrar el servidor, cierra esta ventana
echo.
pause