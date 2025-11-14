<?php
// Servidor proxy simple para redirigir las peticiones del formulario a nuestros archivos PHP

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

// Manejar preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$request_uri = $_SERVER['REQUEST_URI'];
$method = $_SERVER['REQUEST_METHOD'];

// Redirigir peticiones según la URL
if (strpos($request_uri, '/api/auth/fuerza-publica/validate/') !== false) {
    // Extraer la identificación de la URL
    $parts = explode('/', $request_uri);
    $identificacion = end($parts);
    
    // Incluir el archivo de validación
    $_GET['identificacion'] = $identificacion;
    include 'api/auth/fuerza-publica/validate.php';
    
} elseif (strpos($request_uri, '/api/auth/fuerza-publica/change-password') !== false && $method === 'POST') {
    // Incluir el archivo de cambio de contraseña
    include 'api/auth/fuerza-publica/change-password.php';
    
} else {
    http_response_code(404);
    echo json_encode(['error' => 'Endpoint no encontrado']);
}
?>