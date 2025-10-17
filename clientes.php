<?php
header('Content-Type: application/json');
require_once 'db.php';

$metodo = $_SERVER['REQUEST_METHOD'];
$db = getDB();

switch ($metodo) {
    case 'GET':
        // Obtener todos los clientes
        try {
            $stmt = $db->query("
                SELECT 
                    p.dni, p.nombre, p.apellido, p.email, tm.nombre as membresia, m.idMiembro as codigo
                FROM Miembro m
                JOIN Persona p ON m.dni = p.dni
                JOIN TipoMembresia tm ON m.idTipoMembresia = tm.idTipo
            ");
            $clientes = $stmt->fetchAll();
            echo json_encode($clientes);
        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode(['error' => 'Error al obtener clientes: ' . $e->getMessage()]);
        }
        break;

    case 'POST':
        // Agregar un nuevo cliente
        $data = json_decode(file_get_contents('php://input'), true);

        if (json_last_error() !== JSON_ERROR_NONE) {
            http_response_code(400);
            echo json_encode(['error' => 'JSON inválido']);
            exit;
        }

        $db->beginTransaction();
        try {
            // 1. Insertar en Persona
            $stmt = $db->prepare("INSERT INTO Persona (dni, nombre, apellido, telefono, direccion, email) VALUES (?, ?, ?, ?, ?, ?)");
            $stmt->execute([$data['dni'], $data['nombre'], $data['apellido'], $data['telefono'], $data['direccion'], $data['email']]);

            // 2. Insertar en Membresia (simplificado)
            $fechaRegistro = date('Y-m-d');
            $stmt = $db->prepare("INSERT INTO Membresia (idTipo, costo, duracion, fechaRegistro) VALUES (?, 0, 30, ?)");
            $stmt->execute([$data['tipoMembresiaId'], $fechaRegistro]);
            $idMembresia = $db->lastInsertId();

            // 3. Insertar en Miembro
            $fechaInicio = date('Y-m-d');
            $fechaFin = date('Y-m-d', strtotime('+30 days'));
            $stmt = $db->prepare("INSERT INTO Miembro (dni, idTipoMembresia, idMembresia, fechaInicio, fechaFin, descuento) VALUES (?, ?, ?, ?, ?, ?)");
            $stmt->execute([$data['dni'], $data['tipoMembresiaId'], $idMembresia, $fechaInicio, $fechaFin, $data['descuento']]);
            $idMiembro = $db->lastInsertId();

            $db->commit();
            echo json_encode(['success' => true, 'idMiembro' => $idMiembro, 'message' => 'Cliente agregado correctamente']);
        } catch (PDOException $e) {
            $db->rollBack();
            http_response_code(500);
            echo json_encode(['error' => 'Error al agregar cliente: ' . $e->getMessage()]);
        }
        break;

    case 'DELETE':
        // Eliminar un cliente (por DNI)
        $dni = $_GET['dni'] ?? null;
        if (!$dni) {
            http_response_code(400);
            echo json_encode(['error' => 'DNI no proporcionado']);
            exit;
        }
        try {
            $stmt = $db->prepare("DELETE FROM Persona WHERE dni = ?");
            $stmt->execute([$dni]); // Se asume borrado en cascada o se deben borrar las referencias
            echo json_encode(['success' => true, 'message' => 'Cliente eliminado']);
        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode(['error' => 'Error al eliminar cliente: ' . $e->getMessage()]);
        }
        break;
}
?>