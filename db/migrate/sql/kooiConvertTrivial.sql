-- Clean up:
DELETE FROM `duck_decoys` WHERE 1;
DELETE FROM `ringer_kooikers` WHERE 1;

-- Populate the table with colums that do not need extra processing:
 INSERT INTO `duck_decoys` 
 	( 
		id, 
		naam, 
		gemeente, 
		registratienummer, 
		duur_nummer, 
		kadasteromschrijving 
	)
 SELECT 
 	id, 
	naam_eendenkooi, 
	gemeente, 
	registratienummer, 
	dur_nummer, 
	kadastrale_omschrijving
 FROM `raw_decoys`
 WHERE 1;

-- Convert coordinates to decimal format
-- Ignores quadrant information and assumes North East (which is ok for the Netherlands)

UPDATE  `duck_decoys` AS e
	JOIN (`raw_decoys` AS r) 
	ON ( e.id = r.id )
SET 
	e.lat = SUBSTRING(r.coordinaten,1,2) + SUBSTRING(r.coordinaten, 4,2)/60 ,
	e.lon = SUBSTRING(r.coordinaten,10,2) + SUBSTRING(r.coordinaten, 13,2)/60
WHERE 
	SUBSTRING(r.coordinaten,7,1) = 'N' AND
	SUBSTRING(r.coordinaten,16,1) = 'E';

UPDATE  `duck_decoys` AS e
	JOIN (`raw_decoys` AS r) 
	ON ( e.id = r.id )
SET 
	e.lat = NULL,
	e.lon = NULL
WHERE 
	SUBSTRING(r.coordinaten,7,1) != 'N' AND
	SUBSTRING(r.coordinaten,16,1) != 'E';

INSERT INTO `ringer_kooikers` (rid)
SELECT DISTINCT ringer_id
FROM 
    `captures` c 
    JOIN `ringer_captures` rC 
    ON c.sch = rC.sch AND c.ringnr = rC.ringnr AND c.occ = rC.occ
    JOIN `capture_coordinates` cC 
    ON c.sch = cC.sch AND c.ringnr = cC.ringnr AND c.occ = cC.occ
    JOIN `capture_countries` cCo 
    ON c.sch = cCo.sch AND c.ringnr = cCo.ringnr AND c.occ = cCo.occ
WHERE 
cCo.country_id = "NL" AND 
c.occ = 1;

