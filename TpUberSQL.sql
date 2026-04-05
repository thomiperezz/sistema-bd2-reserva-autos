create database UBER2

create table Usuarios(
id_usuario int,
nombre varchar(100),
apellido varchar(100),
mail varchar(100),
telefono int,
constraint Usuarios_PK primary key(id_usuario)
);

create table Conductor(
id_conductor int,
nombre varchar(100),
apellido varchar(100),
mail varchar(100),
telefono int,
constraint Conductors_PK primary key(id_conductor)
);

create table Veiculo(
id_veiculo int,
id_conductor int,
marca varchar(100),
patente varchar(100),
modelo varchar(100),
constraint Veiculo_PK primary key(id_veiculo),
constraint Veiculo_Conductor_FK foreign key (id_conductor) references Conductor(id_conductor)
);

create table ubicacionVeiculo(
id_ubicacion int,
id_veiculo int,
estado varchar(100),
latitud DECIMAL(9, 6),
longitud DECIMAL(9, 6),
timestamp DATETIME,
constraint ubicacionVeiculo_PK primary key(id_ubicacion),
constraint ubicacionVeiculo_Veiculo_FK foreign key(id_veiculo) references Veiculo(id_veiculo)
);

create table Viaje(
id_viaje int,
id_usuario int,
id_conductor int,
id_veiculo int,
punto_partida VARCHAR(100),
destino VARCHAR(100),
distancia DECIMAL(5, 2),
tiempo_viaje TIME,
estado varchar(100),
fecha_hora_inicio DATETIME,
fecha_hora_final DATETIME,
constraint Viaje_PK primary key(id_viaje),
constraint Usuarios_Viaje_FK foreign key(id_usuario) references Usuarios(id_usuario),
constraint Conductor_Viaje_FK foreign key(id_conductor) references Conductor(id_conductor),
constraint Veiculo_Viaje_FK foreign key(id_veiculo) references Veiculo(id_veiculo)
);

create table Pago(
id_pago int,
id_viaje int,
fechaPago date,
total int,
estado varchar(100),
metodoDePago varchar(100),
constraint Pago_PK primary key(id_pago),
constraint Pago_Viaje_FK foreign key(id_viaje) references Viaje(id_viaje)
);

create table Reseña(
id_reseña int,
id_usuario int,
id_viaje int,
calificacion int,
reseña varchar(200),
constraint Reseña_PK primary key(id_reseña),
constraint Reseña_Usuarios_FK foreign key(id_Usuario) references Usuarios(id_usuario),
constraint Reseña_Viaje_FK foreign key(id_viaje) references Viaje(id_viaje)
);

CREATE PROCEDURE ingresarUsuario
    @idUsuario INT,
    @nombre VARCHAR(100),
    @apellido VARCHAR(100),
    @mail VARCHAR(100),
    @telefono INT
AS
BEGIN
    INSERT INTO Usuarios (id_usuario, nombre, apellido, mail, telefono)
    VALUES (@idUsuario, @nombre, @apellido, @mail, @telefono);
END

CREATE PROCEDURE ingresarConductor
    @idConductor INT,
    @nombre VARCHAR(100),
    @apellido VARCHAR(100),
    @mail VARCHAR(100),
    @telefono INT
AS
BEGIN
    INSERT INTO Conductor (id_conductor, nombre, apellido, mail, telefono)
    VALUES (@idConductor, @nombre, @apellido, @mail, @telefono);
END

CREATE PROCEDURE ingresarVehiculo
    @idVehiculo INT,
    @idConductor INT,
    @marca VARCHAR(100),
    @patente VARCHAR(100),
    @modelo VARCHAR(100)
AS
BEGIN
    INSERT INTO Veiculo (id_veiculo, id_conductor, marca, patente, modelo)
    VALUES (@idVehiculo, @idConductor, @marca, @patente, @modelo);
END

