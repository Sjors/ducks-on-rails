class DuckDecoy < ActiveRecord::Base
    belongs_to :country_subdivision, :include => [:country]
    delegate :country, :country=, :to => :country_subdivision
    has_many :ringer_kooikers
    has_many :coordinate_decoys
    def CapturesPerMonthAvg(species_id, month, year_begin, year_end) 
      sql = ActiveRecord::Base.connection()
      return sql.execute("
        SELECT count(c.sch)/ #{year_end - year_begin + 1}
        FROM 
          captures c
          JOIN ringer_captures rc ON c.sch = rc.sch AND c.ringnr = rc.ringnr AND c.occ = rc.occ
          JOIN ringer_kooikers rk ON rc.ringer_id = rk.rid 
          JOIN duck_decoys dd ON rk.nearest_decoy_id = dd.id
          JOIN ducks d ON c.sch = d.sch AND c.ringnr = d.ringnr 
        WHERE 
          dd.naam = '#{self.naam}' AND 
          YEAR(date) >= #{year_begin} AND YEAR(date) <= #{year_end} AND
          d.species_id = '#{species_id}' AND
          month(date) = '#{month}'
      ").fetch_row.first
    end
end
