# This requires addressess_nl_vts.sql. Set "PROCESS_DUCK_DECOYS = false" in database.yml to disable this script.
class AdressesCurrentAndFormerRingers < ActiveRecord::Migration

  def self.up
    if PROCESS_DUCK_DECOYS then 
      create_table "addresses_nl_vts", :id => false, :force => true do |t|
        t.column "KODE",       :string, :limit => 3,  :default => "", :null => false
        t.column "INSTANTIE",  :string, :limit => 30, :default => "", :null => false
        t.column "DHR_MEVR",   :string, :limit => 5,  :default => "", :null => false
        t.column "VOORZETSEL", :string, :limit => 30, :default => "", :null => false
        t.column "VOORNAAM",   :string, :limit => 30, :default => "", :null => false
        t.column "ACHTERNAAM", :string, :limit => 30, :default => "", :null => false
        t.column "STRAAT_HSN", :string, :limit => 30, :default => "", :null => false
        t.column "POSTCODE",   :string, :limit => 9,  :default => "", :null => false
        t.column "WOONPLAATS", :string, :limit => 30, :default => "", :null => false
        t.column "LAND",       :string, :limit => 30, :default => "", :null => false
      end
      execute 'ALTER TABLE addresses_nl_vts ADD PRIMARY KEY (KODE)'

      print "Import data from SQL file..."
      if (!system SQL_IMPORT + "addresses_nl_vts.sql") then fail end
    end 
  end

  def self.down
    if PROCESS_DUCK_DECOYS then 
      drop_table "addresses_nl_vts"
    end
  end
end
