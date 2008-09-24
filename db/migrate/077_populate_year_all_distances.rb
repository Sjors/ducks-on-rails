class PopulateYearAllDistances < ActiveRecord::Migration
  def self.up
    for year in (1960..2001)
       execute "
        INSERT INTO year_all_distances (species_id, sex, age, year_dep, distance, distance_north)
        SELECT 
          species_id,
          sex,
          age,
          #{year},
          distance,
          distance_north
        FROM 
        (
          SELECT 
            c2.sch as sch,
            c2.ringnr as ringnr,
            species_id,
            sex,
            c1.age as age,
            MIN(distance) as distance,
            if(distance_north >0, MIN(distance_north), MAX(distance_north)) as distance_north
          FROM
            flights f
            JOIN ducks d ON
              f.sch = d.sch AND
              f.ringnr = d.ringnr
            JOIN captures c1 ON
              f.sch = c1.sch AND
              f.ringnr = c1.ringnr AND
              f.occ_start = c1.occ
            JOIN captures c2 ON
              f.sch = c2.sch AND
              f.ringnr = c2.ringnr AND
              f.occ_end = c2.occ
            JOIN capture_countries cc1 ON
              c1.sch = cc1.sch AND
              c1.ringnr = cc1.ringnr AND
              c1.occ = cc1.occ
            JOIN capture_countries cc2 ON
              c2.sch = cc2.sch AND
              c2.ringnr = cc2.ringnr AND
              c2.occ = cc2.occ
          WHERE 
            (
              (
                YEAR(c1.date) = #{year} AND 
                (
                  MONTH(c1.date) = 1 OR
                  MONTH(c1.date) = 2 OR
                  MONTH(c1.date) = 3
                )
              ) OR
              (
                YEAR(c1.date) = #{year-1} AND 
                (
                  MONTH(c1.date) = 11 OR
                  MONTH(c1.date) = 12
                )
              )
            )
            AND
            f.occ_start = 1 AND
            (
            (
              YEAR(c2.date) < #{year + 6} AND
              (
                MONTH(c2.date) = 1 OR
                MONTH(c2.date) = 2 OR
                MONTH(c2.date) = 3
              ) AND 
              YEAR(c2.date) > #{year}
            ) OR
            (
              YEAR(c2.date) < #{year + 5} AND
              (
                MONTH(c2.date) = 11 OR
                MONTH(c2.date) = 12
              ) AND 
              YEAR(c2.date) > #{year - 1}
            )
            ) AND 
            cc1.country_id = 'NL' AND
            (
              cc2.country_id = 'BE' OR
              cc2.country_id = 'NL' OR
              cc2.country_id = 'DE' OR
              cc2.country_id = 'DK' OR
              cc2.country_id = 'ES' OR
              cc2.country_id = 'FR' OR
              cc2.country_id = 'GB' OR
              cc2.country_id = 'GR' OR
              cc2.country_id = 'IE' OR
              cc2.country_id = 'IT'
            )
          GROUP BY  c2.sch, c2.ringnr
        ) t
        GROUP BY sch, ringnr
      "
    end
  end

  def self.down
    execute "TRUNCATE year_all_distances"
  end
end
