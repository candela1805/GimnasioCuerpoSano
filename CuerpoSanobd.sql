DROP DATABASE IF EXISTS CuerpoSanoDB;
CREATE DATABASE CuerpoSanoDB;
USE CuerpoSanoDB;

CREATE TABLE Persona (
    dni VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    direccion VARCHAR(200),
    telefono VARCHAR(20),
    fechaNacimiento DATE,
    email VARCHAR(100)
);

CREATE TABLE TipoMembresia (
    idTipo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(300),
    precioBase DECIMAL(10,2) NOT NULL,
    duracionDias INT NOT NULL,
    CHECK (precioBase > 0),
    CHECK (duracionDias > 0)
);

CREATE TABLE Membresia (
    idMembresia INT AUTO_INCREMENT PRIMARY KEY,
    idTipo INT NOT NULL,
    costo DECIMAL(10,2) NOT NULL,
    duracion INT NOT NULL,
    fechaRegistro DATE NOT NULL,
    FOREIGN KEY (idTipo) REFERENCES TipoMembresia(idTipo),
    CHECK (costo >= 0),
    CHECK (duracion > 0)
);

CREATE TABLE Empleado (
    idEmpleado INT AUTO_INCREMENT PRIMARY KEY,
    dni VARCHAR(20) NOT NULL UNIQUE,
    cargo VARCHAR(100) NOT NULL,
    fechaIngreso DATE,
    usuario VARCHAR(50),
    password VARCHAR(255),
    FOREIGN KEY (dni) REFERENCES Persona(dni)
);

