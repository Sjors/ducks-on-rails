class TableFlights < ActiveRecord::Migration
  def self.up
    create_table "flights" do |t|
      t.column "sch",       :string,  :limit => 3, :default => "", :null => false
      t.column "ringnr",    :string,  :limit => 8, :default => "", :null => false
      t.column "occ_start", :integer,                              :null => false
      t.column "occ_end",   :integer,                              :null => false
      t.column "distance",  :decimal, :precision => 10, :scale => 6, :null => false
      t.column "distance_north",  :decimal, :precision => 10, :scale => 6, :null => false
      t.column "angle",  :decimal, :precision => 10, :scale => 6, :null => false
    end
    
    execute 'ALTER TABLE flights ADD FOREIGN KEY (sch, ringnr, occ_start) REFERENCES `captures`(sch, ringnr, occ)' 
    execute 'ALTER TABLE flights ADD FOREIGN KEY (sch, ringnr, occ_end) REFERENCES `captures`(sch, ringnr, occ)' 
  end

  def self.down
    drop_table "flights"
  end
end
