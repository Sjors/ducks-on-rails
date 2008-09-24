-- Clean up:
UPDATE `ringer_kooikers` 
SET 
    kooiker = NULL, 
    kooiker_vermoed = NULL 
WHERE 1;

UPDATE `captures` c SET method = NULL WHERE method = 'T';

-- Process all the decoy indicators to determine where the decoys are.
-- Elimineer kooien a.d.h.v deze 3 criteria:
-- Criterium 2 en 3 komen slechts in de kooiker_vermoed kolom, omdat het geen 'hard bewijs' is.

-- h1 creates certainty for both true and false
UPDATE `ringer_kooikers` 
SET kooiker = h1 
WHERE h1 IS NOT NULL;

UPDATE `ringer_kooikers` 
SET kooiker_vermoed = false
WHERE 
h1 = false OR h2 = false OR h3 = false;

-- Consider all rid's closer than 12 kilometers from a decoy to be a kooiker (not the other way around because 
-- I am still missing some decoy coordinates):
UPDATE `ringer_kooikers`
SET kooiker_vermoed = true 
WHERE decoy_distance < 12;

UPDATE `coordinate_decoys`
SET kooiker_vermoed = true 
WHERE decoy_distance < 12;

-- Als we zeker weten dat het wel of niet om een kooiker gaat, dan vermoeden we het logischer wijs ook.
UPDATE `ringer_kooikers` 
SET kooiker_vermoed = kooiker 
WHERE kooiker IS NOT NULL;

-- Add all suspected and confirmed decoy ringing events to the Catching Method column:
UPDATE 
    `captures` c
    JOIN `ringer_captures` rC
    ON c.sch = rC.sch AND c.ringnr = rC.ringnr AND c.occ = rC.occ
    JOIN `ringer_kooikers` r
    ON rC.ringer_id = r.rid
SET c.method = 'T'
WHERE kooiker_vermoed = true;

UPDATE 
    `captures` c
    JOIN `capture_coordinates` cC
    ON c.sch = cC.sch AND c.ringnr = cC.ringnr AND c.occ = cC.occ
    JOIN `coordinate_decoys` k
    ON cC.lat = k.lat AND cC.lon = k.lon
SET c.method = 'T'
WHERE kooiker_vermoed = true;

-- We can also use the table coordinateName to look for all coordinates that have "kooi" in
-- their discription. 
UPDATE 
`coordinate_names` cn
JOIN capture_coordinates cc ON cn.lat = cc.lat AND cn.lon=cc.lon
JOIN captures c ON c.occ = cc.occ AND c.sch = cc.sch AND c.ringnr = cc.ringnr
SET method = "T" 
WHERE cn.name LIKE "%kooi%";

