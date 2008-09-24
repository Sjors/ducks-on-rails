class AddTableBreedingSuccess < ActiveRecord::Migration
  def self.up
    create_table "breeding_successes", :id => false, :force => true do |t|
      t.column "region",     :string, :limit=>20, :null => false
      t.column "species_id", :string,  :limit => 100, :default => "", :null => false
      t.column "sex",        :string, :limit => 6, :null => false
      t.column "year",       :integer, :null => false
      t.column "firstyear",  :integer, :null => true
      t.column "firstyearandolder",  :integer, :null => true 
      t.column "fraction",  :decimal, :precision => 10, :scale => 6, :null => true
      t.column "fraction_sd",  :decimal, :precision => 10, :scale => 6, :null => true
    end

    execute "ALTER TABLE breeding_successes ADD PRIMARY KEY (region, species_id, sex, year)"

    execute 'ALTER TABLE breeding_successes ADD FOREIGN KEY (species_id) REFERENCES `species`(id)'
  end

  def self.down
    drop_table "breeding_successes"
  end
end
