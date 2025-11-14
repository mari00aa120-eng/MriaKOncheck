-- ========================================
-- TABLA PARA RECUPERACIÓN DE CONTRASEÑAS
-- ========================================
-- Esta tabla almacena las solicitudes de recuperación de contraseña

USE koncheck_db;

-- Crear tabla para recuperación de contraseñas
DROP TABLE IF EXISTS recuperacion_password;

CREATE TABLE recuperacion_password (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    identificacion VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    token VARCHAR(255) NOT NULL UNIQUE,
    fecha_solicitud TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_expiracion TIMESTAMP NOT NULL,
    usado BOOLEAN DEFAULT FALSE,
    ip_solicitud VARCHAR(45),
    user_agent TEXT,
    
    -- Índices para optimizar consultas
    INDEX idx_identificacion (identificacion),
    INDEX idx_token (token),
    INDEX idx_fecha_expiracion (fecha_expiracion),
    INDEX idx_usado (usado),
    
    -- Relación con usuario_fuerza_publica
    FOREIGN KEY (identificacion) REFERENCES usuario_fuerza_publica(identificacion) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Verificar que la tabla se creó correctamente
SELECT 'TABLA RECUPERACION_PASSWORD CREADA EXITOSAMENTE' AS mensaje;

-- Mostrar estructura de la tabla
DESCRIBE recuperacion_password;