class AddPopulateCaptureTotals < ActiveRecord::Migration

  def self.up
    create_table "capture_totals", :id => false, :force => true do |t|
      t.column "year",       :integer,                                :null => false
      t.column "species_id", :string,  :limit => 100, :default => "", :null => false
      t.column "age",        :string,  :limit => 5,   :default => "", :null => false
      t.column "country_id", :string,  :limit => 2,   :default => "", :null => false
      t.column "source",     :string,  :limit => 8,   :default => "", :null => false
      t.column "method",     :string,  :limit => 1,   :default => "", :null => false
      t.column "occ",        :integer,                                :null => false
      t.column "captures",   :integer,                                :null => false
    end

    execute 'ALTER TABLE capture_totals ADD PRIMARY KEY (year, species_id, age, country_id, source, method, occ)'
    execute 'ALTER TABLE capture_totals ADD FOREIGN KEY (species_id) REFERENCES `species`(id)'
    execute 'ALTER TABLE capture_totals ADD FOREIGN KEY (country_id) REFERENCES `countries`(id)'

    print "Insert data from SQL file..."
    if (!system SQL_MIGRATE + "capture_totals_limosa.sql") then fail end
  
  end

  def self.down
    drop_table "capture_totals"
  end
end
