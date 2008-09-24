-- Clean up:
UPDATE `coordinate_decoys` SET h2 = NULL WHERE 1;

-- Van de ringen zonder rid zijn er een aantal die qua locatie overlappen met een bestaande rid.
-- Een deel daarvan ligt in de buurt van de buurt van een kooi. 
-- Wellicht zijn deze eenden in een kooi geringd, maar niet door de kooiker,
-- of wellicht zijn ze wel door de kooiker geringd maar is de rid niet ingevoerd.

-- Allereerst passen we het Hans 2 criterium toe, dus elimineren we alle locaties waar alleen 
-- pullen geringd zijn.

UPDATE `coordinate_decoys` c JOIN 
(
    SELECT lon, lat
    FROM 
        `captures` c
        JOIN `capture_coordinates` cC
        ON c.sch = cC.sch AND c.ringnr = cC.ringnr AND c.occ = cC.occ
        JOIN `ringer_captures` rC
        ON c.sch = rC.sch AND c.ringnr = rC.ringnr AND c.occ = rC.occ
    WHERE 
        age > 1 AND 
        ringer_id IS NULL
    GROUP BY lon, lat
) h
ON c.lon = h.lon AND c.lat = h.lat
SET h2 = true;

-- (Set the rest to false):
UPDATE `coordinate_decoys` set h2 = false WHERE h2 IS NULL;

-- Deze stap elimineert 49 locaties.