CREATE PROCEDURE ingresarViaje
    @idViaje INT,
    @idUsuario INT,
    @idConductor INT,
    @idVehiculo INT,
    @puntoPartida VARCHAR(100),
    @destino VARCHAR(100),
    @distancia DECIMAL(5,2),
    @tiempoViaje TIME,
    @estado VARCHAR(100),
    @fechaHoraInicio DATETIME,
    @fechaHoraFinal DATETIME
AS
BEGIN
    INSERT INTO Viaje (id_viaje, id_usuario, id_conductor, id_veiculo, punto_partida, destino, distancia, tiempo_viaje, estado, fecha_hora_inicio, fecha_hora_final)
    VALUES (@idViaje, @idUsuario, @idConductor, @idVehiculo, @puntoPartida, @destino, @distancia, @tiempoViaje, @estado, @fechaHoraInicio, @fechaHoraFinal);
END

CREATE PROCEDURE ingresarPago
    @idPago INT,
    @idViaje INT,
    @fechaPago DATE,
    @total INT,
    @estado VARCHAR(100),
    @metodoDePago VARCHAR(100)
AS
BEGIN
    INSERT INTO Pago (id_pago, id_viaje, fechaPago, total, estado, metodoDePago)
    VALUES (@idPago, @idViaje, @fechaPago, @total, @estado, @metodoDePago);
END

CREATE PROCEDURE ingresarReseña
    @idReseña INT,
    @idUsuario INT,
    @idViaje INT,
    @calificacion INT,
    @reseña VARCHAR(200)
AS
BEGIN
    INSERT INTO Reseña (id_reseña, id_usuario, id_viaje, calificacion, reseña)
    VALUES (@idReseña, @idUsuario, @idViaje, @calificacion, @reseña);
END

CREATE PROCEDURE ingresarUbicacionVehiculo
    @idUbicacion INT,
    @idVehiculo INT,
    @estado VARCHAR(100),
    @latitud DECIMAL(9,6),
    @longitud DECIMAL(9,6),
    @timestamp DATETIME
AS
BEGIN
    INSERT INTO ubicacionVeiculo (id_ubicacion, id_veiculo, estado, latitud, longitud, timestamp)
    VALUES (@idUbicacion, @idVehiculo, @estado, @latitud, @longitud, @timestamp);
END

CREATE PROCEDURE leerUsuarios
AS
BEGIN
    SELECT *FROM Usuarios;
END

CREATE PROCEDURE leerConductores
AS
BEGIN
    SELECT *FROM Conductor;
END

CREATE PROCEDURE leerVehiculos
AS
BEGIN
    SELECT *FROM Veiculo;
END

CREATE PROCEDURE leerUbicacionesVehiculos2
AS
BEGIN
    SELECT *FROM ubicacionVeiculo;
END

CREATE PROCEDURE leerViajes
AS
BEGIN
    SELECT *FROM Viaje;
END

CREATE PROCEDURE leerPagos
AS
BEGIN
    SELECT *FROM Pago;
END

CREATE PROCEDURE leerReseñas
AS
BEGIN
    SELECT *FROM Reseña;
END

CREATE PROCEDURE actualizarUsuario
    @id_usuario INT,
    @nombre VARCHAR(100),
    @apellido VARCHAR(100),
    @mail VARCHAR(100),
    @telefono INT
AS
BEGIN
    UPDATE Usuarios
    SET nombre = @nombre,
        apellido = @apellido,
        mail = @mail,
        telefono = @telefono
    WHERE id_usuario = @id_usuario;
END

CREATE PROCEDURE actualizarConductor
    @id_conductor INT,
    @nombre VARCHAR(100),
    @apellido VARCHAR(100),
    @mail VARCHAR(100),
    @telefono INT
AS
BEGIN
    UPDATE Conductor
    SET nombre = @nombre,
        apellido = @apellido,
        mail = @mail,
        telefono = @telefono
    WHERE id_conductor = @id_conductor;
END

CREATE PROCEDURE actualizarVehiculo
    @id_veiculo INT,
    @id_conductor INT,
    @marca VARCHAR(100),
    @patente VARCHAR(100),
    @modelo VARCHAR(100)
