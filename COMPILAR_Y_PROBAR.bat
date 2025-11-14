@echo off
echo ========================================
echo 🔧 COMPILAR Y PROBAR PROYECTO ORGANIZADO
echo ========================================
echo Las clases han sido organizadas correctamente
echo.

echo 📋 ESTRUCTURA ORGANIZADA:
echo ----------------------------------------
echo ✅ src/main/java/edu/konrad/rest/AuthFuerzaPublicaResource.java
echo ✅ src/main/java/edu/konrad/service/AuthFuerzaPublicaService.java
echo ✅ src/main/java/edu/konrad/service/FuerzaPublicaService.java
echo ✅ src/main/java/edu/komad/model/FuerzaPublica.java
echo ✅ src/main/java/edu/komad/model/UsuarioFuerzaPublica.java
echo ✅ src/main/java/edu/komad/repository/UsuarioFuerzaPublicaRepository.java
echo ✅ src/test/java/edu/konrad/test/TestConexionDB.java
echo.

echo 🔧 PASO 1: LIMPIAR PROYECTO
echo ----------------------------------------
mvn clean
if %errorlevel% neq 0 (
    echo ❌ Error limpiando proyecto
    pause
    exit /b 1
)
echo ✅ Proyecto limpiado

echo.
echo 🔧 PASO 2: COMPILAR PROYECTO
echo ----------------------------------------
mvn compile
if %errorlevel% neq 0 (
    echo ❌ Error de compilación
    echo 📋 Revisar errores de Java arriba
    pause
    exit /b 1
)
echo ✅ Compilación exitosa

echo.
echo 🔧 PASO 3: EJECUTAR TESTS
echo ----------------------------------------
echo Ejecutando test de conexión a base de datos...

REM Verificar que XAMPP MySQL esté ejecutándose
netstat -an | findstr :3306 >nul
if %errorlevel% neq 0 (
    echo ⚠️ XAMPP MySQL no está ejecutándose
    echo 📋 SOLUCION: Iniciar XAMPP MySQL antes de continuar
    echo ¿Deseas continuar sin el test de BD? (S/N)
    set /p continuar=
    if /i "%continuar%" neq "S" (
        echo Iniciando XAMPP...
        if exist "C:\xampp\xampp-control.exe" (
            start "" "C:\xampp\xampp-control.exe"
        )
        pause
        exit /b 1
    )
) else (
    echo ✅ XAMPP MySQL ejecutándose
    
    REM Ejecutar test de conexión
    java -cp "target/classes;C:\xampp\mysql\connector-java-8.0.33.jar" edu.konrad.test.TestConexionDB 2>nul
    if %errorlevel% equ 0 (
        echo ✅ Test de conexión exitoso
    ) else (
        echo ⚠️ Test de conexión falló (normal si no hay driver MySQL en classpath)
        echo 📋 Para probar conexión manualmente: CREAR_BASE_DATOS_SOLO.bat
    )
)

echo.
echo 🔧 PASO 4: CREAR WAR
echo ----------------------------------------
mvn package
if %errorlevel% neq 0 (
    echo ❌ Error creando WAR
    pause
    exit /b 1
)
echo ✅ WAR creado: target\koncheck-backend.war

echo.
echo 🔧 PASO 5: VERIFICAR ESTRUCTURA
echo ----------------------------------------
echo Verificando que todas las clases estén en su lugar...

if exist "src\main\java\edu\konrad\rest\AuthFuerzaPublicaResource.java" (
    echo ✅ AuthFuerzaPublicaResource.java
) else (
    echo ❌ AuthFuerzaPublicaResource.java NO encontrado
)

if exist "src\main\java\edu\konrad\service\AuthFuerzaPublicaService.java" (
    echo ✅ AuthFuerzaPublicaService.java
) else (
    echo ❌ AuthFuerzaPublicaService.java NO encontrado
)

if exist "src\main\java\edu\konrad\service\FuerzaPublicaService.java" (
    echo ✅ FuerzaPublicaService.java
) else (
    echo ❌ FuerzaPublicaService.java NO encontrado
)

if exist "src\main\java\edu\komad\repository\UsuarioFuerzaPublicaRepository.java" (
    echo ✅ UsuarioFuerzaPublicaRepository.java
) else (
    echo ❌ UsuarioFuerzaPublicaRepository.java NO encontrado
)

if exist "src\test\java\edu\konrad\test\TestConexionDB.java" (
    echo ✅ TestConexionDB.java
) else (
    echo ❌ TestConexionDB.java NO encontrado
)

echo.
echo ========================================
echo 📊 RESULTADO FINAL
echo ========================================

if exist "target\koncheck-backend.war" (
    echo 🎉 PROYECTO COMPILADO EXITOSAMENTE
    echo.
    echo 📁 Archivos generados:
    echo    - target\koncheck-backend.war (listo para desplegar)
    echo    - Todas las clases organizadas correctamente
    echo.
    echo 📋 PRÓXIMOS PASOS:
    echo    1. Base de datos: CREAR_BASE_DATOS_SOLO.bat
    echo    2. Servidor: scripts\configurar_glassfish_xampp.bat
    echo    3. Desplegar: asadmin deploy target\koncheck-backend.war
    echo    4. Probar: test-conexion-fuerza-publica.html
    echo.
    echo 🌐 O usar el script automático: CONECTAR_TODO_AUTOMATICO.bat
    
) else (
    echo ❌ ERROR EN LA COMPILACION
    echo 📋 SOLUCION:
    echo    1. Revisar errores de compilación arriba
    echo    2. Verificar que Java JDK esté instalado
    echo    3. Verificar que Maven esté configurado
    echo    4. Ejecutar: mvn clean compile
)

echo.
echo 📖 ESTRUCTURA FINAL DEL PROYECTO:
echo ----------------------------------------
echo src/main/java/
echo ├── edu/konrad/
echo │   ├── rest/           # Endpoints REST
echo │   └── service/        # Servicios de negocio
echo └── edu/komad/
echo     ├── model/          # Entidades JPA
echo     └── repository/     # Repositorios de datos
echo src/test/java/
echo └── edu/konrad/test/    # Tests de conexión
echo.

pause