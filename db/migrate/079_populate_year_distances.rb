class PopulateYearDistances < ActiveRecord::Migration
  def self.up
    # Merge five consequetive years, because there is not enough data.
    execute "
      INSERT INTO year_distances (
        species_id, 
        sex, 
        age, 
        year_dep, 
        distance, 
        distance_sd, 
        distance_sesm,
        distance_north, 
        distance_north_sd, 
        distance_north_sesm,
        north_count,
        south_count
      )
      SELECT 
        species_id, 
        'all',
        age,
        year_dep,
        AVG(distance),  
        STDDEV_SAMP(distance),
        STDDEV_SAMP(distance) / SQRT(count(distance)),
        AVG(distance_north),  
        STDDEV_SAMP(distance_north),
        STDDEV_SAMP(distance_north) / SQRT(count(distance_north)),
        SUM(if(distance_north > 100,1,0)),
        SUM(if(distance_north < 100,1,0))
      FROM year_all_distances
      WHERE 1
      GROUP BY species_id, year_dep
    "
  end

  def self.down
    execute "truncate year_distances"
  end
end
