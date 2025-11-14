<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Manejar preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

try {
    // Test 1: Verificar que PHP funciona
    $phpVersion = phpversion();
    
    // Test 2: Verificar conexión a MySQL
    $host = 'localhost';
    $dbname = 'koncheck_db';
    $username = 'root';
    $password = '';
    
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Test 3: Verificar que la tabla existe
    $stmt = $pdo->query("SHOW TABLES LIKE 'usuario_fuerza_publica'");
    $tableExists = $stmt->rowCount() > 0;
    
    // Test 4: Verificar estructura de la tabla
    $columns = [];
    if ($tableExists) {
        $stmt = $pdo->query("DESCRIBE usuario_fuerza_publica");
        $columns = $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
    
    // Test 5: Contar registros existentes
    $userCount = 0;
    if ($tableExists) {
        $stmt = $pdo->query("SELECT COUNT(*) as count FROM usuario_fuerza_publica");
        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        $userCount = $result['count'];
    }
    
    echo json_encode([
        'success' => true,
        'message' => 'Conexión exitosa',
        'diagnostics' => [
            'php_version' => $phpVersion,
            'mysql_connected' => true,
            'database_exists' => true,
            'table_exists' => $tableExists,
            'user_count' => $userCount,
            'table_columns' => array_column($columns, 'Field'),
            'server_time' => date('Y-m-d H:i:s'),
            'request_method' => $_SERVER['REQUEST_METHOD']
        ]
    ]);
    
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => 'Error de base de datos: ' . $e->getMessage(),
        'diagnostics' => [
            'php_version' => phpversion(),
            'mysql_connected' => false,
            'error_code' => $e->getCode(),
            'server_time' => date('Y-m-d H:i:s')
        ]
    ]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => 'Error general: ' . $e->getMessage(),
        'diagnostics' => [
            'php_version' => phpversion(),
            'server_time' => date('Y-m-d H:i:s')
        ]
    ]);
}
?>