-- ========================================
-- SCRIPT COMPLETO SEGURO PARA AGREGAR COLUMNA RANGO
-- Y ACTUALIZAR DATOS EN TABLAS EXISTENTES
-- Compatible con MySQL 5.7+ y 8.x
-- ========================================

USE koncheck_db;

-- ========================================
-- 1. AGREGAR COLUMNA RANGO A FUERZA_PUBLICA SI NO EXISTE
-- ========================================
SELECT 'AGREGANDO COLUMNA RANGO A FUERZA_PUBLICA' AS mensaje;

-- Verificar si la columna existe
SELECT COUNT(*) INTO @existe_fp
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'koncheck_db'
  AND TABLE_NAME = 'fuerza_publica'
  AND COLUMN_NAME = 'rango';

SET @sql_fp = IF(@existe_fp = 0, 
                 'ALTER TABLE fuerza_publica ADD COLUMN rango VARCHAR(50) NOT NULL DEFAULT ''Sin Rango''',
                 'SELECT ''Columna ya existe en fuerza_publica''');

PREPARE stmt_fp FROM @sql_fp;
EXECUTE stmt_fp;
DEALLOCATE PREPARE stmt_fp;

-- Crear índice (eliminar si ya existe)
DROP INDEX IF EXISTS idx_rango ON fuerza_publica;
CREATE INDEX idx_rango ON fuerza_publica(rango);

-- ========================================
-- 2. AGREGAR COLUMNA RANGO A USUARIO_FUERZA_PUBLICA SI NO EXISTE
-- ========================================
SELECT 'AGREGANDO COLUMNA RANGO A USUARIO_FUERZA_PUBLICA' AS mensaje;

-- Verificar si la columna existe
SELECT COUNT(*) INTO @existe_ufp
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'koncheck_db'
  AND TABLE_NAME = 'usuario_fuerza_publica'
  AND COLUMN_NAME = 'rango';

SET @sql_ufp = IF(@existe_ufp = 0, 
                   'ALTER TABLE usuario_fuerza_publica ADD COLUMN rango VARCHAR(50) DEFAULT ''Sin Rango''',
                   'SELECT ''Columna ya existe en usuario_fuerza_publica''');

PREPARE stmt_ufp FROM @sql_ufp;
EXECUTE stmt_ufp;
DEALLOCATE PREPARE stmt_ufp;

-- Crear índice (eliminar si ya existe)
DROP INDEX IF EXISTS idx_rango ON usuario_fuerza_publica;
CREATE INDEX idx_rango ON usuario_fuerza_publica(rango);

-- ========================================
-- 3. ACTUALIZAR DATOS EXISTENTES CON RANGOS
-- ========================================
SELECT 'ACTUALIZANDO DATOS EXISTENTES CON RANGOS' AS mensaje;

-- Fuerza pública
UPDATE fuerza_publica SET rango = 'Capitán' WHERE identificacion = '80123456789';
UPDATE fuerza_publica SET rango = 'Teniente' WHERE identificacion = '79876543210';
UPDATE fuerza_publica SET rango = 'Sargento' WHERE identificacion = '81122334455';
UPDATE fuerza_publica SET rango = 'Cabo' WHERE identificacion = '82556677889';
UPDATE fuerza_publica SET rango = 'Agente' WHERE identificacion = '83988776655';
UPDATE fuerza_publica SET rango = 'Patrullero' WHERE identificacion = '84357924680';
UPDATE fuerza_publica SET rango = 'Inspector' WHERE identificacion = '85468135790';
UPDATE fuerza_publica SET rango = 'Subteniente' WHERE identificacion = '86111222233';
UPDATE fuerza_publica SET rango = 'Mayor' WHERE identificacion = '87444555566';
UPDATE fuerza_publica SET rango = 'Coronel' WHERE identificacion = '88777888899';
UPDATE fuerza_publica SET rango = 'Intendente' WHERE identificacion = '89333444455';
UPDATE fuerza_publica SET rango = 'Comisario' WHERE identificacion = '90666777788';
UPDATE fuerza_publica SET rango = 'Subcomisario' WHERE identificacion = '91888999900';
UPDATE fuerza_publica SET rango = 'Brigadier' WHERE identificacion = '92222333344';
UPDATE fuerza_publica SET rango = 'Comandante' WHERE identificacion = '93555666677';

-- Usuario fuerza pública
UPDATE usuario_fuerza_publica SET rango = 'Capitán' WHERE identificacion = '80123456789';
UPDATE usuario_fuerza_publica SET rango = 'Teniente' WHERE identificacion = '79876543210';
UPDATE usuario_fuerza_publica SET rango = 'Sargento' WHERE identificacion = '81122334455';
UPDATE usuario_fuerza_publica SET rango = 'Cabo' WHERE identificacion = '82556677889';
UPDATE usuario_fuerza_publica SET rango = 'Agente' WHERE identificacion = '83988776655';
UPDATE usuario_fuerza_publica SET rango = 'Patrullero' WHERE identificacion = '84357924680';
UPDATE usuario_fuerza_publica SET rango = 'Inspector' WHERE identificacion = '85468135790';
UPDATE usuario_fuerza_publica SET rango = 'Subteniente' WHERE identificacion = '86111222233';
UPDATE usuario_fuerza_publica SET rango = 'Mayor' WHERE identificacion = '87444555566';
UPDATE usuario_fuerza_publica SET rango = 'Coronel' WHERE identificacion = '88777888899';

-- Actualizar registros sin rango específico
UPDATE fuerza_publica SET rango = 'Agente' WHERE rango = 'Sin Rango' OR rango IS NULL;
UPDATE usuario_fuerza_publica SET rango = 'Agente' WHERE rango = 'Sin Rango' OR rango IS NULL;

-- ========================================
-- 4. VERIFICAR ACTUALIZACIONES
-- ========================================
SELECT 'VERIFICANDO ACTUALIZACIONES' AS mensaje;

-- Contar registros por rango en fuerza_publica
SELECT 
    'FUERZA_PUBLICA - Distribución por Rango' as tabla,
    rango,
    COUNT(*) as cantidad
FROM fuerza_publica 
GROUP BY rango 
ORDER BY cantidad DESC;

-- Contar registros por rango en usuario_fuerza_publica
SELECT 
    'USUARIO_FUERZA_PUBLICA - Distribución por Rango' as tabla,
    rango,
    COUNT(*) as cantidad
FROM usuario_fuerza_publica 
GROUP BY rango 
ORDER BY cantidad DESC;

-- Mostrar algunos ejemplos con rango
SELECT 'EJEMPLOS CON RANGO - FUERZA_PUBLICA' AS mensaje;
SELECT identificacion, rango, nombres, apellidos FROM fuerza_publica LIMIT 5;

SELECT 'EJEMPLOS CON RANGO - USUARIO_FUERZA_PUBLICA' AS mensaje;
SELECT identificacion, rango, nombres, apellidos FROM usuario_fuerza_publica LIMIT 5;

-- ========================================
-- 5. RANGOS DISPONIBLES EN EL SISTEMA
-- ========================================
SELECT 'RANGOS DISPONIBLES EN EL SISTEMA' AS mensaje;

SELECT DISTINCT rango as rangos_disponibles 
FROM fuerza_publica 
WHERE rango IS NOT NULL 
ORDER BY rango;

SELECT 'COLUMNA RANGO AGREGADA EXITOSAMENTE' AS mensaje;
