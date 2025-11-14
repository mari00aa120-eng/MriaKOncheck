@echo off
echo ========================================
echo PRUEBA RÁPIDA DEL SISTEMA KONCHECK
echo ========================================
echo.

echo 1. Verificando MySQL...
tasklist /FI "IMAGENAME eq mysqld.exe" 2>NUL | find /I /N "mysqld.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo ✅ MySQL funcionando
) else (
    echo ❌ MySQL no está ejecutándose
    echo    Inicia XAMPP primero
    pause
    exit /b 1
)

echo.
echo 2. Verificando base de datos...
if exist "C:\xampp\mysql\bin\mysql.exe" (
    echo SELECT 'Base de datos OK' as estado; | "C:\xampp\mysql\bin\mysql.exe" -u root --password= koncheck_db 2>nul
    if %errorlevel% equ 0 (
        echo ✅ Base de datos accesible
    ) else (
        echo ❌ Problema con base de datos
        echo    Ejecuta: CREAR_BASE_DATOS_SOLO.bat
    )
) else (
    echo ❌ MySQL no encontrado en XAMPP
)

echo.
echo 3. Verificando usuarios en BD...
if exist "C:\xampp\mysql\bin\mysql.exe" (
    echo SELECT COUNT(*) as total FROM usuario_fuerza_publica; | "C:\xampp\mysql\bin\mysql.exe" -u root --password= koncheck_db 2>nul
    if %errorlevel% equ 0 (
        echo ✅ Tabla de usuarios accesible
    ) else (
        echo ❌ Tabla de usuarios no encontrada
    )
)

echo.
echo 4. Iniciando servidor backend...
start "Backend Test" cmd /c "timeout /t 5 && echo Servidor iniciado && node backend-simple.js"
timeout /t 2 /nobreak >nul

echo.
echo 5. Abriendo página de prueba...
start "" "login-simple-funcional.html"

echo.
echo ========================================
echo PRUEBA INICIADA
echo ========================================
echo.
echo 🎯 PASOS PARA PROBAR:
echo    1. En la página que se abrió, usa:
echo       Cédula: 1234567890
echo       Contraseña: 123456
echo.
echo    2. Haz clic en "Ingresar"
echo.
echo    3. Deberías ver: "¡Bienvenido Juan Carlos Pérez García!"
echo.
echo 🔧 SI NO FUNCIONA:
echo    - Verifica que aparezca "Servidor conectado" en verde
echo    - Si aparece error rojo, ejecuta: INICIAR_SISTEMA_COMPLETO.bat
echo    - Revisa la consola del navegador (F12) para errores
echo.
pause