AS
BEGIN
    UPDATE Veiculo
    SET id_conductor = @id_conductor,
        marca = @marca,
        patente = @patente,
        modelo = @modelo
    WHERE id_veiculo = @id_veiculo;
END

CREATE PROCEDURE actualizarUbicacionVehiculo
    @id_ubicacion INT,
    @id_veiculo INT,
    @estado VARCHAR(100),
    @latitud DECIMAL(9,6),
    @longitud DECIMAL(9,6),
    @timestamp DATETIME
AS
BEGIN
    UPDATE ubicacionVeiculo
    SET id_veiculo = @id_veiculo,
        estado = @estado,
        latitud = @latitud,
        longitud = @longitud,
        timestamp = @timestamp
    WHERE id_ubicacion = @id_ubicacion;
END

CREATE PROCEDURE actualizarViaje
    @id_viaje INT,
    @id_usuario INT,
    @id_conductor INT,
    @id_veiculo INT,
    @punto_partida VARCHAR(100),
    @destino VARCHAR(100),
    @distancia DECIMAL(5,2),
    @tiempo_viaje TIME,
    @estado VARCHAR(100),
    @fecha_hora_inicio DATETIME,
    @fecha_hora_final DATETIME
AS
BEGIN
    UPDATE Viaje
    SET id_usuario = @id_usuario,
        id_conductor = @id_conductor,
        id_veiculo = @id_veiculo,
        punto_partida = @punto_partida,
        destino = @destino,
        distancia = @distancia,
        tiempo_viaje = @tiempo_viaje,
        estado = @estado,
        fecha_hora_inicio = @fecha_hora_inicio,
        fecha_hora_final = @fecha_hora_final
    WHERE id_viaje = @id_viaje;
END

CREATE PROCEDURE actualizarPago
    @id_pago INT,
    @id_viaje INT,
    @fechaPago DATE,
    @total INT,
    @estado VARCHAR(100),
    @metodoDePago VARCHAR(100)
AS
BEGIN
    UPDATE Pago
    SET id_viaje = @id_viaje,
        fechaPago = @fechaPago,
        total = @total,
        estado = @estado,
        metodoDePago = @metodoDePago
    WHERE id_pago = @id_pago;
END

CREATE PROCEDURE actualizarResena
    @id_reseña INT,
    @id_usuario INT,
    @id_viaje INT,
    @calificacion INT,
    @reseña VARCHAR(200)
AS
BEGIN
    UPDATE Reseña
    SET id_usuario = @id_usuario,
        id_viaje = @id_viaje,
        calificacion = @calificacion,
        reseña = @reseña
    WHERE id_reseña = @id_reseña;
END

CREATE PROCEDURE borrarTablas
AS
BEGIN
    -- Desactivar restricciones de clave foránea
    ALTER TABLE Reseña NOCHECK CONSTRAINT Reseña_Usuarios_FK;
    ALTER TABLE Reseña NOCHECK CONSTRAINT Reseña_Viaje_FK;
    ALTER TABLE Pago NOCHECK CONSTRAINT Pago_Viaje_FK;
    ALTER TABLE Viaje NOCHECK CONSTRAINT Usuarios_Viaje_FK;
    ALTER TABLE Viaje NOCHECK CONSTRAINT Conductor_Viaje_FK;
    ALTER TABLE Viaje NOCHECK CONSTRAINT Veiculo_Viaje_FK;
    ALTER TABLE ubicacionVeiculo NOCHECK CONSTRAINT ubicacionVeiculo_Veiculo_FK;
    ALTER TABLE Veiculo NOCHECK CONSTRAINT Veiculo_Conductor_FK;

    -- Borrar datos de las tablas
    DELETE FROM Reseña;
    DELETE FROM Pago;
    DELETE FROM Viaje;
    DELETE FROM ubicacionVeiculo;
    DELETE FROM Veiculo;
    DELETE FROM Conductor;
    DELETE FROM Usuarios;

    -- Rehabilitar restricciones de clave foránea
    ALTER TABLE Reseña WITH CHECK CHECK CONSTRAINT Reseña_Usuarios_FK;
    ALTER TABLE Reseña WITH CHECK CHECK CONSTRAINT Reseña_Viaje_FK;
    ALTER TABLE Pago WITH CHECK CHECK CONSTRAINT Pago_Viaje_FK;
    ALTER TABLE Viaje WITH CHECK CHECK CONSTRAINT Usuarios_Viaje_FK;
    ALTER TABLE Viaje WITH CHECK CHECK CONSTRAINT Conductor_Viaje_FK;
    ALTER TABLE Viaje WITH CHECK CHECK CONSTRAINT Veiculo_Viaje_FK;
    ALTER TABLE ubicacionVeiculo WITH CHECK CHECK CONSTRAINT ubicacionVeiculo_Veiculo_FK;
    ALTER TABLE Veiculo WITH CHECK CHECK CONSTRAINT Veiculo_Conductor_FK;
