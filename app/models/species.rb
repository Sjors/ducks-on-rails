require 'rubygems'
require 'composite_primary_keys'
class Species < ActiveRecord::Base
    has_many :ducks
    has_many :capture_totals
    has_many :captures, :through => :ducks, :foreign_key => [:sch, :ringnr]
    has_many :ringer_capture, :through => :ducks, :foreign_key => [:sch, :ringnr]
    has_one :map_edge
    has_many :year_distances
    has_many :breeding_successes
    
    def CaptureTotal
        return CaptureTotal.sum(
          :captures, 
          :conditions => [
            'species_id = ? AND country_id = ? AND source = ? AND age = ? AND occ = ? AND method = ?', 
            self.id, 
            'NL', 
            'database',
            'all',
            1,
            ''
          ]
       ) 
    end

    def self.find_by_capture_count
       answer = []
       species = Species.find(:all)
       species.each {|sp|
        if a = sp.CaptureTotal.to_i then
          if a > 0 then
            answer << [a,sp]
          end
        end
       }
       answer.sort! {|x,y| y[0] <=> x[0]}
       return answer.transpose[1]
    end

    def getDuckDecoySizes
        sql = ActiveRecord::Base.connection()
        query = "
        SELECT lon, lat, log(sum(n)+1)/10 as n FROM
        (
            (
                SELECT e.id as kooi, count(ringer_id) as n 
                FROM 
                    `captures` c
                    JOIN `ringer_captures` rC
                    ON c.sch = rC.sch AND c.ringnr = rC.ringnr AND c.occ = rC.occ
                    JOIN `capture_countries` cCou
                    ON c.sch = cCou.sch AND c.ringnr = cCou.ringnr AND c.occ = cCou.occ
                    JOIN `duck_decoys` e 
                    JOIN `ringer_kooikers` r
                    JOIN `ducks` d
                 ON 
                   rC.ringer_id = r.rid AND
                   r.nearest_decoy_id = e.id AND
                   d.sch = c.sch AND d.ringnr = c.ringnr
                WHERE 
                   method = 'T' AND
                   species_id = '#{self.id}' AND
                   country_id = 'NL'
                GROUP BY e.id
            ) 
            UNION ALL
            (
                SELECT  e.id as kooi, count(c.occ) as n 
                FROM
                   `captures` c 
                   JOIN `capture_coordinates` cC
                   ON c.sch = cC.sch AND c.ringnr = cC.ringnr AND c.occ = cC.occ
                   JOIN `coordinate_decoys` cK
                   ON cC.lat = cK.lat AND cC.lon = cK.lon
                   JOIN `duck_decoys` e
                   ON cK.decoy_id = e.id
                   JOIN `ducks` d
                   ON d.sch = c.sch AND d.ringnr = c.ringnr
                   JOIN `capture_countries` cCou
                   ON c.sch = cCou.sch AND c.ringnr = cCou.ringnr AND c.occ = cCou.occ
                WHERE 
                   method = 'T' AND
                   species_id = '#{self.id}' AND
                   country_id = 'NL'
                GROUP BY e.id
            )
        ) t JOIN `duck_decoys` e ON t.kooi = e.id
        GROUP BY t.kooi;

        "
        resultSQL = sql.execute query
        resultArray = []
        while row = resultSQL.fetch_row
             resultArray << row
        end

        return resultArray
    end
    
    def getNonDuckDecoyCaptureSizes
        sql = ActiveRecord::Base.connection()
        query = "
        SELECT lon, lat, (log(count(c.occ))+1)/10 as n
        FROM 
            `captures` c
            JOIN `capture_coordinates` cC
            ON c.sch = cC.sch AND c.ringnr = cC.ringnr AND c.occ = cC.occ
            JOIN `capture_countries` cCou
            ON c.sch = cCou.sch AND c.ringnr = cCou.ringnr AND c.occ = cCou.occ
            JOIN `ducks` d 
            ON d.sch = c.sch AND d.ringnr = c.ringnr
        WHERE 
           (method != 'T' OR method IS NULL) AND
           species_id = '#{self.id}' AND
           country_id = 'NL'
           AND c.occ = 1
        GROUP BY lon, lat
        "
        resultSQL = sql.execute query
        resultArray = []
        while row = resultSQL.fetch_row
             resultArray << row
        end

        return resultArray
    end
    
    def getCaptures(months, scale=0.1)
        sql = ActiveRecord::Base.connection()
        query = "
        SELECT lon, lat,(log(sum(count))+1) * 0.7 * #{scale} as c 
        FROM 
           `month_captures` c 
        WHERE 
        species_id = '#{self.id}' AND
        ("
        if months.size > 0 
          first = true
          months.each {|month|
            if first == false then
                query << " OR "
            else
                first = false
            end
            query << "month = #{month}"
          }
        else
          query << "false"
        end
        query << 
        ")
        GROUP BY lat, lon;
        "
        resultSQL = sql.execute query
        resultArray = []
        while row = resultSQL.fetch_row
             resultArray << row
        end

        return resultArray
    end
    def capturesFromTo (first_year, last_year, age="all", method="")
        number = 0
        complete = true
        for year in first_year..last_year do
            if (year > 1958 or not (
                    self.id == 'Anas crecca' or
                    self.id == 'Anas penelope' or
                    self.id == 'Anas platyrhynchos'
                )) then
                # Use the database in stead of Limosa tables
                source = "database"
                # If Limosa tables were not used, the data is incomplete:
                if year <= 1958 then complete = false end
            else
                source = "Limosa"
            end
            # If the catchment method is the duck decoy, all data before 1958
            # is incomplete.
            if method == "T" and year <= 1958 then complete = false end

            if age == "young" or age == "adult" or age == "all" then 
                plus = CaptureTotal.find(
                    :first, 
                    :conditions => ["
                        species_id = ? AND 
                        source = ? AND 
                        occ = ? AND 
                        age = ? AND 
                        year = ? AND
                        method = ?
                     ", 
                     self.id, 
                     source, 
                     1, 
                     age, 
                     year,
                     method
                    ]
                )
                if plus then number += plus.captures end
            else
                # Age = "unknown" : total - young - adult
                total = CaptureTotal.find(
                    :first, 
                    :conditions => ["
                        species_id = ? AND 
                        source = ? AND 
                        occ = ? AND 
                        age = ? AND 
                        year = ? AND
                        method = ?
                     ", 
                     self.id, 
                     source, 
                     1, 
                     "all", 
                     year,
                     method
                ])
                if total then total = total.captures.to_i else total = 0 end 
                
                young = CaptureTotal.find(
                    :first, 
                    :conditions => ["
                        species_id = ? AND 
                        source = ? AND 
                        occ = ? AND 
                        age = ? AND 
                        year = ? AND
                        method = ?
                     ", 
                     self.id, 
                     source, 
                     1, 
                     "young", 
                     year,
                     method
                ])
                
                if young then young = young.captures.to_i else young = 0 end 
                

                adult = CaptureTotal.find(
                    :first, 
                    :conditions => ["
                        species_id = ? AND 
                        source = ? AND 
                        occ = ? AND 
                        age = ? AND 
                        year = ? AND
                        method = ?
                     ", 
                     self.id, 
                     source, 
                     1, 
                     "adult", 
                     year,
                     method
                ])

                if adult then adult = adult.captures.to_i else adult = 0 end 

                number += total - young - adult
            end
            
        end
        return [number, complete]

    end
    def CapturesMonthAge(month,age)
      sql = ActiveRecord::Base.connection()
      (sql.execute "
        SELECT count(d.sch) 
        FROM 
          ducks d 
          JOIN captures c 
          ON d.sch = c.sch AND d.ringnr = c.ringnr
        WHERE 
          species_id = '#{self.id}' AND
          MONTH(date) = '#{month}' AND
          age = '#{age}' AND
          occ = 1
      ").fetch_row 
    end
    
    def migrationSpeedFromTo (min, max)
      sql = ActiveRecord::Base.connection()
      res = sql.execute "
        SELECT COUNT(id)  
        FROM 
          `flights` f
          JOIN ducks d ON f.sch = d.sch AND f.ringnr = d.ringnr
          JOIN captures c1 ON f.sch = c1.sch AND f.ringnr = c1.ringnr AND f.occ_start = c1.occ
          JOIN captures c2 ON f.sch = c2.sch AND f.ringnr = c2.ringnr AND f.occ_end = c2.occ
        WHERE 
          (
            MONTH(c1.date) >= 8 OR 
            MONTH(c1.date) <= 11
          ) AND
          (
            MONTH(c2.date) >= 8 OR 
            MONTH(c2.date) <= 11
          ) AND
          distance_north < 0 AND
          DATEDIFF(c2.date, c1.date) <= 75 AND
          distance > 50 AND
          distance / duration > #{min} AND 
          distance / duration <= #{max} AND
          (
            NOT (
              c1.`condition` = 1  OR
              c1.`condition` = 3 OR
              c1.`condition` = 4 OR
              c1.`condition` = 5 
            ) OR
            c1.`condition` IS NULL
          ) AND
          NOT (
            c1.dateAcc > 1 OR
            (
              c1.dateAcc = 1 AND 
              DATEDIFF(c2.date, c1.date) <= 5
            )
          ) AND
          (
            NOT (
              c2.`condition` = 1  OR
              c2.`condition` = 3 OR
              c2.`condition` = 4 OR
              c2.`condition` = 5 
            ) OR
            c2.`condition` IS NULL
          ) AND
          NOT (
            c2.dateAcc > 1 OR
            (
              c2.dateAcc = 1 AND 
              DATEDIFF(c2.date, c1.date) <= 5
            )
          ) AND
          species_id = \"#{self.id}\"
      "
      return res.fetch_row.first
    end

  def survival(year)
    # Calculates how many ducks are killed in the 'year' year after ringing.
    sql = ActiveRecord::Base.connection()
    res = sql.execute "
      SELECT
        count(*)
      FROM
        (
          SELECT
            c.sch,
            c.ringnr,
            YEAR(date) + if(month(date)>6, 1, 0) as year_dep
          FROM
            captures c
            JOIN capture_countries cc ON cc.sch = c.sch AND cc.ringnr = c.ringnr AND cc.occ = c.occ
            JOIN ducks d ON cc.sch = d.sch AND cc.ringnr = d.ringnr
          WHERE
            species_id = '#{self.id}' AND
            cc.country_id = 'NL'  AND
            c.occ = 1 AND
              (
                (age = 3 AND MONTH(date) > 7 AND  YEAR(date) >= 1957 AND YEAR(date) <= 1999 ) OR
                ((age = 3 OR age = 5) AND MONTH(date) < 4 AND YEAR(date) >= 1958 AND YEAR(date) <= 2000)
              )
        ) t
        JOIN captures c ON t.sch = c.sch AND t.ringnr = c.ringnr
      WHERE
        occ > 1 AND
        `condition` = 2 AND
        YEAR(c.date) + if(month(c.date)>6, 1, 0) - year_dep = #{year}
    "
    return res.fetch_row.first

  end
  
  def sex(sex)
    # Return percentage of ducks with a given sex. 
    # sex can be 'male', 'female' or 'unknown'

    sql = ActiveRecord::Base.connection()

    # The common SQL code
    sql_common = "
      SELECT count(*) 
      FROM 
      ducks d JOIN
      captures c ON d.sch = c.sch AND d.ringnr = c.ringnr
      WHERE 
      species_id = '#{self.id}' AND
      occ = 1 AND
      year(date) > 1958
    "
    # Total number of ducks ringed in The Netherlands of given species:
    
    total = (sql.execute "
    #{sql_common}
    ").fetch_row.first.to_f
    
    # Number of captures with specified sex
    case sex 
    when "male"
      sql_sex = "d.sex = 'male'"
    when "female"
      sql_sex = "d.sex = 'female'"
    when "unknown"
      sql_sex = "d.sex IS NULL"
    end 
    
    total_of_sex = (sql.execute "
      #{sql_common} AND
      #{sql_sex}
    ").fetch_row.first.to_f
   
    return total_of_sex / total
  end
  
  def age(age)
    # Return percentage of ducks with a given age. 
    # age can be 'pullus', '1', '2', '2+' or 'unknown'

    sql = ActiveRecord::Base.connection()

    # The common SQL code
    sql_common = "
      SELECT count(*) 
      FROM 
      ducks d JOIN
      captures c ON d.sch = c.sch AND d.ringnr = c.ringnr
      WHERE 
      species_id = '#{self.id}' AND
      occ = 1 AND
      year(date) > 1958
    "
    # Total number of ducks ringed in The Netherlands of given species:
    
    total = (sql.execute "
    #{sql_common}
    ").fetch_row.first.to_f
    
    # Number of captures with specified age
    case age
    when "pullus"
      sql_age = "c.age = 1"
    when "1"
      sql_age = "c.age = 3"
    when "2"
      sql_age = "c.age = 5"
    when ">2"
      sql_age = "c.age > 5"
    else
      sql_age = "(
        c.age IS NULL OR
        c.age = 2 OR
        c.age = 4
      )"
    end 
    
    total_of_age = (sql.execute "
      #{sql_common} AND
      #{sql_age}
    ").fetch_row.first.to_f
   
    return total_of_age / total
  end
  
  def catch_method(method)
    # Return percentage of ducks captured with the given method. Method can be 'decoy' or 'other'. 

    sql = ActiveRecord::Base.connection()

    # The common SQL code
    sql_common = "
      SELECT count(*) 
      FROM 
      ducks d JOIN
      captures c ON d.sch = c.sch AND d.ringnr = c.ringnr
      WHERE 
      species_id = '#{self.id}' AND
      occ = 1 AND
      year(date) > 1958
    "
    # Total number of ducks ringed in The Netherlands of given species:
    
    total = (sql.execute "
    #{sql_common}
    ").fetch_row.first.to_f
    
    # Number of captures with specified method
    case method 
    when "decoy"
      sql_method = "c.method = 'T'"
    when "other"
      sql_method = "c.method IS NULL"
    end 
    
    total_of_method = (sql.execute "
      #{sql_common} AND
      #{sql_method}
    ").fetch_row.first.to_f
   
    return total_of_method / total
  end
  
  def recapture_countries
    # Returns percentages of ducks recaptured per country. Only ducks that departed from the Netherlands and that passed the coordinate <=> country consistency check.

    sql = ActiveRecord::Base.connection()

    res = (sql.execute "
      SELECT c2.country_id, count(f.sch) 
      FROM 
        flights f 
        JOIN ducks d 
          ON d.sch = f.sch AND d.ringnr = f.ringnr
        JOIN capture_countries c1 
          ON f.sch = c1.sch AND f.ringnr = c1.ringnr AND f.occ_start = c1.occ
        JOIN capture_countries c2 
          ON f.sch = c2.sch AND f.ringnr = c2.ringnr AND f.occ_end = c2.occ
      WHERE 
      c1.country_id = 'NL' AND
      d.species_id = '#{self.id}'
      GROUP BY c2.country_id 
      ORDER BY count(f.sch) DESC    
")
    
    capture_countries = []
    while (country = res.fetch_row) do
      if country[1].to_f > 10 then
        capture_countries << [country[0], country[1].to_f]
      end
    end

    return capture_countries
  end
  
  def speed(type)
    # Returns the speed of the current species, based on the
    # method specified in 'type'. Also returns the number of 
    # captures that were used in the calculation.
    sql = ActiveRecord::Base.connection()
    
    common_sql_select_from = "
      FROM 
        `flights` f 
      JOIN ducks d 
        ON f.sch = d.sch AND f.ringnr = d.ringnr
      JOIN capture_countries cc1 
        ON cc1.sch = f.sch AND cc1.ringnr=f.ringnr AND cc1.occ = f.occ_start"
    common_sql_where = "
      WHERE 
        species_id = '#{self.id}' AND
        cc1.country_id = 'NL' AND 
        distance > 50"

    common_spring_autumn_begin = "
      SELECT 
        distance/duration, 
        STDDEV_SAMP(distance/duration)/SQRT(COUNT(id)) ,  
        COUNT(id)" + common_sql_select_from + " 
        JOIN captures c1 
          ON f.sch = c1.sch AND f.ringnr = c1.ringnr AND f.occ_start = c1.occ
        JOIN captures c2  
          ON f.sch = c2.sch AND f.ringnr = c2.ringnr AND f.occ_end = c2.occ
    " + common_sql_where

    common_spring_autumn_end = "
        DATEDIFF(c2.date, c1.date) <= 75 AND
        distance > 50 AND
        distance / duration > 10 AND
        (
          NOT (
            c1.`condition` = 1  OR
            c1.`condition` = 3 OR
            c1.`condition` = 4 OR
            c1.`condition` = 5 
          ) OR
          c1.`condition` IS NULL
        ) AND
        NOT (
          c1.dateAcc > 1 OR
          (
            c1.dateAcc = 1 AND 
            DATEDIFF(c2.date, c1.date) <= 5
          )
        ) AND
        (
          NOT (
            c2.`condition` = 1  OR
            c2.`condition` = 3 OR
            c2.`condition` = 4 OR
            c2.`condition` = 5 
          ) OR
          c2.`condition` IS NULL
        ) AND
        NOT (
          c2.dateAcc > 1 OR
          (
            c2.dateAcc = 1 AND 
            DATEDIFF(c2.date, c1.date) <= 5
          )
        ) 
        GROUP BY species_id
    "

    case type
      when "max"
        query = "
          SELECT round(max(distance/duration)),count(*)" +
          common_sql_select_from + common_sql_where + "
          GROUP BY species_id
          ORDER BY max(distance/duration) DESC
        "
      when "3days"
        query = "
          SELECT 
          round(AVG(distance/duration)) as speed,
          round(STDDEV_SAMP(distance/duration)/SQRT(COUNT(id)) ) as error,
          count(id) as n" + common_sql_select_from + common_sql_where + "
          AND duration < 4
          GROUP BY species_id
        "
      when "autumn"
        query = common_spring_autumn_begin + 
        " AND
          (
            MONTH(c1.date) = 3 OR 
            MONTH(c1.date) = 4 OR 
            MONTH(c1.date) = 5
          ) AND
          (
            MONTH(c2.date) = 3 OR 
            MONTH(c2.date) = 4 OR 
            MONTH(c2.date) = 5
          ) AND
          distance_north > 0 AND
        " + common_spring_autumn_end
        
      when "spring"   
        query = common_spring_autumn_begin + 
        " AND
          (
            MONTH(c1.date) = 8 OR 
            MONTH(c1.date) = 9 OR 
            MONTH(c1.date) = 10 OR
            MONTH(c1.date) = 11 
          ) AND
          (
            MONTH(c2.date) = 8 OR 
            MONTH(c2.date) = 9 OR 
            MONTH(c2.date) = 10 OR
            MONTH(c2.date) = 11 
          ) AND
          distance_north < 0 AND
        " + common_spring_autumn_end
    end

    res = (sql.execute query).fetch_row

    return [res[0].to_f,0] 
        
  end
  def capture_condition (country, month, condition)
    sql = ActiveRecord::Base.connection()
    sql_common_begin = "
      SELECT count(*) / (71) FROM 
      flights f
      JOIN captures c1 
        ON f.sch = c1.sch AND f.ringnr = c1.ringnr AND f.occ_start = c1.occ 
      JOIN captures c2 
        ON f.sch = c2.sch AND f.ringnr = c2.ringnr AND f.occ_end = c2.occ 
      JOIN capture_countries cc1 
        ON cc1.sch = f.sch AND cc1.ringnr=f.ringnr AND cc1.occ = f.occ_start
      JOIN capture_countries cc2 
        ON cc2.sch = f.sch AND cc2.ringnr=f.ringnr AND cc2.occ = f.occ_end
      JOIN ducks d 
        ON d.sch = f.sch AND d.ringnr = f.ringnr
      WHERE 
        cc1.country_id = 'NL' AND 
        cc2.country_id = '#{country}' AND 
        species_id = '#{self.id}' AND
        month(c2.date) = #{month}
    "
    
    sql_common_end = "
    "

    case condition
    when 'dead'
      sql_condition = "AND
        (
          c2.`condition` = 1 OR
          c2.`condition` = 2 OR
          c2.`condition` = 3
        )"
    when 'alive'
      sql_condition = "AND  
        (
          c2.`condition` = 6 OR
          c2.`condition` = 7 OR
          c2.`condition` = 8 OR
          c2.`condition` = 9
        )"
    end

    return sql.execute(sql_common_begin + sql_condition + sql_common_end).fetch_row.first.to_f
  
  end
end
