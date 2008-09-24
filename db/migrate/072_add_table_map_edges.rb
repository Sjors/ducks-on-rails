class AddTableMapEdges < ActiveRecord::Migration
  def self.up
    create_table "map_edges", :force => true do |t|
      t.column "species_id", :string, :limit => 100
      t.column "west",   :decimal, :precision => 10, :scale => 7
      t.column "east",   :decimal, :precision => 10, :scale => 7
      t.column "north",  :decimal, :precision => 10, :scale => 7
      t.column "south",  :decimal, :precision => 10, :scale => 7
    end
    execute 'ALTER TABLE map_edges ADD FOREIGN KEY (species_id) REFERENCES `species`(id)'
    
    # Populate
    Species.find(:all).each {|species|
    execute "
      INSERT INTO `map_edges` (`species_id`, `south`, `north`, `west`, `east`)
      SELECT '#{species.id}', if(min(lat)<45,min(lat)-2,45), if(max(lat)>55,max(lat)+7,55), if(min(lon)<0,min(lon)-2,0), if(max(lon)>10,max(lon)+7,10) FROM 
      (
        SELECT round(lat/5,0)*5 as lat, NULL as lon, count(lat) as c FROM 
        `captures` c JOIN 
        `capture_coordinates` cc 
        ON c.sch = cc.sch AND c.ringnr = cc.ringnr AND c.occ = cc.occ
        JOIN ducks d ON c.sch = d.sch AND c.ringnr = d.ringnr
        WHERE species_id = '#{species.id}'
        GROUP BY round(lat/5,0) 
      
        UNION

        SELECT NULL as lat, round(lon/5,0)*5 as lon, count(lon) as c FROM 
        `captures` c JOIN 
        `capture_coordinates` cc 
        ON c.sch = cc.sch AND c.ringnr = cc.ringnr AND c.occ = cc.occ
        JOIN ducks d ON c.sch = d.sch AND c.ringnr = d.ringnr
        WHERE species_id = '#{species.id}'
        GROUP BY round(lon/5,0) 
     ) t1 
     WHERE c > if(
       (
        SELECT COUNT(c.sch) 
        FROM 
         captures c JOIN ducks d ON c.sch = d.sch AND c.ringnr = d.ringnr
        WHERE species_id = '#{species.id}'
       ) > 10, 10,0)
     "
    }
  end

  def self.down
    drop_table "map_edges"
  end
end
