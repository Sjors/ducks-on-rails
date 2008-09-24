# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 84) do

  create_table "addresses_nl_vts", :primary_key => "KODE", :force => true do |t|
    t.string "INSTANTIE",  :limit => 30, :default => "", :null => false
    t.string "DHR_MEVR",   :limit => 5,  :default => "", :null => false
    t.string "VOORZETSEL", :limit => 30, :default => "", :null => false
    t.string "VOORNAAM",   :limit => 30, :default => "", :null => false
    t.string "ACHTERNAAM", :limit => 30, :default => "", :null => false
    t.string "STRAAT_HSN", :limit => 30, :default => "", :null => false
    t.string "POSTCODE",   :limit => 9,  :default => "", :null => false
    t.string "WOONPLAATS", :limit => 30, :default => "", :null => false
    t.string "LAND",       :limit => 30, :default => "", :null => false
  end

  create_table "breeding_successes", :id => false, :force => true do |t|
    t.string  "region",            :limit => 20,                                 :default => "", :null => false
    t.string  "species_id",        :limit => 100,                                :default => "", :null => false
    t.string  "sex",               :limit => 6,                                  :default => "", :null => false
    t.integer "year",                                                                            :null => false
    t.integer "firstyear"
    t.integer "firstyearandolder"
    t.decimal "fraction",                         :precision => 10, :scale => 6
    t.decimal "fraction_sd",                      :precision => 10, :scale => 6
  end

  add_index "breeding_successes", ["species_id"], :name => "species_id"

  create_table "capture_coordinates", :id => false, :force => true do |t|
    t.string  "sch",                                 :limit => 3,                                :default => "", :null => false
    t.string  "ringnr",                              :limit => 8,                                :default => "", :null => false
    t.integer "occ",                                                                                             :null => false
    t.decimal "lat",                                              :precision => 10, :scale => 7,                 :null => false
    t.decimal "lon",                                              :precision => 10, :scale => 7,                 :null => false
    t.boolean "country_consistent"
    t.boolean "country_subdivision_consistent"
    t.boolean "country_subdivision_consistent_10k"
    t.boolean "country_subdivision_geonames_no_iso"
  end

  add_index "capture_coordinates", ["lat", "lon"], :name => "lat"

  create_table "capture_countries", :id => false, :force => true do |t|
    t.string  "sch",                      :limit => 3, :default => "", :null => false
    t.string  "ringnr",                   :limit => 8, :default => "", :null => false
    t.integer "occ",                                                   :null => false
    t.string  "country_id",               :limit => 2
    t.boolean "derived_from_coordinates"
  end

  add_index "capture_countries", ["country_id"], :name => "country_id"

  create_table "capture_country_subdivisions", :id => false, :force => true do |t|
    t.string  "sch",                      :limit => 3, :default => "", :null => false
    t.string  "ringnr",                   :limit => 8, :default => "", :null => false
    t.integer "occ",                                                   :null => false
    t.string  "country_subdivision_id",   :limit => 6
    t.boolean "derived_from_coordinates"
  end

  add_index "capture_country_subdivisions", ["country_subdivision_id"], :name => "country_subdivision_id"

  create_table "capture_counts", :id => false, :force => true do |t|
    t.string  "sch",      :limit => 3, :default => "", :null => false
    t.string  "ringnr",   :limit => 8, :default => "", :null => false
    t.integer "captures",                              :null => false
  end

  create_table "capture_former_countries", :id => false, :force => true do |t|
    t.string  "sch",               :limit => 3, :default => "", :null => false
    t.string  "ringnr",            :limit => 8, :default => "", :null => false
    t.integer "occ",                                            :null => false
    t.string  "former_country_id", :limit => 4
  end

  add_index "capture_former_countries", ["former_country_id"], :name => "former_country_id"

  create_table "capture_totals", :id => false, :force => true do |t|
    t.integer "year",                                      :null => false
    t.string  "species_id", :limit => 100, :default => "", :null => false
    t.string  "age",        :limit => 5,   :default => "", :null => false
    t.string  "country_id", :limit => 2,   :default => "", :null => false
    t.string  "source",     :limit => 8,   :default => "", :null => false
    t.string  "method",     :limit => 1,   :default => "", :null => false
    t.integer "occ",                                       :null => false
    t.integer "captures",                                  :null => false
  end

  add_index "capture_totals", ["species_id"], :name => "species_id"
  add_index "capture_totals", ["country_id"], :name => "country_id"

  create_table "captures", :id => false, :force => true do |t|
    t.string  "sch",           :limit => 3, :default => "", :null => false
    t.string  "ringnr",        :limit => 8, :default => "", :null => false
    t.integer "occ",                                        :null => false
    t.date    "date",                                       :null => false
    t.integer "dateAcc",                                    :null => false
    t.string  "method",        :limit => 1
    t.integer "age"
    t.integer "condition"
    t.integer "circumstances"
  end

  add_index "captures", ["date"], :name => "date"
  add_index "captures", ["dateAcc"], :name => "dateAcc"
  add_index "captures", ["age"], :name => "age"
  add_index "captures", ["condition"], :name => "condition"
  add_index "captures", ["circumstances"], :name => "circumstances"

  create_table "coordinate_decoys", :id => false, :force => true do |t|
    t.decimal "lon",             :precision => 10, :scale => 7, :null => false
    t.decimal "lat",             :precision => 10, :scale => 7, :null => false
    t.integer "decoy_id",                                       :null => false
    t.float   "decoy_distance"
    t.boolean "h2"
    t.boolean "kooiker_vermoed"
  end

  add_index "coordinate_decoys", ["decoy_id"], :name => "duck_decoy_id"
  add_index "coordinate_decoys", ["decoy_distance"], :name => "decoy_distance"
  add_index "coordinate_decoys", ["h2"], :name => "h2"
  add_index "coordinate_decoys", ["kooiker_vermoed"], :name => "kooiker_vermoed"

  create_table "coordinate_names", :id => false, :force => true do |t|
    t.decimal "lat",                :precision => 10, :scale => 7, :default => 0.0, :null => false
    t.decimal "lon",                :precision => 10, :scale => 7, :default => 0.0, :null => false
    t.integer "occ",                                                                :null => false
    t.string  "name", :limit => 50,                                :default => "",  :null => false
  end

  add_index "coordinate_names", ["name"], :name => "name"

  create_table "countries", :force => true do |t|
    t.string "name", :limit => 30, :default => "", :null => false
  end

  create_table "country_coordinates", :id => false, :force => true do |t|
    t.decimal "lat",                     :precision => 10, :scale => 7, :null => false
    t.decimal "lon",                     :precision => 10, :scale => 7, :null => false
    t.string  "country_id", :limit => 2
  end

  add_index "country_coordinates", ["country_id"], :name => "country_id"

  create_table "country_subdivision_coordinates", :id => false, :force => true do |t|
    t.decimal "lat",                                 :precision => 10, :scale => 7, :null => false
    t.decimal "lon",                                 :precision => 10, :scale => 7, :null => false
    t.string  "country_subdivision_id", :limit => 6
  end

  add_index "country_subdivision_coordinates", ["country_subdivision_id"], :name => "country_subdivision_id"

  create_table "country_subdivisions", :force => true do |t|
    t.string "country_id", :limit => 2,  :default => "", :null => false
    t.string "name",       :limit => 30, :default => "", :null => false
  end

  add_index "country_subdivisions", ["country_id"], :name => "country_id"

  create_table "duck_decoys", :force => true do |t|
    t.string  "naam",                   :limit => 50,                                :default => "", :null => false
    t.string  "gemeente",               :limit => 50,                                :default => "", :null => false
    t.string  "country_subdivision_id", :limit => 6
    t.decimal "lat",                                  :precision => 10, :scale => 7
    t.decimal "lon",                                  :precision => 10, :scale => 7
    t.string  "registratienummer",      :limit => 50,                                :default => "", :null => false
    t.string  "duur_nummer",            :limit => 50,                                :default => "", :null => false
    t.string  "kadasteromschrijving",   :limit => 50,                                :default => "", :null => false
  end

  add_index "duck_decoys", ["country_subdivision_id"], :name => "country_subdivision_id"
  add_index "duck_decoys", ["lat", "lon"], :name => "lat"

  create_table "ducks", :id => false, :force => true do |t|
    t.string "sch",        :limit => 3,   :default => "", :null => false
    t.string "ringnr",     :limit => 8,   :default => "", :null => false
    t.string "species_id", :limit => 100
    t.string "sex",        :limit => 6
  end

  add_index "ducks", ["species_id"], :name => "species_id"
  add_index "ducks", ["sex"], :name => "sex"

  create_table "euring_country_subdivision_to_iso", :primary_key => "ar", :force => true do |t|
    t.string "country_subdivision_id", :limit => 6
  end

  add_index "euring_country_subdivision_to_iso", ["country_subdivision_id"], :name => "country_subdivision_id"

  create_table "euring_country_to_iso", :primary_key => "ar", :force => true do |t|
    t.string "country_id", :limit => 2
  end

  add_index "euring_country_to_iso", ["country_id"], :name => "country_id"

  create_table "euring_former_country_to_iso", :id => false, :force => true do |t|
    t.string "ar",                :limit => 4, :default => "", :null => false
    t.string "former_country_id", :limit => 4, :default => "", :null => false
  end

  add_index "euring_former_country_to_iso", ["former_country_id"], :name => "former_country_id"

  create_table "flights", :force => true do |t|
    t.string  "sch",            :limit => 3,                                :default => "", :null => false
    t.string  "ringnr",         :limit => 8,                                :default => "", :null => false
    t.integer "occ_start",                                                                  :null => false
    t.integer "occ_end",                                                                    :null => false
    t.decimal "distance",                    :precision => 10, :scale => 6,                 :null => false
    t.decimal "distance_north",              :precision => 10, :scale => 6,                 :null => false
    t.decimal "angle",                       :precision => 10, :scale => 6,                 :null => false
    t.integer "duration"
  end

  add_index "flights", ["sch", "ringnr", "occ_start"], :name => "sch"
  add_index "flights", ["sch", "ringnr", "occ_end"], :name => "sch_2"

  create_table "former_countries", :force => true do |t|
    t.string "name", :limit => 30, :default => "", :null => false
  end

  create_table "former_country_coordinates", :id => false, :force => true do |t|
    t.decimal "lat",                            :precision => 10, :scale => 7,                 :null => false
    t.decimal "lon",                            :precision => 10, :scale => 7,                 :null => false
    t.string  "former_country_id", :limit => 4,                                :default => "", :null => false
  end

  add_index "former_country_coordinates", ["former_country_id"], :name => "former_country_id"

  create_table "manipulations", :force => true do |t|
    t.timestamp "timestamp",                               :null => false
    t.string    "type",      :limit => 50, :default => "", :null => false
    t.string    "ref",       :limit => 50, :default => "", :null => false
  end

  create_table "map_edges", :force => true do |t|
    t.string  "species_id", :limit => 100
    t.decimal "west",                      :precision => 10, :scale => 7
    t.decimal "east",                      :precision => 10, :scale => 7
    t.decimal "north",                     :precision => 10, :scale => 7
    t.decimal "south",                     :precision => 10, :scale => 7
  end

  add_index "map_edges", ["species_id"], :name => "species_id"

  create_table "month_captures", :id => false, :force => true do |t|
    t.string  "species_id", :limit => 100,                                :default => "",  :null => false
    t.integer "month",                                                                     :null => false
    t.decimal "lon",                       :precision => 10, :scale => 7, :default => 0.0, :null => false
    t.decimal "lat",                       :precision => 10, :scale => 7, :default => 0.0, :null => false
    t.integer "count",                                                                     :null => false
  end

  create_table "nao", :primary_key => "year", :force => true do |t|
    t.float "nao"
  end

  create_table "nl_vts_ring_permits", :force => true do |t|
    t.string "FirstName",      :limit => 29, :default => "", :null => false
    t.string "MiddleName",     :limit => 14, :default => "", :null => false
    t.string "LastName",       :limit => 27, :default => "", :null => false
    t.string "JobTitle",       :limit => 3,  :default => "", :null => false
    t.string "HomeStreet",     :limit => 38, :default => "", :null => false
    t.string "HomeCity",       :limit => 27, :default => "", :null => false
    t.string "HomePostalCode", :limit => 9,  :default => "", :null => false
    t.string "Categories",     :limit => 57, :default => "", :null => false
  end

  add_index "nl_vts_ring_permits", ["JobTitle"], :name => "JobTitle"
  add_index "nl_vts_ring_permits", ["Categories"], :name => "Categories"

  create_table "raw_decoys", :force => true do |t|
    t.string "registratienummer",       :limit => 20,  :default => "", :null => false
    t.string "naam_eendenkooi",         :limit => 40,  :default => "", :null => false
    t.string "gemeente",                :limit => 30,  :default => "", :null => false
    t.string "provincie",               :limit => 20,  :default => "", :null => false
    t.string "dur_nummer",              :limit => 40,  :default => "", :null => false
    t.string "kadastrale_omschrijving", :limit => 100, :default => "", :null => false
    t.string "coordinaten",             :limit => 20,  :default => "", :null => false
  end

  add_index "raw_decoys", ["coordinaten"], :name => "coordinaten"

  create_table "raw_found_ducks", :force => true do |t|
    t.string  "sch",    :limit => 3
    t.string  "ringnr", :limit => 8
    t.integer "fspec",  :limit => 5
    t.string  "ve",     :limit => 1
    t.integer "fx",     :limit => 2
    t.string  "fa",     :limit => 1
    t.date    "fdate"
    t.string  "fy",     :limit => 2
    t.string  "far",    :limit => 4
    t.string  "fca",    :limit => 4
    t.string  "fcb",    :limit => 4
    t.string  "fq",     :limit => 1
    t.integer "c",      :limit => 1
    t.integer "ci",     :limit => 2
    t.string  "tr",     :limit => 1
    t.string  "pr",     :limit => 1
    t.string  "fs",     :limit => 1
    t.integer "fb",     :limit => 1
    t.string  "dist",   :limit => 4
    t.string  "dir",    :limit => 4
    t.string  "fid",    :limit => 10
    t.date    "ref"
  end

  add_index "raw_found_ducks", ["sch", "ringnr"], :name => "sch"
  add_index "raw_found_ducks", ["far"], :name => "far"
  add_index "raw_found_ducks", ["fca"], :name => "fca"
  add_index "raw_found_ducks", ["fcb"], :name => "fcb"
  add_index "raw_found_ducks", ["fq"], :name => "fq"

  create_table "raw_geotab", :id => false, :force => true do |t|
    t.string "area",    :limit => 4,  :default => "", :null => false
    t.string "lat",     :limit => 4
    t.string "lon",     :limit => 4
    t.string "q",       :limit => 1,  :default => "", :null => false
    t.string "ca",      :limit => 4
    t.string "cb",      :limit => 4
    t.string "geoname", :limit => 50, :default => "", :null => false
  end

  add_index "raw_geotab", ["area"], :name => "area"
  add_index "raw_geotab", ["q"], :name => "q"
  add_index "raw_geotab", ["ca"], :name => "ca"
  add_index "raw_geotab", ["cb"], :name => "cb"
  add_index "raw_geotab", ["geoname"], :name => "geoname"
  add_index "raw_geotab", ["lat", "lon"], :name => "lat"

  create_table "raw_ringed_ducks", :id => false, :force => true do |t|
    t.string  "sch",    :limit => 3,  :default => "", :null => false
    t.string  "ringnr", :limit => 8,  :default => "", :null => false
    t.integer "rspec",  :limit => 5
    t.integer "rf"
    t.string  "ch",     :limit => 1
    t.integer "rx",     :limit => 2
    t.string  "ra",     :limit => 1
    t.string  "rs",     :limit => 1
    t.string  "rb",     :limit => 1
    t.string  "p",      :limit => 1
    t.date    "rdate"
    t.time    "rtime"
    t.string  "ry",     :limit => 2
    t.string  "rar",    :limit => 4
    t.string  "rca",    :limit => 4
    t.string  "rcb",    :limit => 4
    t.string  "rq",     :limit => 1
    t.string  "rid",    :limit => 10
  end

  add_index "raw_ringed_ducks", ["rar"], :name => "rar"
  add_index "raw_ringed_ducks", ["rca"], :name => "rca"
  add_index "raw_ringed_ducks", ["rcb"], :name => "rcb"
  add_index "raw_ringed_ducks", ["rq"], :name => "rq"
  add_index "raw_ringed_ducks", ["rx"], :name => "rx"

  create_table "ringer_captures", :id => false, :force => true do |t|
    t.string  "ringer_id", :limit => 3, :default => "", :null => false
    t.string  "sch",       :limit => 3, :default => "", :null => false
    t.string  "ringnr",    :limit => 8, :default => "", :null => false
    t.integer "occ",                                    :null => false
  end

  add_index "ringer_captures", ["sch", "ringnr", "occ"], :name => "sch"

  create_table "ringer_kooikers", :primary_key => "rid", :force => true do |t|
    t.integer "nearest_decoy_id"
    t.float   "decoy_distance"
    t.boolean "h1"
    t.boolean "h2"
    t.boolean "h3"
    t.boolean "minlv"
    t.boolean "expert"
    t.boolean "kooiker"
    t.boolean "kooiker_vermoed"
  end

  add_index "ringer_kooikers", ["nearest_decoy_id"], :name => "nearest_decoy_id"
  add_index "ringer_kooikers", ["h1"], :name => "h1"
  add_index "ringer_kooikers", ["h2"], :name => "h2"
  add_index "ringer_kooikers", ["h3"], :name => "h3"
  add_index "ringer_kooikers", ["kooiker"], :name => "kooiker"
  add_index "ringer_kooikers", ["kooiker_vermoed"], :name => "kooiker_vermoed"

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "species", :force => true do |t|
    t.text    "picture_url"
    t.text    "info_url"
    t.string  "name_nl",     :limit => 30
    t.string  "name_en",     :limit => 30
    t.integer "euring_id"
  end

  create_table "temp_geotab", :force => true do |t|
    t.string  "area",                   :limit => 4,                                 :default => "", :null => false
    t.string  "country_id",             :limit => 2
    t.string  "former_country_id",      :limit => 4
    t.string  "country_subdivision_id", :limit => 6
    t.string  "lat_dm",                 :limit => 4,                                 :default => "", :null => false
    t.string  "lon_dm",                 :limit => 4,                                 :default => "", :null => false
    t.string  "q",                      :limit => 1,                                 :default => "", :null => false
    t.string  "ca",                     :limit => 4,                                 :default => "", :null => false
    t.string  "cb",                     :limit => 4,                                 :default => "", :null => false
    t.decimal "lat",                                  :precision => 10, :scale => 7
    t.decimal "lon",                                  :precision => 10, :scale => 7
    t.string  "geoname",                :limit => 50,                                :default => "", :null => false
  end

  add_index "temp_geotab", ["area"], :name => "area"
  add_index "temp_geotab", ["lat_dm"], :name => "lat_dm"
  add_index "temp_geotab", ["lon_dm"], :name => "lon_dm"
  add_index "temp_geotab", ["q"], :name => "q"
  add_index "temp_geotab", ["ca"], :name => "ca"
  add_index "temp_geotab", ["cb"], :name => "cb"
  add_index "temp_geotab", ["geoname"], :name => "geoname"
  add_index "temp_geotab", ["lat", "lon"], :name => "lat"

  create_table "temp_merge_raw_captures", :id => false, :force => true do |t|
    t.string  "sch",    :limit => 3, :default => "", :null => false
    t.string  "ringnr", :limit => 8, :default => "", :null => false
    t.integer "occ",                                 :null => false
    t.string  "ca",     :limit => 4, :default => "", :null => false
    t.string  "cb",     :limit => 4, :default => "", :null => false
    t.string  "q",      :limit => 1, :default => "", :null => false
    t.string  "ar",     :limit => 4, :default => "", :null => false
    t.string  "a",      :limit => 1
    t.integer "age"
    t.string  "rid",    :limit => 3
  end

  add_index "temp_merge_raw_captures", ["ar"], :name => "ar"
  add_index "temp_merge_raw_captures", ["q"], :name => "q"
  add_index "temp_merge_raw_captures", ["ca"], :name => "ca"
  add_index "temp_merge_raw_captures", ["cb"], :name => "cb"
  add_index "temp_merge_raw_captures", ["age"], :name => "age"
  add_index "temp_merge_raw_captures", ["rid"], :name => "rid"

  create_table "year_all_distances", :force => true do |t|
    t.string  "species_id",     :limit => 100,                                :default => "", :null => false
    t.string  "sex",            :limit => 6
    t.string  "age",            :limit => 5,                                  :default => "", :null => false
    t.integer "year_dep",                                                                     :null => false
    t.decimal "distance",                      :precision => 10, :scale => 6
    t.decimal "distance_north",                :precision => 10, :scale => 6
  end

  add_index "year_all_distances", ["species_id"], :name => "species_id"

  create_table "year_distances", :force => true do |t|
    t.string  "species_id",          :limit => 100,                                :default => "", :null => false
    t.string  "sex",                 :limit => 6
    t.string  "age",                 :limit => 5,                                  :default => "", :null => false
    t.integer "year_dep",                                                                          :null => false
    t.decimal "distance",                           :precision => 10, :scale => 6
    t.decimal "distance_sd",                        :precision => 10, :scale => 6
    t.decimal "distance_sesm",                      :precision => 10, :scale => 6
    t.decimal "distance_north",                     :precision => 10, :scale => 6
    t.decimal "distance_north_sd",                  :precision => 10, :scale => 6
    t.decimal "distance_north_sesm",                :precision => 10, :scale => 6
    t.decimal "north_count",                        :precision => 10, :scale => 6
    t.decimal "south_count",                        :precision => 10, :scale => 6
  end

  add_index "year_distances", ["species_id"], :name => "species_id"

end
