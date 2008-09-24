-- Clean up:
DELETE FROM `coordinate_decoys` WHERE 1;

-- And now the coordinate pairs that have no rid associated with them:
CREATE TEMPORARY TABLE `t`
(
`d` FLOAT,
`decoy` INT,
`rlat` FLOAT,
`rlon` FLOAT,
PRIMARY KEY (`decoy`, `rlat`, `rlon`)
) ENGINE = innodb;
ALTER TABLE `t` ADD INDEX (d);

-- Cannot open a temporary table twice in a query, so I copy it first...
CREATE TEMPORARY TABLE `tt`
(
`d` FLOAT,
`decoy` INT,
`rlat` FLOAT,
`rlon` FLOAT,
PRIMARY KEY (`decoy`, `rlat`, `rlon`)
) ENGINE = innodb;
ALTER TABLE `tt` ADD INDEX (d);

INSERT INTO `t` (d, decoy, rlat, rlon)
SELECT 
(3958*3.1415926*sqrt(
(e.lat-c.lat)*(e.lat-c.lat) + cos(e.lat/57.29578)*cos(c.lat/57.29578)*(e.lon-c.lon)*(e.lon-c.lon))/180) as d,
e.id as decoy, 
c.lat, 
c.lon
FROM 
(
    SELECT id,lat, lon 
    FROM `duck_decoys` 
    WHERE 
    lat IS NOT NULL AND
    lon IS NOT NULL 
) e 
JOIN 
(
    SELECT DISTINCT lat, lon 
    FROM `captures` c
    JOIN `capture_coordinates` cC
    ON c.sch = cC.sch AND c.ringnr = cC.ringnr AND c.occ = cC.occ
    LEFT JOIN `ringer_captures` rC
    ON c.sch = rC.sch AND c.ringnr = rC.ringnr AND c.occ = rC.occ
    JOIN `capture_countries` cCou
    ON c.sch = cCou.sch AND c.ringnr = cCou.ringnr AND c.occ = cCou.occ
    WHERE 
    country_id = "NL" AND
    ringer_id IS NULL AND
    c.occ = 1
) c
GROUP BY e.lat, e.lon, c.lat, c.lon;

-- Copy results into the other temporary table
 INSERT INTO `tt` (d, decoy, rlat, rlon) SELECT * FROM `t`;


-- And for the results:
CREATE TEMPORARY TABLE `ttt`
(
`d` FLOAT,
`decoy` INT,
`rlat` FLOAT,
`rlon` FLOAT,
PRIMARY KEY (`decoy`, `rlat`, `rlon`)
) ENGINE = innodb;
ALTER TABLE `ttt` ADD INDEX (d);


-- Find the closest decoy for each coordinate-set (mind the sequence here!)
INSERT INTO `ttt` (d, decoy, rlat, rlon )
    SELECT t1.d as d, decoy, t1.rlat as rlat, t1.rlon as rlon 
    FROM `t` as t1
    JOIN (
        SELECT min(d) as d, rlat, rlon
        FROM `tt`
        GROUP BY rlat, rlon
    ) as t2
    ON t1.rlat = t2.rlat AND t1.rlon = t2.rlon AND ROUND(t1.d,2) = ROUND(t2.d,2);

INSERT INTO `coordinate_decoys` (decoy_distance,decoy_id,lat, lon) 
    SELECT d, decoy, rlat, rlon
    FROM `ttt`
    GROUP BY rlat, rlon ;


