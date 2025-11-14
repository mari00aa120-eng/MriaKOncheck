-- ========================================
-- VERIFICAR Y CORREGIR CONTRASEÑAS
-- ========================================
-- Este script verifica la estructura de la tabla y corrige los datos

USE koncheck_db;

-- 1. Verificar estructura de la tabla
SELECT 'ESTRUCTURA DE LA TABLA usuario_fuerza_publica' AS mensaje;
DESCRIBE usuario_fuerza_publica;

-- 2. Verificar usuarios existentes y sus contraseñas
SELECT 'USUARIOS EXISTENTES Y ESTADO DE CONTRASEÑAS' AS mensaje;
SELECT 
    identificacion, 
    nombres, 
    apellidos, 
    CASE 
        WHEN password IS NULL THEN 'SIN CONTRASEÑA'
        WHEN password = '' THEN 'CONTRASEÑA VACÍA'
        WHEN LENGTH(password) < 10 THEN 'CONTRASEÑA MUY CORTA'
        ELSE 'CONTRASEÑA OK'
    END AS estado_password,
    LENGTH(password) AS longitud_password,
    activo
FROM usuario_fuerza_publica 
ORDER BY identificacion;

-- 3. Verificar si existe la tabla de recuperación
SELECT 'VERIFICANDO TABLA DE RECUPERACIÓN' AS mensaje;
SELECT COUNT(*) as tabla_existe 
FROM information_schema.tables 
WHERE table_schema = 'koncheck_db' 
AND table_name = 'recuperacion_password';

-- 4. Actualizar contraseñas para usuarios que no las tienen o están vacías
UPDATE usuario_fuerza_publica 
SET password = SHA2('123456', 256) 
WHERE password IS NULL OR password = '' OR LENGTH(password) < 10;

-- 5. Verificar después de la actualización
SELECT 'ESTADO DESPUÉS DE LA CORRECCIÓN' AS mensaje;
SELECT 
    identificacion, 
    nombres, 
    apellidos, 
    CASE 
        WHEN password IS NULL THEN 'SIN CONTRASEÑA'
        WHEN password = '' THEN 'CONTRASEÑA VACÍA'
        WHEN LENGTH(password) < 10 THEN 'CONTRASEÑA MUY CORTA'
        ELSE 'CONTRASEÑA OK'
    END AS estado_password,
    LENGTH(password) AS longitud_password,
    activo
FROM usuario_fuerza_publica 
ORDER BY identificacion;

SELECT 'VERIFICACIÓN Y CORRECCIÓN COMPLETADA' AS mensaje;