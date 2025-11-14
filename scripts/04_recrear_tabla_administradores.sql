-- Script para recrear la tabla administradores como tabla independiente
-- Ejecutar este script para corregir el error 500

USE koncheck_db;

-- Eliminar tabla administradores existente
DROP TABLE IF EXISTS administradores;

-- Crear tabla administradores independiente (sin herencia)
CREATE TABLE administradores (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    correo VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_correo (correo),
    INDEX idx_activo (activo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SELECT 'Tabla administradores recreada exitosamente' AS mensaje;
SELECT 'Ahora puedes registrar administradores sin problemas' AS instruccion;
