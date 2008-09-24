require 'rubygems'
require 'composite_primary_keys'
class Capture < ActiveRecord::Base
    set_primary_keys :sch, :ringnr, :occ
    belongs_to :duck, :foreign_key => [:sch, :ringnr], :include => [:species]
    delegate :species, :species=, :to => :duck
    has_one :capture_country, :foreign_key => [:sch, :ringnr, :occ]
    has_one :capture_country_subdivision, :foreign_key => [:sch, :ringnr, :occ]
    has_one :flight, :foreign_key => [:sch, :ringnr, :occ_start]
    has_one :flight, :foreign_key => [:sch, :ringnr, :occ_end]
    has_one :capture_coordinate, :foreign_key => [:sch, :ringnr, :occ]
    has_one :capture_former_country, :foreign_key => [:sch, :ringnr, :occ]
    has_one :capture_counts
    belongs_to :ringer_capture, :foreign_key => [:sch, :ringnr, :occ]


    def Country
      if a = self.capture_country then
        return a.country.name
      end
    end
    def FormerCountry
      if a = self.capture_former_country then
        return a.former_country.name
      end
    end
    def CountrySubdivision
      if a = self.capture_country_subdivision then
        return a.country_subdivision.name
      end
    end
    def Location
      if self.Country then 
        answer = self.Country.to_s
        if self.CountrySubdivision then
          answer << " (#{self.CountrySubdivision})"
        end
        return answer
      else 
        if self.FormerCountry then
          answer = "Former " + self.FormerCountry.to_s
        end
        return answer
      end
    end
    def Coordinates
      if a = self.capture_coordinate then
        return [a.lat, a.lon]
      end
    end
    def CoordinatesAsText
      if a = self.capture_coordinate then
        if a.lat < 0 then lat_q = "South" else lat_q = "North" end
        if a.lon < 0 then lon_q = "West" else lon_q = "East" end

        lat_degrees = a.lat.abs.to_i
        lat_minutes = ((a.lat.abs - lat_degrees) * 60).to_i
        lat_seconds = ((a.lat.abs - lat_degrees - lat_minutes/60.0) * 3600).to_i

        lon_degrees = a.lon.abs.to_i
        lon_minutes = ((a.lon.abs - lon_degrees) * 60).to_i
        lon_seconds = ((a.lon.abs - lon_degrees - lon_minutes/60.0) * 3600).to_i
        return "#{lat_degrees}° #{lat_minutes}' #{lat_seconds}\" #{lat_q},#{lon_degrees}° #{lon_minutes}' #{lon_seconds}\" #{lon_q}"
      end
    end
    def CoordinateInfo
      if a = self.capture_coordinate then
        if b = CoordinateName.find(:all, :conditions => {:lat => a.lat, :lon => a.lon}) then
          return b
        end
      end
    end
    def Ringer
      a = RingerCapture.find(:first, :conditions => {:sch => self.sch, :ringnr => self.ringnr, :occ => self.occ})
      if a then 
        return a.nl_vts_address
      end
    end
end
