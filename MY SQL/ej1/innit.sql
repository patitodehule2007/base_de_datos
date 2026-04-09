DROP DATABASE IF EXISTS TorneoJuegitos;

CREATE DATABASE  TorneoJuegitos;

USE TorneoJuegitos;

CREATE TABLE IF NOT EXISTS Equipos(
	id_equipo integer PRIMARY KEY AUTO_INCREMENT,
	nombre_equipo varchar(256),
	id_capitan integer
		
);

CREATE TABLE IF NOT EXISTS Jugadores(
	id_jugador integer PRIMARY KEY AUTO_INCREMENT,
	nombre varchar(256),
	apellido varchar(256),
	email varchar(256),
	fecha_nacimiento TIMESTAMP ,
	pais varchar(256),
	id_equipo integer,
	CONSTRAINT fk_id_jugador_id_equipo
	foreign KEY (id_equipo)
	REFERENCES Equipos(id_equipo)
);



ALTER TABLE Equipos ADD CONSTRAINT
	fk_id_capitan_id_usuario
	foreign KEY (id_capitan)
REFERENCES Jugadores(id_jugador);


CREATE TABLE video_Juegos(
	id_juego integer PRIMARY KEY AUTO_INCREMENT,
	nombre varchar(250), 
	genero varchar(250),
	clasificacion_edad integer

);


CREATE TABLE torneo(
	id_torneo integer PRIMARY KEY AUTO_INCREMENT,
	nombre varchar(256), 
	fecha_inicio DATETIME,
	fecha_fin DATETIME ,
	premio_usd integer,
	
	id_juego integer,
	
	CONSTRAINT checkear_fecha CHECK (fecha_inicio <= fecha_fin),
	
	CONSTRAINT checkear_premio CHECK (premio_usd >= 0),
	
	CONSTRAINT fk_torneo_id_juego_id_juego
	foreign KEY (id_juego)
	REFERENCES video_Juegos(id_juego)
);





CREATE TABLE Equipos_has_torneos(
	eht_id_torneo integer,
	eht_id_equipo integer,
		posicion integer,
		fecha_inscripcion timestamp,
	PRIMARY KEY (eht_id_torneo, eht_id_equipo),
	
	CONSTRAINT fk_eht_id_torneo
	foreign KEY (eht_id_torneo)
	REFERENCES torneo(id_torneo),

	CONSTRAINT fk_eht_id_equipo
	foreign KEY (eht_id_equipo)
	REFERENCES Equipos(id_equipo)
);







