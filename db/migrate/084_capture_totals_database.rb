class CaptureTotalsDatabase < ActiveRecord::Migration

  def self.up
    if (!system SQL_MIGRATE + "capture_totals_database.sql") then fail end
  end

  def self.down
    
  end
end
