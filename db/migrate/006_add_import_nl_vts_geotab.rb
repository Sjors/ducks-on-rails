# This requires addressess_nl_vts.sql. Set "PROCESS_DUCK_DECOYS = false" in database.yml to disable this script.
class AddImportNlVtsGeotab < ActiveRecord::Migration

  def self.up
    if PROCESS_DUCK_DECOYS then 
      print "Create table and import data from file..."
      if (!system SQL_MIGRATE + "nl-vts-geotab.sql") then fail end
    end 
  end

  def self.down
    if PROCESS_DUCK_DECOYS then 
      drop_table "raw_geotab"
    end
  end
end
