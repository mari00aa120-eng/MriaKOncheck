@echo off
echo ========================================
echo CORRIGIENDO SISTEMA DE CONTRASEÑAS
echo ========================================
echo.

echo 1. Verificando y corrigiendo contraseñas en la base de datos...
echo.

REM Ejecutar el script SQL de corrección
if exist "C:\xampp\mysql\bin\mysql.exe" (
    "C:\xampp\mysql\bin\mysql.exe" -u root -p < scripts\verificar_y_corregir_passwords.sql
) else (
    echo ERROR: No se encontró MySQL en la ruta esperada de XAMPP
    echo Por favor, ejecuta manualmente el archivo: scripts\verificar_y_corregir_passwords.sql
    echo.
)

echo.
echo 2. Creando tabla de recuperación de contraseñas si no existe...
echo.

if exist "C:\xampp\mysql\bin\mysql.exe" (
    "C:\xampp\mysql\bin\mysql.exe" -u root -p < scripts\12_crear_tabla_recuperacion_password.sql
) else (
    echo ERROR: No se encontró MySQL en la ruta esperada de XAMPP
    echo Por favor, ejecuta manualmente el archivo: scripts\12_crear_tabla_recuperacion_password.sql
    echo.
)

echo.
echo 3. Iniciando servidor de prueba...
echo.

REM Verificar si Node.js está instalado
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Node.js no está instalado o no está en el PATH
    echo Por favor, instala Node.js desde https://nodejs.org/
    pause
    exit /b 1
)

REM Iniciar el servidor backend
echo Iniciando servidor backend en puerto 3001...
start "Backend KonCheck" cmd /k "node backend-simple.js"

echo.
echo 4. Abriendo página de prueba...
echo.

REM Esperar un momento para que el servidor inicie
timeout /t 3 /nobreak >nul

REM Abrir la página de prueba
start "" "test-recuperacion-password-simple.html"

echo.
echo ========================================
echo CORRECCIÓN COMPLETADA
echo ========================================
echo.
echo INSTRUCCIONES:
echo 1. Se ha abierto una página de prueba simple
echo 2. Usa una de estas cédulas de prueba:
echo    - 1234567890 (Juan Carlos Pérez García)
echo    - 9876543210 (María Elena Rodríguez López)
echo    - 1122334455 (Carlos Alberto Martínez Silva)
echo    - 5566778899 (Ana Patricia González Ruiz)
echo    - 9988776655 (Luis Fernando Castro Morales)
echo.
echo 3. La contraseña por defecto es: 123456
echo 4. Puedes cambiarla por cualquier contraseña de hasta 10 caracteres
echo.
echo NOTA: Si hay errores, revisa que:
echo - XAMPP esté ejecutándose
echo - MySQL esté activo
echo - El servidor backend esté funcionando (ventana negra abierta)
echo.
pause