CREATE TABLE Entrenador (
    idEntrenador INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    certificacion BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE Actividad (
    idActividad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(300),
    duracion INT NOT NULL,
    CHECK (duracion > 0)
);

CREATE TABLE Clase (
    idClase INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    horaInicio TIME,
    horaFin TIME,
    capacidad INT CHECK (capacidad > 0),
    idEntrenador INT NOT NULL,
    idActividad INT NOT NULL,
    FOREIGN KEY (idEntrenador) REFERENCES Entrenador(idEntrenador),
    FOREIGN KEY (idActividad) REFERENCES Actividad(idActividad)
);

CREATE TABLE HorarioClase (
    idHorario INT AUTO_INCREMENT PRIMARY KEY,
    diaSemana VARCHAR(20),
    horaInicio TIME,
    horaFin TIME,
    estado VARCHAR(20),
    idClase INT NOT NULL,
    FOREIGN KEY (idClase) REFERENCES Clase(idClase)
);

CREATE TABLE Descuento (
    idDescuento INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(300),
    porcentaje DECIMAL(5,2) NOT NULL CHECK (porcentaje BETWEEN 0 AND 100),
    tipo VARCHAR(50),
    vigenteDesde DATE,
    vigenteHasta DATE,
    CHECK (vigenteHasta > vigenteDesde)
);

CREATE TABLE Miembro (
    idMiembro INT AUTO_INCREMENT PRIMARY KEY,
    dni VARCHAR(20) NOT NULL UNIQUE,
    foto VARCHAR(200),
    idTipoMembresia INT NOT NULL,
    idMembresia INT NOT NULL,
    fechaInicio DATE NOT NULL,
    fechaFin DATE NOT NULL,
    descuento DECIMAL(5,2) DEFAULT 0 CHECK (descuento >= 0),
    FOREIGN KEY (dni) REFERENCES Persona(dni),
    FOREIGN KEY (idTipoMembresia) REFERENCES TipoMembresia(idTipo),
    FOREIGN KEY (idMembresia) REFERENCES Membresia(idMembresia),
    CHECK (fechaFin > fechaInicio)
);

CREATE TABLE Lector (
    idLector INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(50),
    modelo VARCHAR(100),
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE Asistencia (
    idAsistencia INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE NOT NULL,
    horaIngreso TIME,
    horaEgreso TIME,
    idMiembro INT NOT NULL,
    idClase INT NOT NULL,
    idLector INT,
    FOREIGN KEY (idMiembro) REFERENCES Miembro(idMiembro),
    FOREIGN KEY (idClase) REFERENCES Clase(idClase),
    FOREIGN KEY (idLector) REFERENCES Lector(idLector)
);

CREATE TABLE InscripcionClase (
    idInscripcion INT AUTO_INCREMENT PRIMARY KEY,
    estado VARCHAR(20),
    fechaInscripcion DATE,
    idMiembro INT NOT NULL,
    idClase INT NOT NULL,
    FOREIGN KEY (idMiembro) REFERENCES Miembro(idMiembro),
    FOREIGN KEY (idClase) REFERENCES Clase(idClase)
);

CREATE TABLE Pago (
    idPago INT AUTO_INCREMENT PRIMARY KEY,
    monto DECIMAL(10,2) NOT NULL CHECK (monto > 0),
    fechaPago DATE NOT NULL,
    metodoPago VARCHAR(50),
    idMiembro INT NOT NULL,
    FOREIGN KEY (idMiembro) REFERENCES Miembro(idMiembro)
);

CREATE TABLE Reporte (
    idReporte INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(100),
    contenido TEXT,
    idEmpleado INT NOT NULL,
    fechaGeneracion DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (idEmpleado) REFERENCES Empleado(idEmpleado)
);

CREATE TABLE MiembroDescuento (
    idMiembro INT NOT NULL,
    idDescuento INT NOT NULL,
    fechaAplicacion DATE DEFAULT (CURRENT_DATE),
    PRIMARY KEY (idMiembro, idDescuento),
    FOREIGN KEY (idMiembro) REFERENCES Miembro(idMiembro),
    FOREIGN KEY (idDescuento) REFERENCES Descuento(idDescuento)
);

CREATE TABLE DescuentoInscripcion (
    idDescuento INT NOT NULL,
    idInscripcion INT NOT NULL,
    fechaRegistro DATE DEFAULT (CURRENT_DATE),
    PRIMARY KEY (idDescuento, idInscripcion),
    FOREIGN KEY (idDescuento) REFERENCES Descuento(idDescuento),
    FOREIGN KEY (idInscripcion) REFERENCES InscripcionClase(idInscripcion)
);

INSERT INTO Persona VALUES
('12345678','Juan','Pérez','Av. Principal 123','555-0001','1985-03-15','juan.perez@email.com'),
('87654321','María','García','Calle Secundaria 456','555-0002','1990-07-22','maria.garcia@email.com'),
('11223344','Carlos','López','Av. Norte 789','555-0003','1988-11-10','carlos.lopez@email.com'),
('99887766','Ana','Martínez','Calle Sur 321','555-0004','1992-05-18','ana.martinez@email.com'),
('55443322','Pedro','Rodríguez','Av. Este 654','555-0005','1987-09-25','pedro.rodriguez@email.com');

INSERT INTO TipoMembresia (nombre,descripcion,precioBase,duracionDias) VALUES
('Básica','Acceso al gimnasio general',50.00,30),
('Premium','Acceso con clases grupales',80.00,30),
('VIP','Acceso con entrenador personal',150.00,30),
('Anual','Membresía anual con descuento',500.00,365);

INSERT INTO Membresia (idTipo,costo,duracion,fechaRegistro) VALUES
(1,50.00,30,'2024-01-01'),
(2,80.00,30,'2024-01-01'),
(3,150.00,30,'2024-01-01'),
(4,450.00,365,'2024-01-01');

INSERT INTO Empleado (dni,cargo,fechaIngreso,usuario,password) VALUES
('12345678','Administrador','2023-01-15','admin','admin123'),
('87654321','Recepcionista','2023-02-01','recep','recep123'),
('11223344','Supervisor','2023-01-20','super','super123');

INSERT INTO Entrenador (nombre,certificacion) VALUES
('Roberto Silva',TRUE),
('Ana Martínez',TRUE),
('Luis Rodríguez',FALSE),
('Carmen López',TRUE),
('Miguel Torres',TRUE);

INSERT INTO Actividad (nombre,descripcion,duracion) VALUES
('Yoga','Clase de relajación y flexibilidad',60),
('CrossFit','Entrenamiento funcional',45),
('Pilates','Ejercicios de fortalecimiento',50),
('Spinning','Ciclismo indoor',45),
('Zumba','Baile aeróbico',60);

INSERT INTO Clase (nombre,horaInicio,horaFin,capacidad,idEntrenador,idActividad) VALUES
('Yoga Matutino','07:00:00','08:00:00',15,1,1),
('CrossFit Intenso','18:00:00','18:45:00',20,2,2),
('Pilates Suave','10:00:00','10:50:00',12,3,3),
('Spinning Nocturno','19:00:00','19:45:00',25,4,4),
('Zumba Express','18:30:00','19:30:00',30,5,5);

INSERT INTO Miembro (dni,foto,idTipoMembresia,idMembresia,fechaInicio,fechaFin,descuento) VALUES
('99887766','foto1.jpg',2,2,'2024-01-01','2024-01-31',0.00),
('55443322','foto2.jpg',3,3,'2024-01-01','2024-01-31',10.00),
('12345678','foto3.jpg',1,1,'2024-01-01','2024-01-31',0.00),
('87654321','foto4.jpg',4,4,'2024-01-01','2024-12-31',0.00);

INSERT INTO Lector (tipo,modelo,activo) VALUES
('RFID','Modelo Pro-100',TRUE),
('Código de Barras','Scanner USB-200',TRUE);

INSERT INTO Pago (monto,fechaPago,metodoPago,idMiembro) VALUES
(80.00,'2024-01-01','Tarjeta de Crédito',1),
(135.00,'2024-01-02','Transferencia Bancaria',2),
(50.00,'2024-01-01','Efectivo',3),
(450.00,'2024-01-01','Transferencia Bancaria',4);

SELECT 'Base de datos CuerpoSanoDB ' AS Resultado;


