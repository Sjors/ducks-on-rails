class AddPopulateEuringAreaToIso < ActiveRecord::Migration

  def self.up
    
    print "Create tables and insert data from SQL file..."
    if (!system SQL_MIGRATE + "euring_area_to_iso.sql") then fail end
  
  end

  def self.down
    drop_table "euring_country_to_iso"
    drop_table "euring_former_country_to_iso"
    drop_table "euring_country_subdivision_to_iso"
  end
end
