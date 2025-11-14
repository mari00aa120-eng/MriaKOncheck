-- Insertar usuarios de Fuerza Pública de prueba
USE koncheck_db;

INSERT IGNORE INTO usuario_fuerza_publica 
(identificacion, nombres, apellidos, password, estado_judicial) VALUES
('12345678', 'Juan Carlos', 'Pérez García', SHA2('123456', 256), 'No Requerido'),
('87654321', 'María Elena', 'Rodríguez López', SHA2('password123', 256), 'No Requerido'),
('11223344', 'Carlos Alberto', 'Martínez Silva', SHA2('admin2024', 256), 'No Requerido'),
('55667788', 'Ana Patricia', 'González Ruiz', SHA2('fuerza2024', 256), 'No Requerido'),
('99887766', 'Luis Fernando', 'Castro Morales', SHA2('policia123', 256), 'No Requerido');
