<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Manejar preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

try {
    // Configuración de la base de datos
    $host = 'localhost';
    $dbname = 'koncheck_db';
    $username = 'root';
    $password = '';
    
    // Crear conexión PDO
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Obtener identificación de la URL
    $path = $_SERVER['REQUEST_URI'];
    $parts = explode('/', $path);
    $identificacion = end($parts);
    
    // Validar formato de identificación (10 dígitos)
    if (!preg_match('/^[0-9]{10}$/', $identificacion)) {
        echo json_encode(['exists' => false]);
        exit();
    }
    
    // Verificar que el usuario existe y está activo
    $stmt = $pdo->prepare("SELECT id FROM usuario_fuerza_publica WHERE identificacion = ? AND activo = 1");
    $stmt->execute([$identificacion]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);
    
    echo json_encode(['exists' => (bool)$user]);
    
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['exists' => false, 'error' => 'Error de base de datos']);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['exists' => false, 'error' => 'Error general']);
}
?>