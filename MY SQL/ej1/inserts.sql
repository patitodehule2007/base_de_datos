SET FOREIGN_KEY_CHECKS = 0; -- Desactivamos para que no rebote por el orden de inserción

USE TorneoJuegitos;

-- 1. VIDEOJUEGOS
INSERT INTO video_Juegos (id_juego, nombre, genero, clasificacion_edad) VALUES 
(1, 'Counter-Strike 2', 'FPS', 18),
(2, 'League of Legends', 'MOBA', 12),
(3, 'Valorant', 'Tactical Shooter', 16),
(4, 'Rocket League', 'Sports', 0);

-- 2. EQUIPOS
INSERT INTO Equipos (id_equipo, nombre_equipo, id_capitan) VALUES 
(1, 'La Scaloneta Gaming', 1),
(2, 'Mate Cosido Clan', 3),
(3, 'Empanada Tucumana Esports', 5),
(4, 'Ciruja Team', 7);

-- 3. JUGADORES (Aquí el id_jugador DEBE coincidir con el id_equipo por tu CONSTRAINT)
-- Nota: En tu diseño actual, el id_jugador 1 pertenece al equipo 1 por la FK.
INSERT INTO Jugadores (id_jugador, nombre, apellido, email, fecha_nacimiento, pais, id_equipo) VALUES 
(1, 'Bautista', 'Pérez', 'bauti.perez@gmail.com', '2001-03-15', 'Argentina',1),
(2, 'Franco', 'Armani', 'elpulpo@hotmail.com', '1995-10-22', 'Argentina',1),
(3, 'Enzo', 'Fernández', 'enzo.f@outlook.com', '2000-01-17', 'Argentina',2),
(4, 'Julián', 'Álvarez', 'araña.calchin@yahoo.com.ar', '2002-05-30', 'Argentina',3),
(5, 'Martina', 'García', 'martu_juegos@gmail.com', '1999-08-12', 'Argentina',4),
(6, 'Sofía', 'Rodríguez', 'sofi.rod@live.com.ar', '2003-11-04', 'Argentina',3),
(7, 'Mateo', 'López', 'teito_lp@gmail.com', '2004-02-28', 'Argentina',2),
(8, 'Lucía', 'Sánchez', 'lu.sanchez99@gmail.com', '1999-12-31', 'Argentina',1);

-- 4. TORNEOS
INSERT INTO torneo (id_torneo, nombre, fecha_inicio, fecha_fin, premio_usd, id_juego) VALUES 
(1, 'Gran Torneo del Obelisco', '2024-05-01 18:00:00', '2024-05-05 22:00:00', 10000, 1),
(2, 'Copa Argentina LoL', '2024-06-10 14:00:00', '2024-07-10 20:00:00', 5000, 2);

-- 5. RELACIÓN EQUIPOS Y TORNEOS
INSERT INTO Equipos_has_torneos (eht_id_torneo, eht_id_equipo) VALUES 
(1, 1), (1, 2), (2, 3), (2, 4);

SET FOREIGN_KEY_CHECKS = 1; -- Las reactivamos para mantener la integridad





