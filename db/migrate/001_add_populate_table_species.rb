class AddPopulateTableSpecies < ActiveRecord::Migration
  def self.up
    create_table "species", :id => false, :force => true do |t|
      t.column "id",          :string, :limit => 100
      t.column "picture_url", :text
      t.column "info_url",    :text
      t.column "name_nl",     :string, :limit => 30
      t.column "name_en",     :string, :limit => 30
      t.column "euring_id",   :integer
    end
    
    execute 'ALTER TABLE species ADD PRIMARY KEY (id)'
    
    print "Insert data from SQL file..."
    if (!system SQL_MIGRATE + "species.sql") then fail end
 
 end
   def self.down
    drop_table "species"
  end
end

