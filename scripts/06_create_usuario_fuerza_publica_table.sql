-- Script para crear la tabla usuario_fuerza_publica
-- Ejecutar este script en tu base de datos MySQL/MariaDB

CREATE TABLE IF NOT EXISTS usuario_fuerza_publica (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    identificacion VARCHAR(20) NOT NULL UNIQUE,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    fecha_nacimiento DATE,
    lugar_nacimiento VARCHAR(100),
    rh VARCHAR(5),
    fecha_expedicion DATE,
    lugar_expedicion VARCHAR(100),
    estatura DOUBLE,
    estado_judicial VARCHAR(50) DEFAULT 'No Requerido',
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    ultimo_acceso TIMESTAMP NULL,
    
    INDEX idx_identificacion (identificacion),
    INDEX idx_activo (activo),
    INDEX idx_fecha_creacion (fecha_creacion)
);

-- Insertar algunos datos de prueba (opcional)
INSERT INTO usuario_fuerza_publica (identificacion, nombres, apellidos, password, estado_judicial) VALUES
('12345678', 'Juan Carlos', 'Pérez García', SHA2('123456', 256), 'No Requerido'),
('87654321', 'María Elena', 'Rodríguez López', SHA2('password123', 256), 'No Requerido'),
('11223344', 'Carlos Alberto', 'Martínez Silva', SHA2('admin2024', 256), 'No Requerido');

-- Verificar que la tabla se creó correctamente
SELECT * FROM usuario_fuerza_publica;