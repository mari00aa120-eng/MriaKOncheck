@echo off
cls
echo ========================================
echo    PROBAR CAMBIO DE CONTRASEÑA
echo ========================================
echo.

echo 1. Verificando servidor Node.js...
curl -s http://localhost:3001/api/health >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Servidor Node.js funcionando
) else (
    echo ❌ Servidor no está corriendo
    echo    Iniciando servidor...
    start /min cmd /c "node backend-simple.js"
    timeout /t 3 /nobreak >nul
)

echo.
echo 2. Abriendo página de cambio de contraseña...
start "" "FuerzaPublica\Dashboard\ReestablecerContrasena\reestablecerContrasena.html"

echo.
echo 3. Abriendo base de datos para verificar cambios...
start "" "http://localhost/phpmyadmin/index.php?route=/sql&db=koncheck_db&table=usuario_fuerza_publica&pos=0"

echo.
echo ✅ Sistema listo para probar!
echo.
echo 📋 Credenciales para probar:
echo    Cédula: 1234567890 (Juan Carlos)
echo    Cédula: 9876543210 (María Elena)
echo    Cédula: 1122334455 (Carlos Alberto)
echo.
echo 🔧 Pasos para probar:
echo    1. Ingresa una cédula válida (10 dígitos)
echo    2. Espera la validación automática
echo    3. Ingresa nueva contraseña (máx 10 caracteres)
echo    4. Confirma la contraseña
echo    5. Haz clic en Confirmar
echo    6. Verifica el cambio en phpMyAdmin
echo.
pause