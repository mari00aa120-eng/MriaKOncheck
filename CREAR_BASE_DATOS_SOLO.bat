@echo off
echo ========================================
echo 📊 CREAR BASE DE DATOS FUERZA PUBLICA
echo ========================================
echo Este script crea SOLO la base de datos
echo.

echo ⏳ Verificando XAMPP MySQL...
netstat -an | findstr :3306 >nul
if %errorlevel% neq 0 (
    echo ❌ ERROR: XAMPP MySQL no está ejecutándose
    echo.
    echo 📋 SOLUCION:
    echo    1. Abrir XAMPP Control Panel
    echo    2. Hacer clic en "Start" en MySQL
    echo    3. Verificar que esté en verde
    echo    4. Ejecutar este script nuevamente
    echo.
    pause
    exit /b 1
)
echo ✅ XAMPP MySQL ejecutándose correctamente

echo.
echo 🔧 Creando base de datos automáticamente...

if exist "C:\xampp\mysql\bin\mysql.exe" (
    "C:\xampp\mysql\bin\mysql.exe" -u root --password= < "scripts\09_setup_xampp_fuerza_publica.sql" 2>error_db.log
    
    if %errorlevel% equ 0 (
        echo ✅ ¡Base de datos creada exitosamente!
        del error_db.log 2>nul
        
        echo.
        echo 🔍 Verificando datos creados...
        
        REM Verificar tablas
        echo SHOW TABLES FROM koncheck_db; | "C:\xampp\mysql\bin\mysql.exe" -u root --password= >temp_tables.txt 2>nul
        findstr "fuerza_publica" temp_tables.txt >nul
        if %errorlevel% equ 0 (
            echo ✅ Tabla fuerza_publica creada
        ) else (
            echo ❌ Tabla fuerza_publica NO creada
        )
        
        findstr "usuario_fuerza_publica" temp_tables.txt >nul
        if %errorlevel% equ 0 (
            echo ✅ Tabla usuario_fuerza_publica creada
        ) else (
            echo ❌ Tabla usuario_fuerza_publica NO creada
        )
        del temp_tables.txt 2>nul
        
        REM Contar registros
        echo USE koncheck_db; SELECT COUNT(*) FROM fuerza_publica; | "C:\xampp\mysql\bin\mysql.exe" -u root --password= -s >temp_count1.txt 2>nul
        set /p fp_count=<temp_count1.txt
        del temp_count1.txt 2>nul
        echo ✅ Registros fuerza_publica: %fp_count%
        
        echo USE koncheck_db; SELECT COUNT(*) FROM usuario_fuerza_publica; | "C:\xampp\mysql\bin\mysql.exe" -u root --password= -s >temp_count2.txt 2>nul
        set /p user_count=<temp_count2.txt
        del temp_count2.txt 2>nul
        echo ✅ Usuarios para login: %user_count%
        
        echo.
        echo 🎉 ¡BASE DE DATOS LISTA!
        echo.
        echo 📊 Resumen:
        echo    - Base de datos: koncheck_db
        echo    - Tabla fuerza_publica: %fp_count% registros
        echo    - Tabla usuario_fuerza_publica: %user_count% usuarios
        echo.
        echo 👥 Usuarios de prueba disponibles:
        echo    - ID: 80123456789, Password: policia2024 (Capitán Jorge)
        echo    - ID: 79876543210, Password: fuerza123 (Teniente Ana)
        echo    - ID: 81122334455, Password: seguridad456 (Sargento Carlos)
        echo.
        echo 🌐 Verificar en phpMyAdmin: http://localhost/phpmyadmin
        echo.
        echo 📋 PRÓXIMOS PASOS:
        echo    1. Para conectar aplicación Java: CONECTAR_TODO_AUTOMATICO.bat
        echo    2. Para verificar todo: verificar_conexion_completa.bat
        echo    3. Para configurar servidor: scripts\configurar_glassfish_xampp.bat
        
    ) else (
        echo ❌ Error al crear base de datos
        echo.
        echo 📋 ERROR DETECTADO:
        type error_db.log 2>nul
        echo.
        echo 📋 SOLUCION MANUAL:
        echo    1. Ir a: http://localhost/phpmyadmin
        echo    2. Hacer clic en "SQL" (pestaña superior)
        echo    3. Copiar TODO el contenido del archivo: scripts\09_setup_xampp_fuerza_publica.sql
        echo    4. Pegar en el área de texto
        echo    5. Hacer clic en "Continuar"
        echo    6. Verificar que aparezcan mensajes de éxito
        del error_db.log 2>nul
    )
) else (
    echo ❌ MySQL no encontrado en XAMPP
    echo.
    echo 📋 SOLUCION MANUAL:
    echo    1. Ir a: http://localhost/phpmyadmin
    echo    2. Hacer clic en "SQL" (pestaña superior)
    echo    3. Copiar TODO el contenido del archivo: scripts\09_setup_xampp_fuerza_publica.sql
    echo    4. Pegar en el área de texto
    echo    5. Hacer clic en "Continuar"
    echo    6. Verificar que aparezcan mensajes de éxito
)

echo.
pause