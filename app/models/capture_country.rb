require 'rubygems'
require 'composite_primary_keys'
class CaptureCountry < ActiveRecord::Base
    set_primary_keys :sch, :ringnr, :occ
    belongs_to :capture, :foreign_key => [:sch, :ringnr, :occ]
    belongs_to :country
end

