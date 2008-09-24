class RunProcessDataScripts < ActiveRecord::Migration

  def self.up
    # All scripts that are executed in processData.sh should have their own migration.
    # Numbers 20-80 are reserved for that.
    print "Create lots of tables..."
    
    create_table "ducks", :id => false, :force => true do |t|
      t.column "sch",        :string, :limit => 3,   :default => "", :null => false
      t.column "ringnr",     :string, :limit => 8,   :default => "", :null => false
      t.column "species_id", :string, :limit => 100
      t.column "sex",        :string, :limit => 6
    end

    execute '
    ALTER TABLE ducks ADD FOREIGN KEY 
        (species_id) 
        REFERENCES `species`(id)  ON DELETE CASCADE'

    execute 'ALTER TABLE ducks ADD PRIMARY KEY (sch, ringnr)'
    add_index "ducks", ["sex"], :name => "sex"
    
    create_table "captures", :id => false, :force => true do |t|
      t.column "sch",           :string,  :limit => 3, :default => "", :null => false
      t.column "ringnr",        :string,  :limit => 8, :default => "", :null => false
      t.column "occ",           :integer,                              :null => false
      t.column "date",          :date,                                 :null => false
      t.column "dateAcc",       :integer,                              :null => false
      t.column "method",        :string,  :limit => 1
      t.column "age",           :integer
      t.column "condition",     :integer
      t.column "circumstances", :integer
    end
    
    execute '
    ALTER TABLE captures ADD FOREIGN KEY 
        (sch, ringnr) 
        REFERENCES `ducks` (sch, ringnr) ON DELETE CASCADE
    '

    execute 'ALTER TABLE captures ADD PRIMARY KEY (sch, ringnr, occ)'
    add_index "captures", ["date"], :name => "date"
    add_index "captures", ["dateAcc"], :name => "dateAcc"
    add_index "captures", ["age"], :name => "age"
    add_index "captures", ["condition"], :name => "condition"
    add_index "captures", ["circumstances"], :name => "circumstances"
   
    create_table "capture_coordinates", :id => false, :force => true do |t|
      t.column "sch",    :string,  :limit => 3, :default => "", :null => false
      t.column "ringnr", :string,  :limit => 8, :default => "", :null => false
      t.column "occ",    :integer,                              :null => false
      t.column "lat",    :decimal,              :precision => 10, :scale => 7,                 :null => false
      t.column "lon",    :decimal,              :precision => 10, :scale => 7,                 :null => false
    end

    execute 'ALTER TABLE capture_coordinates ADD PRIMARY KEY (sch, ringnr, occ)'
    add_index "capture_coordinates", ["lat", "lon"], :name => "lat"
    
    execute 'ALTER TABLE capture_coordinates ADD FOREIGN KEY (sch, ringnr, occ) REFERENCES `captures`(sch, ringnr, occ)' 

    create_table "capture_countries", :id => false, :force => true do |t|
      t.column "sch",        :string,  :limit => 3, :default => "", :null => false
      t.column "ringnr",     :string,  :limit => 8, :default => "", :null => false
      t.column "occ",        :integer,                              :null => false
      t.column "country_id", :string,  :limit => 2
    end
    
    execute 'ALTER TABLE capture_countries ADD FOREIGN KEY (sch, ringnr, occ) REFERENCES `captures`(sch, ringnr, occ) ON DELETE CASCADE'
    execute 'ALTER TABLE capture_countries ADD FOREIGN KEY (country_id) REFERENCES `countries`(id) ON DELETE CASCADE'

    execute 'ALTER TABLE capture_countries ADD PRIMARY KEY (sch, ringnr, occ)'


    create_table "capture_country_subdivisions", :id => false, :force => true do |t|
        t.column "sch",                     :string,  :limit => 3,  :null => false
        t.column "ringnr",                  :string,  :limit => 8,  :null => false
        t.column "occ",                     :integer,               :null => false
        t.column "country_subdivision_id",  :string,  :limit => 6
    end
    execute 'ALTER TABLE capture_country_subdivisions ADD FOREIGN KEY (sch, ringnr, occ) REFERENCES `captures`(sch, ringnr, occ) ON DELETE CASCADE'
    execute 'ALTER TABLE capture_country_subdivisions ADD FOREIGN KEY (country_subdivision_id) REFERENCES `country_subdivisions`(id) ON DELETE CASCADE'
    execute 'ALTER TABLE capture_country_subdivisions ADD PRIMARY KEY (sch, ringnr, occ)'
    
    create_table "capture_former_countries", :id => false, :force => true do |t|
        t.column "sch",                     :string,  :limit => 3,  :null => false
        t.column "ringnr",                  :string,  :limit => 8,  :null => false
        t.column "occ",                     :integer,               :null => false
        t.column "former_country_id",       :string,  :limit => 4
    end
    execute 'ALTER TABLE capture_former_countries ADD FOREIGN KEY (sch, ringnr, occ) REFERENCES `captures`(sch, ringnr, occ) ON DELETE CASCADE'
    execute 'ALTER TABLE capture_former_countries ADD FOREIGN KEY (former_country_id) REFERENCES `former_countries`(id) ON DELETE CASCADE'
    execute 'ALTER TABLE capture_former_countries ADD PRIMARY KEY (sch, ringnr, occ)'

    
    # This requires "addressess_nl_vts.sql", "nl_vts_geotab", "nl_vts_ring_permits.sql", "ringers.sql" and "TOTAALLIJSTNL04 coordinates.csv".
    # Set "PROCESS_DUCK_DECOYS = false" in database.yml to disable this script.
    if PROCESS_DUCK_DECOYS then 
      create_table "ringer_captures", :id => false, :force => true do |t|
        t.column "ringer_id", :string,  :limit => 3, :default => "", :null => false
        t.column "sch",       :string,  :limit => 3, :default => "", :null => false
        t.column "ringnr",    :string,  :limit => 8, :default => "", :null => false
        t.column "occ",       :integer,                              :null => false
      end
    
      execute 'ALTER TABLE ringer_captures ADD PRIMARY KEY (ringer_id, sch, ringnr, occ)'
      
      execute '
      ALTER TABLE ringer_captures ADD FOREIGN KEY 
          (ringer_id) REFERENCES `addresses_nl_vts` (KODE) ON DELETE CASCADE'

      execute '
      ALTER TABLE ringer_captures ADD FOREIGN KEY
          (sch, ringnr, occ) REFERENCES `captures`(sch, ringnr, occ) ON DELETE CASCADE'

      create_table "duck_decoys", :force => true do |t|
        t.column "naam",                   :string,  :limit => 50,                                :default => "", :null => false
        t.column "gemeente",               :string,  :limit => 50,                                :default => "", :null => false
        t.column "country_subdivision_id", :string,  :limit => 6
        t.column "lat",                    :decimal,               :precision => 10, :scale => 7
        t.column "lon",                    :decimal,               :precision => 10, :scale => 7
        t.column "registratienummer",      :string,  :limit => 50,                                :default => "", :null => false
        t.column "duur_nummer",            :string,  :limit => 50,                                :default => "", :null => false
        t.column "kadasteromschrijving",   :string,  :limit => 50,                                :default => "", :null => false
      end
      
      execute 'ALTER TABLE duck_decoys ADD FOREIGN KEY 
          (country_subdivision_id) 
          REFERENCES `country_subdivisions`(id) ON DELETE CASCADE'

      add_index "duck_decoys", ["lat", "lon"], :name => "lat"
      
      create_table "ringer_kooikers", :id => false, :force => true do |t|
        t.column "rid",              :string,  :limit => 3, :default => "", :null => false
        t.column "nearest_decoy_id", :integer
        t.column "decoy_distance",   :float
        t.column "h1",               :boolean
        t.column "h2",               :boolean
        t.column "h3",               :boolean
        t.column "minlv",            :boolean
        t.column "expert",           :boolean
        t.column "kooiker",          :boolean
        t.column "kooiker_vermoed",  :boolean
      end
    
      execute 'ALTER TABLE ringer_kooikers ADD PRIMARY KEY (rid)'
      
      execute '
      ALTER TABLE ringer_kooikers ADD FOREIGN KEY 
          (rid) REFERENCES `addresses_nl_vts` (KODE) ON DELETE CASCADE'
      execute '
      ALTER TABLE ringer_kooikers ADD FOREIGN KEY 
          (nearest_decoy_id) REFERENCES `duck_decoys` (id) ON DELETE CASCADE'

      add_index "ringer_kooikers", ["h1"], :name => "h1"
      add_index "ringer_kooikers", ["h2"], :name => "h2"
      add_index "ringer_kooikers", ["h3"], :name => "h3"
      add_index "ringer_kooikers", ["kooiker"], :name => "kooiker"
      add_index "ringer_kooikers", ["kooiker_vermoed"], :name => "kooiker_vermoed"
      
      create_table "coordinate_decoys", :id => false, :force => true do |t|
        t.column "lon",             :decimal, :precision => 10, :scale => 7, :null => false
        t.column "lat",             :decimal, :precision => 10, :scale => 7, :null => false
        t.column "decoy_id",   :integer,                                :null => false
        t.column "decoy_distance",  :float
        t.column "h2",              :boolean
        t.column "kooiker_vermoed", :boolean
      end
      
      execute 'ALTER TABLE coordinate_decoys ADD PRIMARY KEY (lon, lat)'
      
      execute '
      ALTER TABLE coordinate_decoys ADD FOREIGN KEY 
          (decoy_id) REFERENCES `duck_decoys` (id) ON DELETE CASCADE'

      add_index "coordinate_decoys", ["decoy_id"], :name => "duck_decoy_id"
      add_index "coordinate_decoys", ["decoy_distance"], :name => "decoy_distance"
      add_index "coordinate_decoys", ["h2"], :name => "h2"
      add_index "coordinate_decoys", ["kooiker_vermoed"], :name => "kooiker_vermoed"
    end
    print "Run lots of scripts..."
    if (!system "sh db/migrate/bash/convertData.sh #{PROCESS_DUCK_DECOYS}") then fail end
  
  end

  def self.down
    # Add tables to be dropped
    if PROCESS_DUCK_DECOYS then 
      drop_table "coordinate_decoys"
      drop_table "ringer_kooikers" 
      drop_table "duck_decoys" 
      drop_table "coordinate_names"
      drop_table "country_subdivision_coordinates"
      drop_table "former_country_coordinates"
      drop_table "country_coordinates"
    end 
    if PROCESS_DUCK_DECOYS then 
      drop_table "ringer_captures"    
    end 
    drop_table "capture_country_subdivisions"
    drop_table "capture_countries"
    drop_table "capture_former_countries"   
    drop_table "manipulations" 
    drop_table "capture_coordinates" 
    drop_table "capture_counts" 
    drop_table "captures"
    drop_table "temp_merge_raw_captures"
    drop_table "ducks"
  end
end
