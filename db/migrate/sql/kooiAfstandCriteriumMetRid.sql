-- Clean up:
UPDATE `ringer_kooikers` SET 
    nearest_decoy_id = NULL, 
    decoy_distance = NULL;



-- Now the big challenge: match ringer_id with decoy_id. The approach is to find
-- the nearest decoy for that rid (in that sequence!). The reason for this 
-- sequence is that the end goal is to determine which rings were likely ringed in a decoil.
-- The grouping by rid is only done because of the assumption that the corresponding rings
-- were ringed at the same location, so their average gives a better estimate. 
-- If the sequence were to be reversed, it would imply the assumptions that:
-- - there is only 1 rid per decoy
-- - the average location of the rings with an rid are always the decoy (unlikely given
-- the high inacuracy and the sometimes high density of decoys. 
-- That way, important data would remain unused for the wrong reasons. 

CREATE TEMPORARY TABLE `t` 
(
`d` FLOAT, 
`ringer` varchar(3), 
`decoy` INT,
PRIMARY KEY (`ringer`, `decoy`)
) ENGINE = innodb;

-- Cannot open a temporary table twice in a query, so I copy it first...
CREATE TEMPORARY TABLE `tt` 
(
`d` FLOAT, 
`ringer` varchar(3), 
`decoy` INT,
PRIMARY KEY (`ringer`, `decoy`)
) ENGINE = innodb;

INSERT INTO t (d, ringer, decoy)
SELECT
AVG(
    (
        3958*3.1415926*sqrt(
            (e.lat-c.lat)*(e.lat-c.lat) + cos(e.lat/57.29578)*cos(c.lat/57.29578)*(e.lon-c.lon)*(e.lon-c.lon)
        ) /180
    )
) as d,
c.ringer_id as ringer,
e.id as decoy
FROM
(
    SELECT DISTINCT ringer_id, lat, lon
    FROM `captures` c
    JOIN `capture_coordinates` cC
    ON c.sch = cC.sch AND c.ringnr = cC.ringnr AND c.occ = cC.occ
    JOIN `ringer_captures` rC
    ON c.sch = rC.sch AND c.ringnr = rC.ringnr AND c.occ = rC.occ
    JOIN `capture_countries` cCou
    ON c.sch = cCou.sch AND c.ringnr = cCou.ringnr AND c.occ = cCou.occ
    WHERE 
    country_id = "NL" AND 
    c.occ = 1
) c JOIN 
(
    SELECT id, lon, lat 
    FROM `duck_decoys`
    WHERE
    lon IS NOT NULL AND
    lat IS NOT NULL
) e
GROUP BY ringer, decoy;

-- Copy results into the other temporary table
 INSERT INTO `tt` (d, ringer, decoy) SELECT * FROM `t`;

-- And for the results:
CREATE TEMPORARY TABLE `ttt` 
(
`d` FLOAT, 
`ringer` varchar(3), 
`decoy` INT,
PRIMARY KEY (`ringer`, `decoy`)
) ENGINE = innodb;

-- Find the closest decoy for each rid (mind the sequence here!)
INSERT INTO `ttt` (d, ringer, decoy)
SELECT 
    t1.d as d, 
    t1.ringer as ringer, 
    decoy
FROM `t` as t1 
JOIN (
    SELECT min(d) as d, ringer
    FROM `tt`
    GROUP BY ringer
) as t2 
ON t1.ringer = t2.ringer AND ROUND(t1.d,2) = ROUND(t2.d,2);

-- Put results into duck decoy table:
-- Note: if there was there was more than 1 match for the shortest distance, on is picked at random by MySQL.
-- That will only become a problem once we have information on the catching statistics from duck-decoils or 
-- another way to verify the decoy-ringers match. At that point, this whole query might become useless anyway.

UPDATE `ttt` as ttt JOIN `ringer_kooikers` r ON r.rid = ttt.ringer
SET r.nearest_decoy_id = ttt.decoy, r.decoy_distance = ttt.d;

DROP TEMPORARY TABLE `t`;
DROP TEMPORARY TABLE `tt`;
DROP TEMPORARY TABLE `ttt`;
