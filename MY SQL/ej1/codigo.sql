

# 1 
SELECT * FROM Jugadores j 
ORDER BY apellido ASC ;

# 2
SELECT * FROM video_Juegos vj  
WHERE vj.clasificacion_edad  >= 16;

# 3
SELECT e.*, j.nombre ,j.apellido  FROM Equipos e 
 JOIN Jugadores j ON e.id_capitan  = j.id_jugador ;
 
# 4
 
 SELECT e.nombre_equipo ,t.nombre ,eht.fecha_inscripcion ,eht.fecha_inscripcion  FROM Equipos e 
 JOIN Equipos_has_torneos eht ON eht.eht_id_equipo = e.id_equipo 
 JOIN torneo t  ON eht.eht_id_torneo = t.id_torneo ;
 
# 5
 SELECT j.pais  ,count(*) AS num_Jugadores FROM Jugadores j 
 GROUP BY j.pais ;
 
#6
SELECT sum(premio_usd) FROM torneo;

#7
SELECT genero, avg(clasificacion_edad) AS edad_minima FROM video_Juegos
GROUP BY genero;


#8
SELECT * FROM Equipos e
WHERE e.id_equipo  IN(
	SELECT e2.id_equipo FROM Equipos e2
	JOIN Equipos_has_torneos eht ON eht.eht_id_equipo = e2.id_equipo
	GROUP BY e2.id_equipo
	HAVING count(e2.id_equipo) > 1

);

#9
SELECT * FROM torneo t 
ORDER BY t.premio_usd
LIMIT 5;

# 10



SELECT * FROM Jugadores j
JOIN Equipos e ON e.id_equipo  =  j.id_equipo 
WHERE e.id_equipo  in(
	SELECT eht.eht_id_equipo  FROM Equipos_has_torneos eht 
	WHERE eht.posicion  = 1
);

#11
SELECT vj.*, count(*) AS "Numero de torneos"  FROM video_Juegos vj 
JOIN torneo  t ON t.id_torneo = vj.id_juego
GROUP BY vj.id_juego
ORDER BY vj.id_juego DESC
LIMIT 1;

#12

SELECT  * FROM Jugadores j 
WHERE j.fecha_nacimiento  IN (
	SELECT min(j2.fecha_nacimiento) FROM Jugadores j2 
	GROUP BY j.pais 

)

#13

UPDATE torneo 
SET premio_usd = premio_usd * 2
	WHERE id_torneo 
	in( 
		SELECT aux.id_torneo from(
			SELECT t.id_torneo FROM torneo t 
			JOIN Equipos_has_torneos eht ON eht.eht_id_torneo  = t.id_torneo 
			GROUP BY t.id_torneo 
			having count(*) < 3
		) AS aux
	);


#14


UPDATE video_Juegos 
SET nombre  = CONCAT(nombre , ' [Popular]')
WHERE id_juego in(
SELECT aux.id_juego FROM(
SELECT t.id_juego  FROM torneo t 
JOIN Equipos_has_torneos eht ON eht.eht_id_torneo  = t.id_torneo 
JOIN video_Juegos vj ON vj.id_juego = t.id_juego 
GROUP BY t.id_torneo 
having count(*) >= 2
) AS aux
);

SELECT  * FROM video_Juegos vj 

# 15

UPDATE video_Juegos vj 
SET clasificacion_edad  = (
SELECT aux.avg_edad from( SELECT avg(vj2.clasificacion_edad ) AS avg_edad FROM video_Juegos vj2 
WHERE vj2.genero = vj.genero ) AS aux );

# 16

DELETE FROM Jugadores 
WHERE isNUll(id_equipo);

#17

DELETE FROM Equipos  
WHERE id_equipo NOT in(
	SELECT aux.eht_id_equipo FROM(
		SELECT eht.eht_id_equipo FROM Equipos_has_torneos eht   
		WHERE eht.posicion  <= 3
	) AS aux
)


 
 
 