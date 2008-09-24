class AddPopulateDucksRingedFound < ActiveRecord::Migration

  def self.up
    print "Create table and insert data from SQL and CSV files..."
    if (!system SQL_MIGRATE + "import_ducks_ringed_found.sql") then fail end
  
  end

  def self.down
    drop_table "raw_found_ducks"
    drop_table "raw_ringed_ducks"
  end
end
