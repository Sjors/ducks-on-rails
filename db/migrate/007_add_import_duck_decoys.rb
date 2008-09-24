# This requires "TOTAALLIJSTNL04 coordinates.csv". Set "PROCESS_DUCK_DECOYS = false" in database.yml to disable this script.
class AddImportDuckDecoys < ActiveRecord::Migration
  def self.up
    if PROCESS_DUCK_DECOYS then 
      print "Create table and import data from file..."
      if (!system SQL_MIGRATE + "decoys.sql") then fail end
    end 
  end

  def self.down
    if PROCESS_DUCK_DECOYS then 
      drop_table "raw_decoys"
    end
  end
end
