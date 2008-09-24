class AddTableYearDistances < ActiveRecord::Migration
  def self.up
    create_table "year_distances" do |t|
      t.column "species_id", :string,  :limit => 100, :default => "", :null => false
      t.column "sex",        :string, :limit => 6
      t.column "age",        :string,  :limit => 5,   :default => "", :null => false
      t.column "year_dep", :integer, :null => false
      t.column "distance",  :decimal, :precision => 10, :scale => 6, :null => true
      t.column "distance_sd",  :decimal, :precision => 10, :scale => 6, :null => true
      t.column "distance_sesm",  :decimal, :precision => 10, :scale => 6, :null => true
      t.column "distance_north",  :decimal, :precision => 10, :scale => 6, :null => true
      t.column "distance_north_sd",  :decimal, :precision => 10, :scale => 6, :null => true
      t.column "distance_north_sesm",  :decimal, :precision => 10, :scale => 6, :null => true
      t.column "north_count",  :decimal, :precision => 10, :scale => 6, :null => true
      t.column "south_count",  :decimal, :precision => 10, :scale => 6, :null => true
    end
    execute 'ALTER TABLE year_distances ADD FOREIGN KEY (species_id) REFERENCES `species`(id)'
  end

  def self.down
    drop_table "year_distances"
  end
end
