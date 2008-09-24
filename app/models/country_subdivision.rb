class CountrySubdivision < ActiveRecord::Base
    belongs_to :country
    has_many :ducks_decoys
    has_many :country_subdivision_captures
    def self.captures(species, country)
        sql = ActiveRecord::Base.connection()
        query = "
          SELECT c.id as id, c.name as name, count(cc.sch) as number FROM 
            country_subdivisions c
            JOIN capture_country_subdivisions cc ON cc.country_subdivision_id = c.id
            JOIN ducks d ON cc.sch = d.sch AND cc.ringnr = d.ringnr
            WHERE 
              species_id = '#{species}' AND
              country_id = '#{country}'
          GROUP BY c.id
        "       
        resultSQL = sql.execute query
        resultArray = []
        while row = resultSQL.fetch_row
             resultArray << row
        end
        return resultArray
    end
    def self.monthly_captures(country_subdivision, species)
        sql = ActiveRecord::Base.connection()
        query = "
          SELECT 
            MONTH(date) as month, 
            count(cc.sch) as number,
            sum(if(age=3,1,0)) as young,
            sum(if(age>3,1,0)) as adult,
            sum(if(age<3 OR age IS NULL,1,0)) as unknown
          FROM 
            captures c 
            JOIN capture_country_subdivisions cc ON cc.sch = c.sch AND cc.ringnr = c.ringnr AND cc.occ = c.occ
            JOIN ducks d ON cc.sch = d.sch AND cc.ringnr = d.ringnr
            WHERE 
              species_id = '#{species}' AND
              cc.country_subdivision_id = '#{country_subdivision}' 
          GROUP BY MONTH(date)
        "       
        resultSQL = sql.execute query
        resultArray = []
        while row = resultSQL.fetch_row
             resultArray << row
        end
        return resultArray
    end
end
