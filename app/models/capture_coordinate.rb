require 'rubygems'
require 'composite_primary_keys'
class CaptureCoordinate < ActiveRecord::Base
    set_primary_keys :sch, :ringnr, :occ
    belongs_to :capture, :foreign_key => [:sch, :ringnr, :occ]
    #has_and_belongs_to_many :coordinate_names, :foreign_key => [:lat, :lon]
end