END

/*top 3 de usuarios que realizan mas reseñas*/
SELECT TOP 3 id_usuario, COUNT(*) AS total_reseñas
FROM Reseña
GROUP BY id_usuario
ORDER BY total_reseñas DESC;


/*¿Cual es el metodo de pago menos utilizado en la plataforma?*/
SELECT TOP 1 metodoDePago, COUNT(*) AS total_uso
FROM Pago
GROUP BY metodoDePago
ORDER BY total_uso ASC;

/*¿Cuales son los conductores que han estado inactivos en el ultimo mes?*/
SELECT c.id_conductor, c.nombre -- Asegúrate de que esta columna exista en tu tabla Conductor
FROM Conductor c
LEFT JOIN Viaje v ON c.id_conductor = v.id_conductor AND v.fecha_hora_inicio >= DATEADD(MONTH, -1, GETDATE())
WHERE v.id_viaje IS NULL;


/*cual es el tiempo promedio de los viajes*/
SELECT 
    CONVERT(VARCHAR, DATEADD(SECOND, AVG(DATEDIFF(SECOND, '00:00:00', tiempo_viaje)), '00:00:00'), 108) AS TiempoPromedio
FROM Viaje;

/*que conductores y pasajeros han coincidido mas de un viaje*/
SELECT 
    v.id_conductor, v.id_usuario, COUNT(v.id_viaje) AS total_viajes FROM  Viaje v
GROUP BY v.id_conductor, v.id_usuario
HAVING COUNT(v.id_viaje) > 1;

/*Autos de toyota que su patente termine en D*/
SELECT COUNT(*) AS total_veiculos
FROM Veiculo
WHERE marca = 'Toyota' AND patente LIKE '%D';


/*seleccionar los usuarios que escribieron una reseña de 5 o menos 2 estrellas*/
SELECT DISTINCT id_usuario
FROM Reseña
WHERE calificacion = 5 OR calificacion <= 2;


INSERT INTO Usuarios (id_usuario, nombre, apellido, mail, telefono) VALUES (1, 'Juan', 'Pérez', 'juan.perez@example.com', 123456789);
INSERT INTO Usuarios (id_usuario, nombre, apellido, mail, telefono) VALUES (2, 'María', 'Gómez', 'maria.gomez@example.com', 987654321);
INSERT INTO Usuarios (id_usuario, nombre, apellido, mail, telefono) VALUES (3, 'Carlos', 'López', 'carlos.lopez@example.com', 456123789);
INSERT INTO Usuarios (id_usuario, nombre, apellido, mail, telefono) VALUES (4, 'Ana', 'Torres', 'ana.torres@example.com', 321654987);
INSERT INTO Usuarios (id_usuario, nombre, apellido, mail, telefono) VALUES (5, 'Laura', 'Fernández', 'laura.fernandez@example.com', 654789123);

