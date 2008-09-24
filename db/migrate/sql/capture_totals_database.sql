-- For all species in `capture_totals` count the number of captures
-- in the Netherlands per year. Distinguish between ringing events 
-- (occ = 0) and recaptures (occ > 1).

DELETE FROM `capture_totals` WHERE source = 'database';

-- Pullus
INSERT INTO `capture_totals` 
SELECT YEAR(date), species_id,'young','NL','database',NULL,c.occ, COUNT(c.sch)
FROM 
    `captures` c 
    JOIN `ducks` d ON c.sch = d.sch AND c.ringnr = d.ringnr
    JOIN `capture_countries` cCou ON c.sch = cCou.sch AND c.ringnr = cCou.ringnr AND c.occ = cCou.occ
WHERE 
    age = 1 AND
    country_id = "NL"
GROUP BY YEAR(date), c.occ, species_id;

-- Adult
INSERT INTO `capture_totals` 
SELECT YEAR(date), species_id,'adult','NL','database',NULL,c.occ, COUNT(c.sch)
FROM 
    `captures` c 
    JOIN `ducks` d ON c.sch = d.sch AND c.ringnr = d.ringnr
    JOIN `capture_countries` cCou ON c.sch = cCou.sch AND c.ringnr = cCou.ringnr AND c.occ = cCou.occ
WHERE 
    age > 1 AND
    country_id = "NL"
GROUP BY YEAR(date), c.occ, species_id;

-- All ages
INSERT INTO `capture_totals` 
SELECT YEAR(date), species_id,'all','NL','database',NULL, c.occ, COUNT(c.sch)
FROM 
    `captures` c 
    JOIN `ducks` d ON c.sch = d.sch AND c.ringnr = d.ringnr
    JOIN `capture_countries` cCou ON c.sch = cCou.sch AND c.ringnr = cCou.ringnr AND c.occ = cCou.occ
WHERE 
    country_id = "NL"
GROUP BY YEAR(date), c.occ, species_id;

-- All ages, in decoys
INSERT INTO `capture_totals` 
SELECT YEAR(date), species_id,'all','NL','database','T',c.occ, COUNT(c.sch)
FROM 
    `captures` c 
    JOIN `ducks` d ON c.sch = d.sch AND c.ringnr = d.ringnr
    JOIN `capture_countries` cCou ON c.sch = cCou.sch AND c.ringnr = cCou.ringnr AND c.occ = cCou.occ
WHERE 
    country_id = "NL"
    AND c.method  = "T"
GROUP BY YEAR(date), c.occ, species_id;
