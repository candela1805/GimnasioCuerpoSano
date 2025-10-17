<?php
session_start();
// Si no hay una sesión de usuario iniciada, redirigir a la página de login.
if (!isset($_SESSION['user_id'])) {
    header('Location: login.html');
    exit;
}
?>
<!doctype html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>Panel principal - Gimnasio Cuerpo Sano</title>
  <style>
   
    body {
      margin: 0;
      height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background: linear-gradient(135deg, #c8f0e0, #d9ecf5);
    }

    
    .panel {
      background-color: #ffffff;
      padding: 40px;
      border-radius: 20px;
      box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
      text-align: center;
      width: 340px;
      transition: transform 0.3s ease;
    }

    .panel:hover {
      transform: translateY(-4px);
    }

    
    h1 {
      color: #1b3c34;
      font-size: 1.6em;
      margin-bottom: 10px;
    }

    
    p {
      color: #3ca373;
      font-weight: 500;
      margin-bottom: 25px;
    }

    
    button {
      display: block;
      width: 100%;
      border: none;
      border-radius: 8px;
      color: white;
      padding: 12px;
      margin: 10px 0;
      font-size: 1em;
      font-weight: bold;
      cursor: pointer;
      transition: all 0.25s ease;
    }

    button:hover {
      opacity: 0.9;
      transform: scale(1.02);
    }

    
    .clientes {
      background-color: #4aa97c;
    }

    .actividades {
      background-color: #3c9cd1;
    }

    .clases {
      background-color: #f9b233;
    }

    .cerrar {
      background-color: #9e9e9e;
    }

  </style>
</head>
<body>

  <div class="panel">
    <h1>🏋️ Gimnasio Cuerpo Sano</h1>
    <p>Seleccione una opción</p>

    <a href="gestionClientes.html"><button class="clientes">👤 Gestionar Clientes</button></a>
    <a href="#"><button class="actividades">🏃 Gestionar Actividades</button></a>
    <a href="#"><button class="clases">📅 Gestión de Clases</button></a>
    <a href="api/logout.php"><button class="cerrar">⬅️ Cerrar sesión</button></a>
  </div>

</body>
</html>
