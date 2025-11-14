<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

try {
    // Probar conexión a la base de datos
    $pdo = new PDO("mysql:host=localhost;dbname=koncheck_db;charset=utf8", "root", "");
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Probar consulta
    $stmt = $pdo->query("SELECT COUNT(*) as total FROM usuario_fuerza_publica");
    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    
    echo json_encode([
        'status' => 'success',
        'message' => 'Conexión exitosa',
        'total_usuarios' => $result['total'],
        'timestamp' => date('Y-m-d H:i:s')
    ]);
    
} catch(PDOException $e) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Error de conexión: ' . $e->getMessage(),
        'timestamp' => date('Y-m-d H:i:s')
    ]);
}
?>