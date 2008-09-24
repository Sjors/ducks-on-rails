class AddPopulateCountrySubdivisions < ActiveRecord::Migration

  def self.up
    create_table "country_subdivisions", :id => false, :force => true do |t|
      t.column "id",         :string, :limit => 6
      t.column "country_id", :string, :limit => 2,  :default => "", :null => false
      t.column "name",       :string, :limit => 30, :default => "", :null => false
    end
   
    execute 'ALTER TABLE country_subdivisions ADD FOREIGN KEY (country_id) REFERENCES `countries`(id)'
    
    execute 'ALTER TABLE country_subdivisions ADD PRIMARY KEY (id)'
    
    add_index "country_subdivisions", ["country_id"], :name => "country_id"

    print "Insert data from SQL file..."
    if (!system SQL_MIGRATE + "country_subdivisions.sql") then fail end
  
  end

  def self.down
    drop_table "country_subdivisions"
  end
end