INSERT INTO Conductor (id_conductor, nombre, apellido, mail, telefono) VALUES (1, 'Pedro', 'Sánchez', 'pedro.sanchez@example.com', 111222333);
INSERT INTO Conductor (id_conductor, nombre, apellido, mail, telefono) VALUES (2, 'Lucía', 'Martínez', 'lucia.martinez@example.com', 444555666);
INSERT INTO Conductor (id_conductor, nombre, apellido, mail, telefono) VALUES (3, 'Javier', 'Ramírez', 'javier.ramirez@example.com', 777888999);
INSERT INTO Conductor (id_conductor, nombre, apellido, mail, telefono) VALUES (4, 'Elena', 'García', 'elena.garcia@example.com', 333444555);
INSERT INTO Conductor (id_conductor, nombre, apellido, mail, telefono) VALUES (5, 'Mario', 'Hernández', 'mario.hernandez@example.com', 666777888);
INSERT INTO Conductor (id_conductor, nombre, apellido, mail, telefono) VALUES (6, 'Maximo', 'Suarez', 'mario.hernandez@example.com', 666777888);

INSERT INTO Veiculo (id_veiculo, id_conductor, marca, patente, modelo) VALUES (1, 1, 'Toyota', 'ABC123', 'Corolla');
INSERT INTO Veiculo (id_veiculo, id_conductor, marca, patente, modelo) VALUES (2, 2, 'Ford', 'DEF456', 'Fiesta');
INSERT INTO Veiculo (id_veiculo, id_conductor, marca, patente, modelo) VALUES (3, 3, 'Chevrolet', 'GHI789', 'Onix');
INSERT INTO Veiculo (id_veiculo, id_conductor, marca, patente, modelo) VALUES (4, 4, 'Nissan', 'JKL012', 'Versa');
INSERT INTO Veiculo (id_veiculo, id_conductor, marca, patente, modelo) VALUES (5, 5, 'Hyundai', 'MNO345', 'Elantra');
INSERT INTO Veiculo (id_veiculo, id_conductor, marca, patente, modelo) VALUES (6, 1, 'Toyota', 'ABC12D', 'Corolla');


INSERT INTO ubicacionVeiculo (id_ubicacion, id_veiculo, estado, latitud, longitud, timestamp) VALUES (1, 1, 'Disponible', 40.712776, -74.005974, '2024-10-01 12:00:00');
INSERT INTO ubicacionVeiculo (id_ubicacion, id_veiculo, estado, latitud, longitud, timestamp) VALUES (2, 2, 'En viaje', 34.052235, -118.243683, '2024-10-01 12:05:00');
INSERT INTO ubicacionVeiculo (id_ubicacion, id_veiculo, estado, latitud, longitud, timestamp) VALUES (3, 3, 'Disponible', 51.507351, -0.127758, '2024-10-01 12:10:00');
INSERT INTO ubicacionVeiculo (id_ubicacion, id_veiculo, estado, latitud, longitud, timestamp) VALUES (4, 4, 'En espera', 48.856613, 2.352222, '2024-10-01 12:15:00');
INSERT INTO ubicacionVeiculo (id_ubicacion, id_veiculo, estado, latitud, longitud, timestamp) VALUES (5, 5, 'En viaje', 35.689487, 139.691711, '2024-10-01 12:20:00');

