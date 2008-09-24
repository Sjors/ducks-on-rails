class AddPopulateCountries < ActiveRecord::Migration

  def self.up
    create_table "countries", :id => false, :force => true do |t|
      t.column "id",   :string, :limit => 2
      t.column "name", :string, :limit => 30, :default => "", :null => false
    end
    
    execute 'ALTER TABLE countries ADD PRIMARY KEY (id)'
    
    create_table "former_countries", :id => false, :force => true do |t|
      t.column "id",   :string, :limit => 4
      t.column "name", :string, :limit => 30, :default => "", :null => false
    end
    
    execute 'ALTER TABLE former_countries ADD PRIMARY KEY (id)'

    print "Insert data from SQL file..."
    if (!system SQL_MIGRATE + "countries.sql") then fail end
  
  end

  def self.down
    drop_table "countries"
    drop_table "former_countries"
  end
end
