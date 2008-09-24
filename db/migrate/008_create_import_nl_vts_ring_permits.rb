# This requires "TOTAALLIJSTNL04 coordinates.csv". Set "PROCESS_DUCK_DECOYS = false" in database.yml to disable this script.
class CreateImportNlVtsRingPermits < ActiveRecord::Migration

  def self.up
    if PROCESS_DUCK_DECOYS then 
      print "Create table and import data from SQL file..."
      if (!system SQL_IMPORT + "nl_vts_ring_permits.sql") then fail end
    end 
  end

  def self.down
    if PROCESS_DUCK_DECOYS then 
      drop_table "nl_vts_ring_permits"
    end
  end
end
