<?php
session_start(); // Inicia la sesión al principio de todo

header('Content-Type: application/json');
require_once 'db.php';

// Solo procesar si es un método POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405); // Method Not Allowed
    echo json_encode(['error' => 'Método no permitido']);
    exit;
}

$data = json_decode(file_get_contents('php://input'), true);

$usuario = $data['usuario'] ?? '';
$password = $data['password'] ?? '';

if (empty($usuario) || empty($password)) {
    http_response_code(400); // Bad Request
    echo json_encode(['success' => false, 'error' => 'Usuario y contraseña son requeridos.']);
    exit;
}

$db = getDB();

try {
    $stmt = $db->prepare("SELECT * FROM Empleado WHERE usuario = ?");
    $stmt->execute([$usuario]);
    $empleado = $stmt->fetch();

    // IMPORTANTE: En un sistema real, NUNCA guardes contraseñas en texto plano.
    // Usa password_hash() para guardarlas y password_verify() para comprobarlas.
    if ($empleado && $password === $empleado['password']) {
        // Credenciales correctas. Guardar datos en la sesión.
        $_SESSION['user_id'] = $empleado['idEmpleado'];
        $_SESSION['username'] = $empleado['usuario'];
        echo json_encode(['success' => true]);
    } else {
        http_response_code(401); // Unauthorized
        echo json_encode(['success' => false, 'error' => 'Usuario o contraseña incorrectos.']);
    }
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'error' => 'Error en la base de datos: ' . $e->getMessage()]);
}
?>