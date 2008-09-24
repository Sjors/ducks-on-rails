class PreProcessEuropeanCaptures < ActiveRecord::Migration
  def self.up
    # Create table
    create_table "month_captures", :id => false, :force => true do |t|
      t.column "species_id", :string,  :limit => 100, :default => "", :null => false
      t.column "month",      :integer,                                :null => false
      t.column "lon",                    :decimal,               :precision => 10, :scale => 7
      t.column "lat",                    :decimal,               :precision => 10, :scale => 7
      t.column "count", :integer, :null => false          
    end
    execute 'ALTER TABLE month_captures ADD PRIMARY KEY (species_id, month, lon, lat)'
    
    execute '
    ALTER TABLE month_captures ADD FOREIGN KEY 
        (species_id) 
        REFERENCES `species`(id)'
   
    # Populate table
    for species in Species.find(:all) do
      for month in 1..12 do
        execute "
          INSERT INTO month_captures 
          SELECT 
            '#{species.id}',
            #{month},
            lon, 
            lat, 
            count(c.occ) as count
          FROM 
             `captures` c 
             JOIN `capture_coordinates` cCoo
             ON c.sch = cCoo.sch AND c.ringnr = cCoo.ringnr AND c.occ = cCoo.occ
             JOIN `ducks` d 
             ON c.sch = d.sch AND c.ringnr = d.ringnr
             JOIN `capture_counts` cC ON c.sch = cC.sch AND c.ringnr = cC.ringnr
             LEFT JOIN `capture_countries` cCou
             ON c.sch = cCou.sch AND c.ringnr = cCou.ringnr AND c.occ = cCou.occ
          WHERE 
            species_id = '#{species.id}' AND
            cC.captures > 1 AND
            MONTH(date) = #{month}
          GROUP BY lat, lon;
        "
      end
    end
  end

  def self.down
    drop_table "month_captures"
  end
end
