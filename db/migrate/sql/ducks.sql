-- Populates the table ducks, see wiki:
-- http://eend.sprovoost.nl/wiki/index.php/Db:structure#Ducks

-- Populate with the ring numbers (and scheme) from raw-ducksRinged
INSERT INTO `ducks` (sch, ringnr) 
    SELECT sch, ringnr FROM `raw_ringed_ducks` WHERE 1;

-- Put in the species names
UPDATE 
    `ducks` d 
    JOIN `raw_ringed_ducks` rdR 
    ON 
        d.sch = rdR.sch AND 
        d.ringnr = rdR.ringnr
    JOIN `species` s
    ON 
        s.euring_id = rdR.rspec
SET
    species_id = s.id
WHERE 1;

-- Fix 01949 which should have been 01940 (Anas clypeata):
UPDATE 
    `ducks` d 
    JOIN `raw_ringed_ducks` rdR 
    ON 
        d.sch = rdR.sch AND 
        d.ringnr = rdR.ringnr
SET
    species_id = 'Anas clypeata' 
WHERE 
    rdR.rspec = 1949
;

-- Put in the species sex
-- Data is in EURING 79 format; it is converted to male, female or
-- unkown

-- Unknown:
UPDATE 
    `ducks` d
    JOIN `raw_ringed_ducks` rdR
    ON 
        d.sch = rdR.sch AND 
        d.ringnr = rdR.ringnr
    SET 
        d.sex = NULL 
    WHERE 
        rdR.rx = 0 OR
        rdR.rx = 7 OR
        rdR.rx IS NULL;

-- Male:
UPDATE 
    `ducks` d
    JOIN `raw_ringed_ducks` rdR
    ON 
        d.sch = rdR.sch AND 
        d.ringnr = rdR.ringnr
    SET 
        d.sex = 'male' 
    WHERE 
        rdR.rx = 1 OR
        rdR.rx = 3 OR
        rdR.rx = 5 OR
        rdR.rx = 8;

-- Female:
UPDATE 
    `ducks` d
    JOIN `raw_ringed_ducks` rdR
    ON 
        d.sch = rdR.sch AND 
        d.ringnr = rdR.ringnr
    SET 
        d.sex = 'female' 
    WHERE 
        rdR.rx = 2 OR
        rdR.rx = 4 OR
        rdR.rx = 6 OR
        rdR.rx = 9;

