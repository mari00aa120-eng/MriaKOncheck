@echo off
cls
echo ========================================
echo    ABRIR SISTEMA COMPLETO + BASE DATOS
echo ========================================
echo.

echo 1. Abriendo base de datos...
start "" "http://localhost/phpmyadmin/index.php?route=/database/structure&db=koncheck_db"

echo 2. Iniciando servidor Node.js...
start /min cmd /c "cd /d %~dp0 && node backend-simple.js"

echo 3. Esperando que el servidor inicie...
timeout /t 3 /nobreak >nul

echo 4. Abriendo sistema de login...
start "" "login-sistema.html"

echo.
echo ✅ Todo iniciado correctamente!
echo.
echo 🌐 Ventanas abiertas:
echo    📊 Base de datos: phpMyAdmin
echo    🔐 Sistema login: login-sistema.html
echo    🖥️  Servidor API: http://localhost:3001
echo.
echo 📋 Credenciales de prueba:
echo    ID: 1234567890 ^| Password: 123456
echo    ID: 9876543210 ^| Password: password123
echo    ID: 1122334455 ^| Password: admin2024
echo.
echo ⚠️  Para cerrar todo, cierra esta ventana
echo.
pause