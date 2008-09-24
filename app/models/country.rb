class Country < ActiveRecord::Base
    has_many :capture_totals
    has_many :country_captures
    has_many :country_subdivisions
    has_many :duck_decoys, :through => :country_subdivisions
    def self.captures(species)
        sql = ActiveRecord::Base.connection()
        query = "
          SELECT c.id as id, c.name as name, count(cc.sch) as number FROM 
            countries c
            JOIN capture_countries cc ON cc.country_id = c.id
            JOIN ducks d ON cc.sch = d.sch AND cc.ringnr = d.ringnr
            WHERE species_id = '#{species}'
          GROUP BY c.id
        "       
        resultSQL = sql.execute query
        resultArray = []
        while row = resultSQL.fetch_row
             resultArray << row
        end
        return resultArray
    end
    def self.monthly_captures(country, species)
        sql = ActiveRecord::Base.connection()
        query = "
          SELECT 
            MONTH(date) as month, 
            count(cc.sch) as number,
            sum(if(age=3,1,0)) as young,
            sum(if(age>3,1,0)) as adult,
            sum(if(age<3 OR age IS NULL,1,0)) as unknown
          FROM 
            captures c JOIN 
            capture_countries cc ON cc.sch = c.sch AND cc.ringnr = c.ringnr AND cc.occ = c.occ
            JOIN ducks d ON cc.sch = d.sch AND cc.ringnr = d.ringnr
            WHERE 
              species_id = '#{species}' AND
              cc.country_id = '#{country}' 
          GROUP BY MONTH(date)
        "       
        resultSQL = sql.execute query
        resultArray = []
        while row = resultSQL.fetch_row
             resultArray << row
        end
        return resultArray
    end
    def self.monthly_recaptures_condition(country, species)
        sql = ActiveRecord::Base.connection()
        query = "
          SELECT 
            MONTH(date) as month, 
            sum(if(`condition`=1 OR `condition`=2 OR `condition`=3,1,0)) as dead,
            sum(if(`condition`=4 OR `condition`=5,1,0)) as sick,
            sum(if(`condition`>5,1,0)) as ok,
            sum(if(`condition`=0 OR `condition` IS NULL,1,0)) as unknown
          FROM 
            captures c JOIN 
            capture_countries cc ON cc.sch = c.sch AND cc.ringnr = c.ringnr AND cc.occ = c.occ
            JOIN ducks d ON cc.sch = d.sch AND cc.ringnr = d.ringnr
            WHERE 
              species_id = '#{species}' AND
              cc.country_id = '#{country}'  AND
              c.occ > 1
          GROUP BY MONTH(date)
        "       
        resultSQL = sql.execute query
        resultArray = []
        while row = resultSQL.fetch_row
             resultArray << row
        end
        return resultArray
    end
    def self.monthly_recaptures_death(country, species)
        sql = ActiveRecord::Base.connection()
        query = "
          SELECT 
            MONTH(date) as month, 
            sum(if(`circumstances` = 1 OR (`circumstances` >= 10 AND `circumstances` < 20)  , 1,0)) as shot,
            sum(if(`circumstances` = 2 OR (`circumstances` >= 20 AND `circumstances` < 30), 1,0)) as killed,
            sum(if(`circumstances` = 3 OR `circumstances` = 4 OR (`circumstances` >= 30 AND `circumstances` < 50), 1,0)) as accident,
            sum(if(`circumstances` = 5 OR `circumstances` = 7 OR (`circumstances` >= 50 AND `circumstances` < 60) OR (`circumstances` >= 70 AND `circumstances` < 80), 1,0)) as 'natural',
            sum(if(`circumstances` = 6 OR (`circumstances` >= 60 AND `circumstances` < 70), 1,0))  as preditor,
            sum(if((`circumstances` > 1 AND `circumstances` < 10) OR `circumstances` IS NULL, 1,0)) as unknown
          FROM 
            captures c JOIN 
            capture_countries cc ON cc.sch = c.sch AND cc.ringnr = c.ringnr AND cc.occ = c.occ
            JOIN ducks d ON cc.sch = d.sch AND cc.ringnr = d.ringnr
            WHERE 
              species_id = '#{species}' AND
              cc.country_id = '#{country}'  AND
              c.occ > 1 AND    
              (
                `condition` = 1 OR
                `condition` = 2 OR
                `condition` = 3
              ) AND 
              `circumstances` != 8 AND
              (`circumstances` < 80 OR `circumstances` >= 90)
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

