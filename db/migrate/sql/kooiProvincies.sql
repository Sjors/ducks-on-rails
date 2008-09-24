-- Clean up:
UPDATE `duck_decoys` e SET country_subdivision_id = NULL WHERE 1;

-- Populate 'country_subdivision_id' column in table 'eendenkooien'.
start transaction;
UPDATE `duck_decoys` e JOIN `raw_decoys` er ON e.id = er.id 
SET e.country_subdivision_id = "NL-DR" 
WHERE er.provincie = 'DRENTHE';

UPDATE `duck_decoys` e JOIN `raw_decoys` er ON e.id = er.id 
SET e.country_subdivision_id = "NL-FR"
WHERE er.provincie = 'FRIESLAND';

UPDATE `duck_decoys` e JOIN `raw_decoys` er ON e.id = er.id 
SET e.country_subdivision_id = "NL-FL"
WHERE er.provincie = 'FLEVOLAND';

UPDATE `duck_decoys` e JOIN `raw_decoys` er ON e.id = er.id 
SET e.country_subdivision_id = "NL-GE"
WHERE er.provincie = 'GELDERLAND';

UPDATE `duck_decoys` e JOIN `raw_decoys` er ON e.id = er.id 
SET e.country_subdivision_id = "NL-GR"
WHERE er.provincie = 'GRONINGEN';

UPDATE `duck_decoys` e JOIN `raw_decoys` er ON e.id = er.id 
SET e.country_subdivision_id = "NL-LI"
WHERE er.provincie = 'LIMBURG';

UPDATE `duck_decoys` e JOIN `raw_decoys` er ON e.id = er.id 
SET e.country_subdivision_id = "NL-NB"
WHERE er.provincie = 'NOORD BRABANT';

UPDATE `duck_decoys` e JOIN `raw_decoys` er ON e.id = er.id 
SET e.country_subdivision_id = "NL-NH"
WHERE er.provincie = 'NOORD HOLLAND';

UPDATE `duck_decoys` e JOIN `raw_decoys` er ON e.id = er.id 
SET e.country_subdivision_id = "NL-OV"
WHERE er.provincie = 'OVERIJSSEL';

UPDATE `duck_decoys` e JOIN `raw_decoys` er ON e.id = er.id 
SET e.country_subdivision_id = "NL-UT"
WHERE er.provincie = 'UTRECHT';

UPDATE `duck_decoys` e JOIN `raw_decoys` er ON e.id = er.id 
SET e.country_subdivision_id = "NL-ZE"
WHERE er.provincie = 'ZEELAND';

UPDATE `duck_decoys` e JOIN `raw_decoys` er ON e.id = er.id 
SET e.country_subdivision_id = "NL-ZH"
WHERE er.provincie = 'ZUID HOLLAND';

UPDATE `duck_decoys` e JOIN `raw_decoys` er ON e.id = er.id 
SET e.country_subdivision_id = NULL
WHERE er.provincie = '';
commit;

-- Deze twee zou je met elkaar moeten vergelijken in een test (voorbeeldcode is verouderd):
-- SELECT `crc_country_subdivision_id` , count( * )
-- FROM `duck_decoys`
-- WHERE 1
-- GROUP BY country_subdivision_id
--
--SELECT `crc_provincie` , count( * )
--FROM `raw_decoys`
--WHERE 1
--GROUP BY provincie
--
-- Het aantal keer NULL moet bij de tweede 18 zijn en gelijk aan het aantal keer "" in de eerste.
-- country_subdivision_id mag geen lege velden hebben

-- Those 18 decoys do not have a province associated with them. 
-- One of them I determined manually with Google Maps. 

UPDATE `duck_decoys` e 
    JOIN `raw_decoys` er 
SET e.country_subdivision_id = 'NL-NB'
WHERE 
    er.registratienummer = '05.22.01' AND 
    er.dur_nummer = 'FEF 065.94.0008/10';

-- Another one seems to be in Belgium or Brabant (unclear). The other 16 are unclear.

