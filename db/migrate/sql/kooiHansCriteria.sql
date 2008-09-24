-- Clean up:
UPDATE `ringer_kooikers` SET
    h1 = NULL,
    h2 = NULL,
    h3 = NULL
WHERE 1;

-- Apply the 3 Hans criteria (mail van 23 juli 2007)
--
--We beginnen met 263 rids
--
-- 1 Alle rids die in het bestand met de HUIDIGE ringers voorkomen zonder vermelding 'EENDENKOOIKER' kunnen er uit.
--
--  Deze stap levert 6 kooien en elimineert 71 rids. De kooien komen ook in de kolom kooiker (zeker).

UPDATE `ringer_kooikers` r 
JOIN `nl_vts_ring_permits` v ON v.JobTitle = r.rid
SET r.h1 = true
WHERE Categories = "Eendenkooiker";

UPDATE `ringer_kooikers` r 
JOIN `nl_vts_ring_permits` v ON v.JobTitle = r.rid
SET r.h1 = false
WHERE Categories != "Eendenkooiker";

-- 2 Alle rids die GEEN volgroeide eenden hebben geringd maar alleen pullen kunnen eruit. Pullen zijn in de database herkenbaar door waarde 1 in veld 'ra'.

UPDATE `ringer_kooikers` r JOIN 
(
SELECT 
DISTINCT ringer_id 
FROM 
    `captures` c 
    JOIN `ringer_captures` rC
    ON c.sch = rC.sch AND c.ringnr = rC.ringnr AND c.occ = rC.occ
WHERE age > 1
) h
ON r.rid = h.ringer_id
SET h2 = true;

-- (Set the rest to false):
UPDATE `ringer_kooikers` set h2 = false WHERE h2 IS NULL;

-- Deze stap elimeerde 27 rids

-- 3 Alle rids die maar zo heel af en toe een eendje hebben gerigd zijn waarschijnlijk ook geen kooikers. Je zou dus alle rids met minder dan 10-20 eenden kunnen afvoeren.
UPDATE `ringer_kooikers` r JOIN
(
SELECT rid, count(*) as c 
FROM 
    `captures` c 
    JOIN `ringer_captures` rC
    ON c.sch = rC.sch AND c.ringnr = rC.ringnr AND c.occ = rC.occ
    JOIN `ringer_kooikers` r 
    ON rC.ringer_id = r.rid
GROUP BY rid
) h
ON r.rid = h.rid
SET h3 = if(c<20, false, true);

-- Deze stap elimineert 152 rids


