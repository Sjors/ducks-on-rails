class ProcessGeonames < ActiveRecord::Migration
  def self.up
    # With the full data set this takes up to 24 hours and generates a big load on geonames.org.
    # So if you plan to run this script more than once, please export the resulting tables and 
    # set PROCESS_GEONAMES=false in enviroment.rb. 
     
     add_column :capture_coordinates, :country_consistent, :boolean, :null=>true
     add_column :capture_coordinates, :country_subdivision_consistent, :boolean, :null=>true
     add_column :capture_coordinates, :country_subdivision_consistent_10k, :boolean, :null=>true
     add_column :capture_coordinates, :country_subdivision_geonames_no_iso, :boolean, :null=>true
     add_column :capture_countries, :derived_from_coordinates, :boolean, :null=>true
     add_column :capture_country_subdivisions, :derived_from_coordinates, :boolean, :null=>true
     if(PROCESS_GEONAMES == false) then
       if (!system SQL_IMPORT + "capture_countries.sql") then fail end
       if (!system SQL_IMPORT + "capture_country_subdivisions.sql") then fail end
       if (!system SQL_IMPORT + "capture_coordinates.sql") then fail end
     end
#    !!!Warning: the script below could take forever and cause significant traffic 
#    to geonames.org !!!
    if(PROCESS_GEONAMES == true) then
      require 'geonames'
      # For all captures...
      total = Capture.count
      # Sometimes the connection fails. In that case, replace 0 with a higher number to continue 
      # where the script left off. Also comment the "add_column" lines above.
      # The script devides the data in chunks of 1000 records, because ActiveRecord seems to load 
      # all records in memory, which causes a massive slow-down if there are lots of records.
      0.step(total, 1000) {|hapje|
        p hapje.to_s + " to " + (hapje + 999).to_s + " of " + total.to_s + "..."
        nummer = hapje
    
        for capture in Capture.find(:all, :limit => 1000, :offset => hapje)
          # Get coordinate from capture_coordinates and country from 
          # capture_countries (or NULL if no country).
          if (coordinate = capture.capture_coordinate) then
            # Get country code from Geonames. If the coordinate is on water, find the nearest country
            # within 50 kilometers.
            country_geonames = Geonames::WebService.country_code(coordinate.lat, coordinate.lon, 50 ).first.country_code
            # Verify country code if NOT NULL: if incorrect: mark
            if (country = capture.capture_country) then
              country_id = country.country_id
              if(country_geonames == country.country_id) then
                capture.capture_coordinate.update_attributes :country_consistent => true
              else
                capture.capture_coordinate.update_attributes :country_consistent => false
              end
            else 
            # For some captures the database contains no country information. This usually happens 
            # with countries that have split up (e.g. Soviet Union and Czechoslovakia). In that case
            # the table euring_former_country_to_iso can not provide a conversion. This problem can 
            # be (partially) solved if the table euring_country_subdivision_to_iso is completed and 
            # a script is created that uses this information to restore country information.   
            
            # Insert country code if NULL and mark as consistent. 
              if (country_geonames != "") then
                p "Insert nummer: " + (nummer-1).to_s + "."
                execute "INSERT INTO capture_countries (sch, ringnr, occ, country_id, derived_from_coordinates) 
                VALUES ('#{capture.sch}', '#{capture.ringnr}', '#{capture.occ}', '#{country_geonames}', 1)"
                capture.capture_coordinate.update_attributes :country_consistent => true
                country_id = country_geonames
              end
            end
          
            # Sometimes the bird was found close to a border and the coordinates were rounded
            # in such a way they ended up in the wrong country. This script
            # will tolerate an error of 10 kilometers for such cases.
            # It will query geonames to list all countries within 10 kilometers
            # and then compare.          
            if (capture.capture_coordinate.country_consistent == false) then 
              if (country = capture.capture_country) then
                countries_geonames = Geonames::WebService.country_code(coordinate.lat, coordinate.lon, 10, 10)
                consistent = false
                countries_geonames.each {|country_geonames|
                  if (country_geonames.country_code == country.country_id ) then 
                    consistent = true 
                  end
                }
                capture.capture_coordinate.update_attributes :country_consistent => consistent
              end
            end
            
            ## Now get the country subdivision from geonames.
            if (capture.capture_coordinate.country_consistent == true) then
              sub = Geonames::WebService.country_subdivision(coordinate.lat, coordinate.lon, 50)
              if (sub.size > 0) then
                if (sub.first.code_iso) then
                  country_subdivision_geonames = country_id + "-" + sub.first.code_iso
                else
                  country_subdivision_geonames = ""
                  capture.capture_coordinate.update_attributes :country_subdivision_geonames_no_iso => true
                end

              else
                country_subdivision_geonames = ""
              end
              if (country_subdivision = capture.capture_country_subdivision) then
                if(country_subdivision_geonames == country_subdivision.country_subdivision_id) then
                  capture.capture_coordinate.update_attributes :country_subdivision_consistent => true
                  capture.capture_coordinate.update_attributes :country_subdivision_consistent_10k => true
                else
                  capture.capture_coordinate.update_attributes :country_subdivision_consistent => false
                  # Sometimes the bird was found close to a border and the coordinates were rounded
                  # in such a way they ended up in the wrong country. This script
                  # will tolerate an error of 10 kilometers for such cases and note them in a seperate column.
                  # It will query geonames to list all country subdivisions within 10 kilometers
                  # and then compare.
            
                  country_subdivisions_geonames = Geonames::WebService.country_subdivision(coordinate.lat, coordinate.lon, 10, 10)
                  consistent = false
                  country_subdivisions_geonames.each {|country_subdivision_geonames|
                    if (country_subdivision_geonames.code_iso) then
                      if (country_id + "-" + country_subdivision_geonames.code_iso == country_subdivision.country_subdivision_id ) then 
                        consistent = true 
                      end
                    end
                  }
                  capture.capture_coordinate.update_attributes :country_subdivision_consistent_10k => consistent
                end
              else
                # Insert country_subdivision code if NULL and mark as consistent. 
                if (country_subdivision_geonames != "") then
                  if (
                    sub.first.country_code == country_id and
                    country_subdivision_geonames != "FI-AH"  and
                    country_subdivision_geonames != "FI-OU" and
                    country_subdivision_geonames != "RO-TU" and
                    country_subdivision_geonames != "RO-GG" and
                    country_subdivision_geonames != "RO-BL" and
                    country_subdivision_geonames != "RO-MU" and
                    country_subdivision_geonames != "RO-CR" and
                    country_subdivision_geonames != "RO-DO" and
                    country_subdivision_geonames != "SN-DA" and
                    country_subdivision_geonames != "SN-ZI" and
                    sub.first.country_code != "IT" and                 
                    sub.first.country_code != "FR" and                 
                    sub.first.country_code != "LU" and              
                    sub.first.country_code != "ES"                  
                  ) then
                    p "Insert nummer: " + (nummer-1).to_s + "."
                    execute "INSERT INTO capture_country_subdivisions (sch, ringnr, occ, country_subdivision_id, derived_from_coordinates) 
                    VALUES ('#{capture.sch}', '#{capture.ringnr}', '#{capture.occ}', '#{country_subdivision_geonames}', 1)"
                    capture.capture_coordinate.update_attributes :country_subdivision_consistent => true
                  end
                end
              end
            end
          end
          nummer = nummer + 1
        end
      }
    #!!!End of script that might take forever!!!
    end
  end

  def self.down
    remove_column :capture_coordinates, :country_consistent
    remove_column :capture_coordinates, :country_subdivision_consistent
    remove_column :capture_coordinates, :country_subdivision_consistent_10k
    remove_column :capture_coordinates, :country_subdivision_geonames_no_iso
    remove_column :capture_countries, :derived_from_coordinates
    remove_column :capture_country_subdivisions, :derived_from_coordinates
  end
end