INSERT INTO Viaje (id_viaje, id_usuario, id_conductor, id_veiculo, punto_partida, destino, distancia, tiempo_viaje, estado, fecha_hora_inicio, fecha_hora_final) VALUES (1, 1, 1, 1, 'Centro', 'Aeropuerto', 25.00, '00:30:00', 'Completado', '2024-10-01 10:00:00', '2024-10-01 10:30:00');
INSERT INTO Viaje (id_viaje, id_usuario, id_conductor, id_veiculo, punto_partida, destino, distancia, tiempo_viaje, estado, fecha_hora_inicio, fecha_hora_final) VALUES (2, 2, 2, 2, 'Plaza', 'Estadio', 10.50, '00:15:00', 'Completado', '2024-10-01 11:00:00', '2024-10-01 11:15:00');
INSERT INTO Viaje (id_viaje, id_usuario, id_conductor, id_veiculo, punto_partida, destino, distancia, tiempo_viaje, estado, fecha_hora_inicio, fecha_hora_final) VALUES (3, 3, 3, 3, 'Parque', 'Museo', 5.00, '00:10:00', 'Completado', '2024-10-01 12:00:00', '2024-10-01 12:10:00');
INSERT INTO Viaje (id_viaje, id_usuario, id_conductor, id_veiculo, punto_partida, destino, distancia, tiempo_viaje, estado, fecha_hora_inicio, fecha_hora_final) VALUES (4, 4, 4, 4, 'Cine', 'Casa', 2.75, '00:05:00', 'Completado', '2024-10-01 13:00:00', '2024-10-01 13:05:00');
INSERT INTO Viaje (id_viaje, id_usuario, id_conductor, id_veiculo, punto_partida, destino, distancia, tiempo_viaje, estado, fecha_hora_inicio, fecha_hora_final) VALUES (5, 5, 5, 5, 'Oficina', 'Centro', 3.50, '00:08:00', 'Completado', '2024-10-01 14:00:00', '2024-10-01 14:08:00');
INSERT INTO Viaje (id_viaje, id_usuario, id_conductor, id_veiculo, punto_partida, destino, distancia, tiempo_viaje, estado, fecha_hora_inicio, fecha_hora_final) VALUES (6, 1, 1, 1, 'Centro', 'Aeropuerto', 25.00, '00:30:00', 'Completado', '2024-10-01 10:00:00', '2024-10-01 10:30:00');
INSERT INTO Viaje (id_viaje, id_usuario, id_conductor, id_veiculo, punto_partida, destino, distancia, tiempo_viaje, estado, fecha_hora_inicio, fecha_hora_final) VALUES (7, 1, 1, 1, 'Centro', 'Aeropuerto', 25.00, '00:30:00', 'Completado', '2024-7-01 10:00:00', '2024-7-01 10:30:00');
INSERT INTO Viaje (id_viaje, id_usuario, id_conductor, id_veiculo, punto_partida, destino, distancia, tiempo_viaje, estado, fecha_hora_inicio, fecha_hora_final) VALUES (8, 1, 6, 1, 'Centro', 'Aeropuerto', 25.00, '00:30:00', 'Completado', '2024-7-01 10:00:00', '2024-7-01 10:30:00');

INSERT INTO Pago (id_pago, id_viaje, fechaPago, total, estado, metodoDePago) VALUES (1, 1, '2024-10-01', 1500, 'Completado', 'Tarjeta');
INSERT INTO Pago (id_pago, id_viaje, fechaPago, total, estado, metodoDePago) VALUES (2, 2, '2024-10-01', 700, 'Completado', 'Efectivo');
INSERT INTO Pago (id_pago, id_viaje, fechaPago, total, estado, metodoDePago) VALUES (3, 3, '2024-10-01', 300, 'Completado', 'Tarjeta');
INSERT INTO Pago (id_pago, id_viaje, fechaPago, total, estado, metodoDePago) VALUES (4, 4, '2024-10-01', 100, 'Completado', 'Efectivo');
INSERT INTO Pago (id_pago, id_viaje, fechaPago, total, estado, metodoDePago) VALUES (5, 5, '2024-10-01', 200, 'Completado', 'Tarjeta');

INSERT INTO Reseña (id_reseña, id_usuario, id_viaje, calificacion, reseña) VALUES (1, 1, 1, 5, 'Excelente servicio!');
INSERT INTO Reseña (id_reseña, id_usuario, id_viaje, calificacion, reseña) VALUES (2, 2, 2, 4, 'Buen viaje, conductor amable.');
INSERT INTO Reseña (id_reseña, id_usuario, id_viaje, calificacion, reseña) VALUES (3, 3, 3, 3, 'Viaje regular, podría mejorar.');
INSERT INTO Reseña (id_reseña, id_usuario, id_viaje, calificacion, reseña) VALUES (4, 4, 4, 2, 'No fue lo que esperaba.');
