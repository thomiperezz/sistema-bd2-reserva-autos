CREATE TABLE Vehiculos (
	marca TEXT,
	ultima_letra_patente TEXT,
	patente TEXT,
	id_vehiculo INT,
	id_conductor INT,
	modelo TEXT,
	PRIMARY KEY((marca,ultima_letra_patente),patente,id_vehiculo));

INSERT INTO Vehiculos (patente, marca, ultima_letra_patente, id_vehiculo, id_conductor, modelo)
VALUES ('ABC123', 'Toyota', '3', 1, 1, 'Corolla');

INSERT INTO Vehiculos (patente, marca, ultima_letra_patente, id_vehiculo, id_conductor, modelo)
VALUES ('XYZ789', 'Ford', '9', 2, 2, 'Fiesta');

INSERT INTO Vehiculos (patente, marca, ultima_letra_patente, id_vehiculo, id_conductor, modelo)
VALUES ('LMN456', 'Chevrolet', '6', 3, 3, 'Onix');

INSERT INTO Vehiculos (patente, marca, ultima_letra_patente, id_vehiculo, id_conductor, modelo)
VALUES ('DEF321', 'Volkswagen', '1', 4, 4, 'Polo');

INSERT INTO Vehiculos (patente, marca, ultima_letra_patente, id_vehiculo, id_conductor, modelo)
VALUES ('GHI654', 'Honda', '4', 5, 5, 'Civic');

INSERT INTO Vehiculos (patente, marca, ultima_letra_patente, id_vehiculo, id_conductor, modelo)
VALUES ('GJI85D', 'Toyota', 'D', 5, 5, 'Sedán');

CREATE TABLE resenas (
	id_resena INT,
	id_usuario INT,
	calificacion INT,
	PRIMARY KEY(id_resena));

INSERT INTO resenas (id_resena, id_usuario, calificacion) VALUES (1, 1, 5);
INSERT INTO resenas (id_resena, id_usuario, calificacion) VALUES (2, 2, 4);
INSERT INTO resenas (id_resena, id_usuario, calificacion) VALUES (3, 3, 3);
INSERT INTO resenas (id_resena, id_usuario, calificacion) VALUES (4, 4, 2);
INSERT INTO resenas (id_resena, id_usuario, calificacion) VALUES (5, 5, 1);
