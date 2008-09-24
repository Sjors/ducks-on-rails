class PopulateFlights < ActiveRecord::Migration
  # For the distance we use the Loxod method. See e.g. : http://www.vogeltrekstation.nl/afstand.htm
  # For the north/south component we set longitude to 0. That drops the second part of the expression.
  # In addition, I took out the SQRT() part, to distinguish between north and south.
  def self.up
    execute "
      INSERT INTO flights (sch, ringnr, occ_start, occ_end, distance, distance_north, angle)
      SELECT 
        c1.sch, 
        c1.ringnr, 
        c1.occ, 
        c2.occ,
        3958 * 3.1415926 * sqrt(
          (cc2.lat - cc1.lat) * 
          (cc2.lat-cc1.lat) + 
          cos(
            cc2.lat/57.29578
          ) * 
          cos(
            cc1.lat/57.29578
          ) * 
          (cc2.lon - cc1.lon)*
          (cc2.lon-cc1.lon)
        )/180,
        3958 * 3.1415926 * 
          (cc2.lat-cc1.lat)
        /180,
        atan( 
          sin(cc2.lon / 57.29578 - cc1.lon / 57.29578) * cos(cc2.lat / 57.29578),
          cos(cc1.lat / 57.29578) * sin(cc2.lat / 57.29578) - sin(cc1.lat / 57.29578) * cos(cc2.lat / 57.29578) * cos(cc2.lon/57.29578-cc1.lon/57.29578)
        )
      FROM
        captures c1 
        JOIN captures c2 ON 
          c1.sch = c2.sch AND
          c1.ringnr = c2.ringnr AND 
          c1.occ < c2.occ
        JOIN capture_coordinates cc1 ON 
          c1.sch = cc1.sch AND
          c1.ringnr = cc1.ringnr AND
          c1.occ = cc1.occ
        JOIN capture_coordinates cc2 ON 
          c2.sch = cc2.sch AND
          c2.ringnr = cc2.ringnr AND
          c2.occ = cc2.occ
        WHERE 
          cc1.lat IS NOT NULL AND
          cc2.lat IS NOT NULL AND
          cc1.lon IS NOT NULL AND
          cc2.lon IS NOT NULL AND
          YEAR(c1.date) > 1911 AND
          YEAR(c2.date) > 1911 AND
          datediff( c2.date, c1.date ) >= 0 AND
          cc1.country_consistent = 1 AND
          cc2.country_consistent = 1
    "      
  end

  def self.down
    execute "TRUNCATE `flights`;"    
  end
end
