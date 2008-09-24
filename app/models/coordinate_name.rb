require 'rubygems'
require 'composite_primary_keys'
class CoordinateName < ActiveRecord::Base
    set_primary_keys :sch, :ringnr, :occ
    #has_and_belongs_to_many :capture_coordinates, :foreign_key => [:lat, :lon]

end

