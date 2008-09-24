class PopulateBreedingSuccess < ActiveRecord::Migration
  def self.up
    execute " 
      INSERT INTO breeding_successes (
        region,
        species_id,
        sex,
        year,
        firstyear
      )
      SELECT 
        'NL',
        species_id,
        'all',
        IF(
          MONTH(date) = 12,
          YEAR(date) - 1,
          YEAR(date)
        ),         
        count( c.occ )
      FROM `captures` c
      JOIN ducks d ON 
        c.sch = d.sch AND d.ringnr = c.ringnr
      JOIN capture_countries cc ON
        c.sch = cc.sch AND
        c.ringnr = cc.ringnr AND
        c.occ = cc.occ
     WHERE 
      age = 3 
      AND country_id = 'NL'
      AND c.occ = 1
      AND (
        MONTH(date) = 12 OR
        MONTH(date) = 1 OR
        MONTH(date) = 2
      )
    GROUP BY 
      IF(
        MONTH(date) = 12,
        YEAR(date)-1,
        YEAR(date)
      ),    
      species_id
    "
    
    execute " 
      INSERT INTO breeding_successes (
        region,
        species_id,
        sex,
        year,
        firstyearandolder
      )
      SELECT 
        'NL',
        species_id,
        'all',
        IF(
          MONTH(date) = 12,
          YEAR(date)-1,
          YEAR(date)
        ),   
        count( c.occ )
      FROM `captures` c
      JOIN ducks d ON c.sch = d.sch
      AND d.ringnr = c.ringnr
      JOIN capture_countries cc ON
        c.sch = cc.sch AND
        c.ringnr = cc.ringnr AND
        c.occ = cc.occ
      WHERE
      age >= 3 
      AND country_id = 'NL'
      AND c.occ = 1
      AND (
        MONTH(date) = 12 OR
        MONTH(date) = 1 OR
        MONTH(date) = 2
      )
    GROUP BY 
      IF(
        MONTH(date) = 12,
        YEAR(date)-1,
        YEAR(date)
      ),    
      species_id
    ON DUPLICATE KEY update firstyearandolder = VALUES(firstyearandolder)
    "
   
   # Remove rows where there is no first-year only count
   execute "
    DELETE 
    FROM breeding_successes 
    WHERE firstyear IS NULL
   "

  # Now calculate fraction and standard deviation
  execute "
    UPDATE breeding_successes 
    SET 
      fraction = firstyear / firstyearandolder,
      fraction_sd = firstyear / firstyearandolder *
        SQRT(1/firstyearandolder + 1 / firstyear)
    WHERE 1
  "

  end

  def self.down
    execute "truncate table breeding_successes"
  end
end
